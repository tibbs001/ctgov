require 'faraday'
require 'nokogiri'
require 'net/http'
require 'zip'

	class Asker

		attr_accessor :existing_nct_ids, :should_refresh, :all_studies_file_name

		def existing_nct_ids
			@existing_nct_ids ||= Study.all_nctids
		end

    def imported_dir
			# obsolete
      "#{Rails.root}/public/imported/"
    end

    def downloaded_dir
		# obsolete
      "#{Rails.root}/public/downloaded/"
    end





		def preprocess_dir
			'public/studies/preprocessed'
		end

		def incoming_dir
			'public/studies/incoming'
		end

		def duplicate_dir
			'public/studies/duplicate'
		end

		def new_dir
			'public/studies/new'
		end

		def changed_dir
			'public/studies/changed'
		end

		def loaded_dir
			'public/studies/loaded'
		end

		def all_studies_file_name
			date_stamp=Time.now.strftime("%Y%m%d")
			@all_studies_file_name ||= "#{date_stamp}_all.zip"
		end

		def url_to_get_all
			'https://clinicaltrials.gov/search?term=pancreatic+cancer+vaccine&resultsxml=true'
			#'http://clinicaltrials.gov/search?term=&resultsxml=true'
		end

		def daily_loader
			pull_down_studies  # New studies put into public/studies/new.  Changed studies put into public/studies/changed.
			load_new_studies
			update_changed_studies
		end

		def load_new_studies
			Dir.glob("#{new_dir}/NCT*.xml") {|f|
				begin
				  nct_id=f.split('/').last.split('.').first
				  xml=Nokogiri::XML(File.open(f,"rb"){|io|io.read})
					ActiveRecord::Base.transaction do
			      Study.new({:xml=>xml,:nct_id=>nct_id}).create
					end
				  FileUtils.move f, loaded_dir
			  rescue => error
			    e=log_event({:nct_id=>nct_id,:event_type=>'load new study',:status=>'failed',:description=>error})
				  e.save!
				end
			}
		end

		def update_changed_studies
			#TODO   Ideally we will only update values that change, not the whole study.  For now, we remove and recreate.
			Dir.glob("#{changed_dir}/NCT*.xml") {|f|
				begin
				  nct_id=f.split('/').last.split('.').first
				  xml=Nokogiri::XML(File.open(f,"rb"){|io|io.read})
					ActiveRecord::Base.transaction do
			    	remove_study({:nct_id=>nct_id,:msg=>'study changed'})
			      Study.new({:xml=>xml,:nct_id=>nct_id}).create
					end
				  FileUtils.move f, loaded_dir
			  rescue => error
			    e=log_event({:nct_id=>nct_id,:event_type=>'update study',:status=>'failed',:description=>error})
				  e.save!
				end
			}
		end

		def pull_down_studies
			FileUtils.rm_rf Dir.glob("#{preprocess_dir}/*.xml")
			system("curl -vs '#{url_to_get_all}' > #{preprocess_dir}/#{all_studies_file_name};
							cd #{preprocess_dir};
							unzip #{all_studies_file_name}")

			Dir.glob("#{preprocess_dir}/NCT*.xml") do |f|
				# remove lines that will trick us into thinkin the study changed"
				file_name=f.split("/").last
				system("sed '/<download_date>/d' #{f} > #{incoming_dir}/#{file_name}")
			end

			Dir.glob("#{incoming_dir}/NCT*.xml") do |f|
				file_name=f.split("/").last
				loaded_file="#{loaded_dir}/#{file_name}"
				if !File.exist?(loaded_file)
				  FileUtils.move f, new_dir
				else
					if !FileUtils.identical?(f,loaded_file)
				  	FileUtils.move f, changed_dir
					else
						#TODO  Create a LoadEvent to report this  -or- log to a file?
						puts "Study hasn't changed since last load.  Skipping #{file_name}"
					end
				end
			end
			FileUtils.rm_rf Dir.glob("#{preprocess_dir}/*.xml")
			#(0..9).each {|digit| system("mv public/preprocessed_studies/*#{digit}.xml public/preprocessed_studies/#{format('%02d',digit)}") }
		end

		def ad_hoc_load_downloaded_files
			Dir.glob("#{downloaded_dir}/NCT*.xml") {|f|
				begin
				  nct_id=f.split('/').last.split('.').first
				  xml=Nokogiri::XML(File.open(f,"rb"){|io|io.read})
					ActiveRecord::Base.transaction do
			      Study.new({:xml=>xml,:nct_id=>nct_id}).create
					end
				  FileUtils.move f, imported_dir
			  rescue => error
			    e=log_event({:nct_id=>nct_id,:event_type=>'express load',:status=>'failed',:description=>error})
				  e.save!
				end
			}
		end

		def load_all_from_zip_file(file_name="#{downloaded_dir}/all.zip")
			Zip::ZipFile.open(file_name){|zip_file|
				zip_file.each {|f|
					  nct_id=f.name.split('.').first
					  xml=Nokogiri::XML(zip_file.read(f))
			      Study.new({:xml=>xml,:nct_id=>nct_id}).create
				}
      }
		end

		def self.create_all_studies(opts={})
			self.new.create_all_studies(opts)
		end

		def self.full_search(opts={})
		  self.new.full_search(opts)
		end

		def full_search(opts)
			if opts.class==String
				term=opts
				@should_refresh=true  #default to true
			else
			  term=opts[:term]
			  @should_refresh=opts[:should_refresh]
			end
			nct_ids=[]
			search_datestamp=Time.now
			file_name=pull_data_from_ctgov(opts)
			Zip::ZipFile.open(file_name){|zip_file|
				zip_file.each {|f|
					nct_id=f.name.split('.').first
					create_study(nct_id)
				  create_search_result({:nct_id=>nct_id,:search_term=>term,:search_datestamp=>search_datestamp})
				}
      }
			nct_ids
		end

		def self.brief_search(opts={})
		  self.new.brief_search(opts)
		end

		def brief_search(opts)
			if opts.class==String
				term=opts
			  @should_refresh=true
			else
			  term=opts[:term]
			  @should_refresh=opts[:should_refresh]
			end
			search_datestamp=Time.now
			query_url="https://clinicaltrials.gov/search?term=#{term}&displayxml=true"
			nodes = Nokogiri::XML(call_to_ctgov(query_url)).xpath('//clinical_study')
			nodes.each{|node|
				nct_id=node.xpath('nct_id').inner_html
				order=node.xpath('order').inner_html
				score=node.xpath('score').inner_html
				create_study(nct_id)
				create_search_result({:nct_id=>nct_id,:search_term=>term,:search_datestamp=>search_datestamp,:order=>order,:score=>score})
			}
		end

		def create_all_studies(opts={})
			@should_refresh=opts[:should_refresh]
			collection=[]
			ctgov_pages.each {|page|
				tries=50
				query_url="https://clinicaltrials.gov/#{page}"
				Nokogiri::HTML(call_to_ctgov(query_url)).css('.layout_table').search('a').each { |link|
					nct_id=link['href'].split('/').last
					if (existing_nct_ids.include? nct_id) && !should_refresh
	          log_event({:nct_id=>nct_id,:event_type=>'skipped',:status=>'complete',:description=>'already exists'})
					else
						create_study(nct_id)
					end
				}
			}
		end

		def remove_study(opts)
			if opts.class==String
			  nct_id=opts
			  msg=''
			else
			  nct_id=opts[:nct_id]
			  msg=opts[:msg]
			end
	    e=log_event({:nct_id=>nct_id,:event_type=>'remove',:status=>'active',:description=>msg})
			Study.where('nct_id=?',nct_id).first.try(:destroy)
			e.complete
		end

		def get_study(nct_id)
			url="http://clinicaltrials.gov/show/#{nct_id}?resultsxml=true"
			xml=Nokogiri::XML(call_to_ctgov(url))
			Study.new({:xml=>xml,:nct_id=>nct_id})
		end

		def create_search_result(opts)
      e=log_event({:nct_id=>opts[:nct_id],:event_type=>'search_result',:status=>'active'})
			s=SearchResult.new(opts)
			s.save!
			e.complete
			return s
		end

		def create_study(opts)
			if opts.class==String
			  nct_id=opts
			else
			  nct_id=opts[:nct_id]
			  @should_refresh=opts[:should_refresh]
			end
			if Study.where('nct_id=?',nct_id).size > 0
			  if !should_refresh
					"Exists and should not refresh.  Do nothing"
				else
			    remove_study({:nct_id=>nct_id,:msg=>'remove existing pre-creation'})
				end
			end

		#	begin
			  e=log_event({:nct_id=>nct_id,:event_type=>"create",:status=>'active'})
			  study=get_study(nct_id).create
				study.save!
			  existing_nct_ids << nct_id
				e.complete
			  return study
		#	rescue => error
		#		msg="Failed: #{error}"
		#		puts msg
		#	  e.status='failed'
		#	  e.description=msg
		#		e.save!
		#	end
		end

		def log_event(opts={})
			e=LoadEvent.new(:nct_id=>opts[:nct_id],:event_type=>opts[:event_type],:status=>opts[:status],:description=>opts[:description])
			e.start_clock
			e.save!
			e
		end

		def self.get(nct_id)
			self.new.get_study(nct_id)
		end

		def ctgov_pages
			collection=[]
			response=call_to_ctgov('https://clinicaltrials.gov/ct2/crawl')
			Nokogiri::HTML(response).css('.layout_table').search('a').each {|link| collection << link['href']}
			collection
		end

		def call_to_ctgov(query_url)
			begin
			  tries=50
				Faraday.get(query_url).body
			rescue => error
				tries = tries-1
				if tries > 0
					puts "> call to ct.gov failed.  #{error}  "
					sleep(5)
					retry
				else
					puts "Repeatedly tried: #{query_url}. Should I give up?"
				end
			end
	  end

		def self.get_coordinates(addr)
			new.coordinates_for(geo_url(addr))
		end

		def coordinates_for(url)
			#TODO Fix this to be accurate
			coordinates={}
      loc=location(url)
			coordinates[:latitude] = loc.xpath('lat').first.try(:inner_html)
			coordinates[:longitude] = loc.xpath('lng').first.try(:inner_html)
			coordinates
		end

		def location(url)
			response=Faraday.get(url).body
			Nokogiri::XML(response).xpath('//GeocodeResponse').xpath('result').xpath('geometry').xpath('location')
		end

		def self.geo_url(addr)
			"https://maps.googleapis.com/maps/api/geocode/xml?address=#{addr}&key=#{google_api_key}"
		end

		def self.google_api_key
			#TODO when official, move out to an environment variable
			'AIzaSyCocTrzXt-OPhhk0dBQW3JLetZUDMme9gk'
		end

		def google_api_key
			'AIzaSyCocTrzXt-OPhhk0dBQW3JLetZUDMme9gk'
		end
  end
