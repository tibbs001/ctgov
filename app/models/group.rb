	class Group < StudyRelationship
		attr_accessor :baseline_measures

		has_many :outcomes, dependent: :destroy
		has_many :outcome_measures, dependent: :destroy
		has_many :outcome_analyses, dependent: :destroy
		has_many :milestones, dependent: :destroy
		has_many :drop_withdrawals, dependent: :destroy

		def self.create_all_from(opts)
			opts[:xml]=opts[:study_xml].xpath('//participant_flow')
			groups=pop_create(opts.merge(:name=>'group'))
			opts[:xml]=opts[:study_xml].xpath('//outcome_list')
			additional_groups=pop_create(opts.merge(:name=>'group'))
			opts[:groups]=groups
			groups
		end

		def attribs
			{
			 :ctgov_group_id => get_attribute('group_id'),
			 :ctgov_group_enumerator => integer_in(get_attribute('group_id')),
			 :description => get('description'),
			 :title => get('title'),
			 :participant_count => get_attribute('count').to_i,
			 :derived_participant_count => calc_participant_count,
			}
		end

		def baseline_measures
			@baseline_measures ||=BaselineMeasure.where("nct_id=? and ctgov_group_enumerator=?",nct_id,ctgov_group_enumerator)
		end

		def calc_participant_count
			# best guess for this group
			values=[]
			results={}
			outcome_measures.each{|om|values << om.measure_value if om.title=='Number of Participants' && om.outcome.outcome_type=='Primary'}
			values.uniq.each{|val| results[val] = values.count(val)}
			max=0
			results.each{|x,y| max=x.to_i if y > max}
			max
		end

end
