#module OpenTrials
	class ClinicalDomain < ActiveRecord::Base
		#establish_connection "open_#{Rails.env}".to_sym
		belongs_to :study, :foreign_key=> 'nct_id'
		belongs_to :user
		belongs_to :clinical_category

	end
#end
