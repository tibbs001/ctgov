class Study < ActiveRecord::Base
  searchkick

  scope :interventional,  -> {where(study_type: 'Interventional')}
  scope :observational,   -> {where(study_type: 'Observational')}
  scope :current, -> { where("first_received_date >= '2007/10/01' and study_type='Interventional'") }

  def self.current_interventional
    self.interventional and self.current
  end

  self.primary_key = 'nct_id'
  has_one  :brief_summary,         :foreign_key => 'nct_id', dependent: :delete
  has_one  :design,                :foreign_key => 'nct_id', dependent: :delete
  has_one  :detailed_description,  :foreign_key => 'nct_id', dependent: :delete
  has_one  :eligibility,           :foreign_key => 'nct_id', dependent: :delete
  has_one  :participant_flow,      :foreign_key => 'nct_id', dependent: :delete
  has_one  :calculated_value,      :foreign_key => 'nct_id', dependent: :delete
  has_one  :study_xml_record,      :foreign_key => 'nct_id'

  has_many :design_outcomes,       :foreign_key => 'nct_id', dependent: :delete_all
  has_many :design_groups,         :foreign_key => 'nct_id', dependent: :delete_all
  has_many :design_group_interventions, :foreign_key => 'nct_id', dependent: :delete_all
  has_many :id_information,        :foreign_key => 'nct_id', dependent: :delete_all
  has_many :drop_withdrawals,      :foreign_key => 'nct_id', dependent: :delete_all
  has_many :result_groups,         :foreign_key => 'nct_id', dependent: :delete_all
  has_many :baseline_measures,     :foreign_key => 'nct_id', dependent: :delete_all
  has_many :reported_events,       :foreign_key => 'nct_id', dependent: :delete_all
  has_many :outcome_analyses,      :foreign_key => 'nct_id', dependent: :delete_all
  has_many :outcome_measured_values, :foreign_key => 'nct_id', dependent: :delete_all
  has_many :browse_conditions,     :foreign_key => 'nct_id', dependent: :delete_all
  has_many :browse_interventions,  :foreign_key => 'nct_id', dependent: :delete_all
  has_many :central_contacts,      :foreign_key => 'nct_id', dependent: :delete_all
  has_many :conditions,            :foreign_key => 'nct_id', dependent: :delete_all
  has_many :countries,             :foreign_key => 'nct_id', dependent: :delete_all
  has_many :facilities,            :foreign_key => 'nct_id', dependent: :delete_all
  has_many :facility_contacts,     :foreign_key => 'nct_id', dependent: :delete_all
  has_many :facility_investigators,:foreign_key => 'nct_id', dependent: :delete_all
  has_many :interventions,         :foreign_key => 'nct_id', dependent: :delete_all
  has_many :intervention_other_names, :foreign_key => 'nct_id', dependent: :delete_all
  has_many :keywords,              :foreign_key => 'nct_id', dependent: :delete_all
  has_many :links,                 :foreign_key => 'nct_id', dependent: :delete_all
  has_many :milestones,            :foreign_key => 'nct_id', dependent: :delete_all
  has_many :outcomes,              :foreign_key => 'nct_id', dependent: :delete_all
  has_many :overall_officials,     :foreign_key => 'nct_id', dependent: :delete_all
  has_many :oversight_authorities, :foreign_key => 'nct_id', dependent: :delete_all
  has_many :responsible_parties,   :foreign_key => 'nct_id', dependent: :delete_all
  has_many :result_agreements,     :foreign_key => 'nct_id', dependent: :delete_all
  has_many :result_contacts,       :foreign_key => 'nct_id', dependent: :delete_all
  has_many :sponsors,              :foreign_key => 'nct_id', dependent: :delete_all
  has_many :references,            :foreign_key => 'nct_id', dependent: :delete_all
  has_many :reviews,               :foreign_key => 'nct_id', dependent: :delete_all
  has_many :clinical_domains,      :foreign_key => 'nct_id', dependent: :delete_all

  scope :started_between, lambda {|sdate, edate| where("start_date >= ? AND created_at <= ?", sdate, edate )}
  scope :changed_since,   lambda {|cdate| where("last_changed_date >= ?", cdate )}
  scope :completed_since, lambda {|cdate| where("completion_date >= ?", cdate )}
  scope :sponsored_by,    lambda {|agency| joins(:sponsors).where("sponsors.agency LIKE ?", "#{agency}%")}

		def self.all_nctids
		  all.collect{|s|s.nct_id}
		end

    def start_date
      start_month_year
    end

    def summary
      #TODO brief_summary.description
      'not available'
    end

    def elig_criteria
      ''
    end

    def sampling_method
      eligibility.sampling_method
    end

		def study_population
			eligibility.study_population
		end

		def study_references
			references.select{|r|r.type!='results_reference'}
		end

    def result_references
      references.select{|r|r.type=='results_reference'}
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

		def recruitment_details
			result_detail.try(:recruitment_details)
		end

		def pre_assignment_details
			result_detail.try(:pre_assignment_details)
		end

		def lead_sponsor
			#TODO  May be multiple
			sponsors.each{|s|return s if s.sponsor_type=='lead'}
		end

		def average_rating
			if reviews.size==0
				0
			else
				reviews.average(:rating).round(2)
			end
		end

		def intervention_names
			interventions.collect{|x|x.name}.join(', ')
		end

		def condition_names
			conditions.collect{|x|x.name}.join(', ')
		end

		def prime_address
			#  This isn't real.  Just proof of concept.
			return facilities.first.address if facilities.size > 0
			#return lead_sponsor.agency
      "300 West Morgan St, Durham, NC  27701"
		end

	end
