	class ActualGroup < StudyRelationship
		attr_accessor :milestones, :drop_withdrawals, :baseline_measures

		def self.create_all_from(opts)
			opts[:xml]=opts[:xml].xpath('//participant_flow')
			pop_create(opts.merge(:name=>'group'))
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

		##############################################################################################

		def milestones
			@milesones ||=Milestone.where("nct_id=? and ctgov_group_enumerator=?",nct_id,ctgov_group_enumerator)
		end

		def drop_withdrawals
			@drop_withdrawals ||=DropWithdrawal.where("nct_id=? and ctgov_group_enumerator=?",nct_id,ctgov_group_enumerator)
		end

		def baseline_measures
			@baseline_measures ||=BaselineMeasure.where("nct_id=? and ctgov_group_enumerator=?",nct_id,ctgov_group_enumerator)
		end

		#  sample report
		def self.summary
			column_headers= ['nct_id','study_start','study_completion','ctgov_group_id','group_title','baseline_participant_count','period','milestone','milestone_count','drop_withdrawal_reason','drop_withdrawal_count']
			CSV.open("study_group_report.csv", "wb", :write_headers=> true, :headers => column_headers) {|csv|
				all.each{|g|
			periods=g.milestones.collect{|m|m.period.title}.flatten.uniq
			g.milestones.each{|m|
				period=m.period.try(:title)
				milestone=m.title
				m_count=m.participant_count
				baseline=BaselineMeasure.where("nct_id=? and ctgov_group_enumerator=? and title='Number of Participants'",m.nct_id,m.ctgov_group_enumerator)
				baseline.size==1 ? baseline_participant_count=baseline.first.measure_value : baseline_participant_count=nil
				case m.title
					when 'NOT COMPLETED'
						dw=DropWithdrawal.where("nct_id=? and ctgov_group_id=? and period_id=?",m.nct_id,m.ctgov_group_id,m.period_id)
						if dw.size==1 and dw.first.participant_count > 0
							csv << [m.nct_id,g.study.start_date,g.study.completion_date,g.ctgov_group_id,
											g.title,baseline_participant_count,
											m.period.try(:title),m.title,m.participant_count,
							dw.first.reason,dw.first.participant_count]
						else
							csv << [m.nct_id,g.study.start_date,g.study.completion_date,g.ctgov_group_id,
							g.title,baseline_participant_count,
							m.period.try(:title),m.title,m.participant_count]
						end
					else
						csv << [m.nct_id,g.study.start_date,g.study.completion_date,g.ctgov_group_id,g.title,baseline_participant_count,m.period.try(:title),m.title,m.participant_count]
				end
			}
					}
				}
		end

end
