	class Group < StudyRelationship
		attr_accessor :baseline_measures

		has_many :outcomes, dependent: :destroy
		has_many :outcome_measures, dependent: :destroy
		has_many :outcome_analyses, dependent: :destroy
		has_many :milestones, dependent: :destroy
		has_many :drop_withdrawals, dependent: :destroy

		def self.create_all_from(opts)
			opts[:xml]=opts[:xml].xpath('//participant_flow')
			groups=pop_create(opts.merge(:name=>'group'))
			opts[:groups]=groups
			Outcome.create_all_from(opts)
			Milestone.create_all_from(opts)
			DropWithdrawal.create_all_from(opts)
			groups
		end

		def attribs
			{
			 :ctgov_group_id => get_attribute('group_id'),
			 :ctgov_group_enumerator => integer_in(get_attribute('group_id')),
			 :description => get('description'),
			 :title => get('title'),
			 :participant_count => get_attribute('count').to_i,
			}
		end

		def baseline_measures
			@baseline_measures ||=BaselineMeasure.where("nct_id=? and ctgov_group_enumerator=?",nct_id,ctgov_group_enumerator)
		end

end
