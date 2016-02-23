require 'faraday'
require 'nokogiri'
require 'net/http'
require 'zip'

	class Asker

		attr_accessor :existing_nct_ids, :should_refresh

		def existing_nct_ids
			@existing_nct_ids ||= Study.all_nctids
		end

		def load_files
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
			Study.where('nct_id=?',nct_id).first.destroy
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

    def imported_dir
      "#{Rails.root}/public/imported/"
    end

    def downloaded_dir
      "#{Rails.root}/public/downloaded/"
    end

		def google_api_key
			'AIzaSyCocTrzXt-OPhhk0dBQW3JLetZUDMme9gk'
		end
  end
