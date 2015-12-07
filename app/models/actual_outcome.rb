	class ActualOutcome < StudyRelationship
		attr_accessor :milestones, :drop_withdrawals, :outer_xml

		has_many :outcome_measures
		has_many :outcome_analyses

		def self.create_all_from(opts={})
			all=opts[:xml].xpath('//clinical_results').xpath("outcome_list").xpath('outcome')
			col=[]
			xml=all.pop
			while xml
				opts[:type]=xml.xpath('type').inner_html
				opts[:title]=xml.xpath('title').inner_html
				opts[:description]=xml.xpath('description').inner_html
				opts[:time_frame]=xml.xpath('time_frame').inner_html
				opts[:safety_issue]=xml.xpath('safety_issue').inner_html
				opts[:population]=xml.xpath('population').inner_html
				opts[:xml]=xml
				col << self.nested_pop_create(opts.merge(:name=>'group'))
				xml=all.pop
			end
			col.flatten
		end

		def self.nested_pop_create(opts)
			name=opts[:name]
			opts[:outer_xml]=opts[:xml]
			all=opts[:xml].xpath("#{name}_list").xpath(name)
			col=[]
			xml=all.pop
			if xml.blank?
				col << self.create_from(opts)
			else
				while xml
					opts[:xml]=xml
					col << self.create_from(opts)
					xml=all.pop
				end
			end
			col.flatten
		end

		def attribs
			{
			 :group_description => get('description'),
			 :group_title => get('title'),
			 :participant_count => get_attribute('count').to_i,
			}
		end

		def create_from(opts={})

			@outer_xml=opts[:outer_xml]
			gid=opts[:xml].attribute('group_id').try(:value)
			self.ctgov_group_id = gid
			self.ctgov_group_enumerator = integer_in(gid)
			self.outcome_type = opts[:type]
			self.title        = opts[:title]
			self.time_frame   = opts[:time_frame]
			self.safety_issue = opts[:safety_issue]
			self.population   = opts[:population]
			self.description  = opts[:description]
			super
			self.outcome_measures=OutcomeMeasure.create_all_from(opts.merge(:xml=>outer_xml,:group_id_of_interest=>gid))
			self.outcome_analyses=OutcomeAnalysis.create_all_from(opts.merge(:xml=>outer_xml,:group_id_of_interest=>gid))
			self
		end

		##############################################################################################
		def milestones
			@milesones ||=Milestone.where("nct_id=? and ctgov_group_enumerator=?",nct_id,ctgov_group_enumerator)
		end

		def drop_withdrawals
			@drop_withdrawals ||=DropWithdrawal.where("nct_id=? and ctgov_group_enumerator=?",nct_id,ctgov_group_enumerator)
		end

		def measures
			outcome_measures
		end

		def analyses
			outcome_analyses
		end

		def type
			outcome_type
		end

	end
