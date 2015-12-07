	class Eligibility < StudyRelationship

		def attribs
			{
				:sampling_method=>get('sampling_method'),
				:study_population=>get_text('study_pop'),
				:maximum_age=>get('maximum_age'),
				:minimum_age=>get('minimum_age'),
				:gender=>get('gender'),
				:healthy_volunteers=>get('healthy_volunteers'),
				:criteria=>get_text('criteria')
			}
		end

		def get(label)
			#  override the superclass to search for label from the top of the doc
			xml.xpath("//#{label}").inner_html
		end

		def self.with_exclusion_criteria
			where("lower(study_population) like '%exclusion criter%'")
		end

		def self.with_inclusion_criteria
			where("lower(study_population) like '%inclusion criter%'")
		end

		def inclusion_criteria
		  (study_population.split('Inclusion Criteria')).each{|x| puts x}
	  end
	end
