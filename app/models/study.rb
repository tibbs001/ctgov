require 'csv'
	class Study < ActiveRecord::Base
		establish_connection "ctgov_#{Rails.env}".to_sym if Rails.env != 'test'

		self.primary_key = 'nct_id'
		has_one  :brief_summary,        :foreign_key => 'nct_id', dependent: :destroy
		has_one  :design,               :foreign_key => 'nct_id', dependent: :destroy
		has_one  :detailed_description, :foreign_key => 'nct_id', dependent: :destroy
		has_one  :eligibility,          :foreign_key => 'nct_id', dependent: :destroy
		has_one  :result_detail,        :foreign_key => 'nct_id', dependent: :destroy

		has_many :expected_groups,       :foreign_key => 'nct_id', dependent: :destroy
		has_many :expected_outcomes,     :foreign_key => 'nct_id', dependent: :destroy
		has_many :groups,                :foreign_key => 'nct_id', dependent: :destroy
		has_many :outcomes,              :foreign_key => 'nct_id', dependent: :destroy
		has_many :baseline_measures,     :foreign_key => 'nct_id', dependent: :destroy
		has_many :browse_conditions,     :foreign_key => 'nct_id', dependent: :destroy
		has_many :browse_interventions,  :foreign_key => 'nct_id', dependent: :destroy
		has_many :conditions,            :foreign_key => 'nct_id', dependent: :destroy
		has_many :drop_withdrawals,      :foreign_key => 'nct_id', dependent: :destroy
		has_many :facilities,            :foreign_key => 'nct_id', dependent: :destroy
		has_many :interventions,         :foreign_key => 'nct_id', dependent: :destroy
		has_many :keywords,              :foreign_key => 'nct_id', dependent: :destroy
		has_many :links,                 :foreign_key => 'nct_id', dependent: :destroy
		has_many :milestones,            :foreign_key => 'nct_id', dependent: :destroy
		has_many :location_countries,    :foreign_key => 'nct_id', dependent: :destroy
		has_many :outcome_measures,      :foreign_key => 'nct_id', dependent: :destroy
		has_many :overall_officials,     :foreign_key => 'nct_id', dependent: :destroy
		has_many :oversight_authorities, :foreign_key => 'nct_id', dependent: :destroy
		has_many :periods,               :foreign_key => 'nct_id', dependent: :destroy
		has_many :reported_events,       :foreign_key => 'nct_id', dependent: :destroy
		has_many :responsible_parties,   :foreign_key => 'nct_id', dependent: :destroy
		has_many :result_agreements,     :foreign_key => 'nct_id', dependent: :destroy
		has_many :result_contacts,       :foreign_key => 'nct_id', dependent: :destroy
		has_many :secondary_ids,         :foreign_key => 'nct_id', dependent: :destroy
		has_many :sponsors,              :foreign_key => 'nct_id', dependent: :destroy
		has_many :study_references,      :foreign_key => 'nct_id', dependent: :destroy
		has_many :result_references,     :foreign_key => 'nct_id', dependent: :destroy

		scope :started_between, lambda {|sdate, edate| where("start_date >= ? AND created_at <= ?", sdate, edate )}
		scope :changed_since,   lambda {|cdate| where("last_changed_date >= ?", cdate )}
		scope :completed_since, lambda {|cdate| where("completion_date >= ?", cdate )}
		scope :sponsored_by,    lambda {|agency| joins(:sponsors).where("sponsors.agency LIKE ?", "#{agency}%")}

		def self.all_nctids
		  all.collect{|s|s.nct_id}
		end

		def create_from(hash)
			update_attributes(hash)
			self
		end

		def actual_duration_days
			# TODO  Store value in table?
			completion_date.mjd - start_date.mjd if completion_date
		end

		def references
			study_references + result_references
		end

		def description
			detailed_description.description
		end

		def summary
			brief_summary.description
		end

		def all_outcomes(exp_act='actual',prim_sec='primary')
			if exp_act=='expected'
				expected_outcomes.select {|o| o.outcome_type==prim_sec}
			else
				outcomes.select{|o|o.outcome_type==prim_sec}
			end
		end

		def recruitment_details
			result_detail.try(:recruitment_details)
		end

		def pre_assignment_details
			result_detail.try(:pre_assignment_details)
		end

		def gender
			eligibility.try(:gender)
		end

		def criteria
			eligibility.try(:criteria)
		end

		def sampling_method
			eligibility.sampling_method
		end

		def study_population
			eligibility.study_population
		end

		def healthy_volunteers?
			eligibility.healthy_volunteers
		end

		def minimum_age
			eligibility.minimum_age
		end

		def maximum_age
			eligibility.maximum_age
		end

		def age_range
			"#{minimum_age} - #{maximum_age}"
		end

		def lead_sponsor
			sponsors.select{|s|s.sponsor_type=='lead'}.first
		end

		def collaborators
			sponsors.select{|s|s.sponsor_type=='collaborator'}
		end

		def lead_sponsor_name
			lead_sponsor.try(:agency)
		end

		def number_of_sites
			facilities.size
		end

		def counted_num_sites
			facilities.size
		end

		def ctms_study
			CtmsStudy.where('nct_id=?',nct_id).first
		end

		def number_of_sites
			facilities.size
		end

		def act_num_sites
			# TODO filter on actual
			#facilities.size
		end

		def est_num_sites
			# TODO filter on estimated
			facilities.size
		end

		def drug_product
			expected_groups.collect{|c|c.title}.join(",")
		end

		def dcri_services_provided
			nil
		end

		def product_actual
			groups.collect{|c|c.title}.join(",")
		end

		def self.create_all
			Asker.create_all_studies
		end

		def self.recruitment_info
			column_headers= ['nct_id','phase','status','study_type','enrollment_type','enrollment','min_age','max_age','gender','healthy_volunteer','population','start','completion']
			CSV.open("recruitment_info.csv", "wb", :write_headers=> true, :headers => column_headers) {|csv|
				all.each{|s|
					csv << [s.nct_id,s.phase,s.status,s.study_type,s.enrollment_type,s.enrollment,s.minimum_age,s.maximum_age,s.gender,s.healthy_volunteers?,s.study_population,s.start_date,s.completion_date]
				}
			}
		end

		def self.countries_studying(condition)
			nct_ids=[]
			locations=[]
			column_headers= ['nct_id','brief_title','study_type','phase','status','start_date','completion_date','enrollment','org_study_id','country']
			BrowseCondition.where('mesh_term=?',condition).each{|x| nct_ids << x.nct_id}

			nct_ids.uniq.each{|x|
				LocationCountry.where('nct_id=?',x).each {|lc|locations << lc}
				CSV.open("#{condition}.csv", "wb", :write_headers=> true, :headers => column_headers) {|csv| locations.each {|l|
							 csv << [l.nct_id,l.study.brief_title,l.study.study_type,l.study.phase,l.study.status,l.study.start_date,l.study.completion_date,l.study.enrollment,l.study.org_study_id,l.country]}
				}
			}
		end

		def self.irb_headers
			['DOCR_NCT_CODE','DSR_INSERT_DATE_TIME','ID','SHORT_TITLE','TITLE',
			 'NAME','TYPE','TYPECODE','ALIAS','PROTOCOL_TYPE','REVIEW_TYPE',
			 'CREATED_ON','REVIEWED_ON','APPROVED_ON','EXPIRES_ON','PREVIOUSLY_EXPIRED_ON',
			 'STATUS','DEPARTMENT','DIVISION','CRU','PI_DUKEID','PI_FIRST_NAME','PI_LAST_NAME',
			 'IRB_LEGACY_ID','FEDERAL_ID','BIOBANKING','BLOOD_DRAWS','MTA_AGREEMENT_REQUIRED',
			 'DOCR_NCT_CODE','BLOOD_DRAWS_PER_WEEK','BLOOD_DRAWS_MAXIMUM_AMOUNT','SPS_NUMBER',
			 'ENROLLMENT_MAX_AT_ALL_SITES','ENROLLMENT_MAX_AT_DUKE']
		end

		def self.headers
			(Study.first.attributes.collect{|a|a.first} +
			 ['sponsor','responsible_party','number_of_sites','drug_product','product_actual']).flatten
		end

		def self.irb_data
			asker=Asker.new
			column_headers=(irb_headers + headers).flatten
			CSV.open("irb_data_out.csv", "wb",:write_headers=> true,:headers =>column_headers) {|csv|
				row_count=0
				CSV.foreach('irb_data.csv', :headers => true, :encoding => 'windows-1251:utf-8') do |row|
					begin
						row_count=row_count+1
						id=row['DOCR_NCT_CODE']
			if id
							nct_id=id.split(' ').first if id
							s=asker.create_study(nct_id) if (nct_id[/^NCT/])
			end
				if s
				s.attributes.each{|a|row << [a.first,"#{a.last.to_s.gsub(/\n/," ")}"]}
				row << ['sponsor',s.lead_sponsor_name]
				row << ['responsible_party',s.responsible_parties.first.label] if s.responsible_parties.size==1
				row << ['number_of_sites',s.number_of_sites]
				row << ['drug_product',s.drug_product]
				row << ['product_actual',s.product_actual]
				csv << row
			else
							csv << row
			end
					rescue => e
						msg="Failed on row #{row_count}: #{row}: #{e}"
						logger.info(msg)
						csv << row
					end
				end
			}
		end

		def pi
			val=''
			responsible_parties.each{|r|val=r.investigator_full_name if r.responsible_party_type=='Principal Investigator'}
			val
		end

		def status
			overall_status
		end

		def name
			brief_title
		end

		def funding_source
			nil  #epm and irb are better sources
		end

		def therapeutic_area
			conditions.collect{|c|c.name}.join(",")
		end

		def start_year
			start_date
		end

		def end_year
		 completion_date if completion_date_type=='Actual'
		end

		def drug_product
			expected_groups.collect{|c|c.title}.join(",")
		end

	end
