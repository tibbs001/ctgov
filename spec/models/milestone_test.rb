  RSpec.describe Milestone do
		it "should link milestones and drop_withdrawals to the group" do
			nct_id='NCT00006409'
			xml=Nokogiri::XML(Faraday.get("http://clinicaltrials.gov/show/#{nct_id}?resultsxml=true").body)
			opts={:xml => xml,:nct_id=>nct_id,:study_xml=>xml}
			groups=Group.create_all_from(opts)
			g1_array=groups.select{|g|g.ctgov_group_enumerator==1}
			expect(g1_array.size).to eq(1)
			g1=g1_array.first
			expect(g1.milestones.size).to eq(9)
			expect(g1.drop_withdrawals.size).to eq(3)
			baseline=g1.milestones.select{|g|g.period_title=='Baseline'}
			expect(baseline.size).to eq(3)
			started=g1.milestones.select{|m|m.period_title=='Baseline' && m.title=='STARTED'}
			completed=g1.milestones.select{|m|m.period_title=='Baseline' && m.title=='COMPLETED'}
			not_completed=g1.milestones.select{|m|m.period_title=='Baseline' && m.title=='NOT COMPLETED'}
			expect(started.size).to eq(1)
			expect(completed.size).to eq(1)
			expect(not_completed.size).to eq(1)
			expect(started.first.participant_count).to eq(865)
			expect(completed.first.participant_count).to eq(817)
			expect(not_completed.first.participant_count).to eq(48)

			baseline=g1.drop_withdrawals.select{|g|g.period_title=='Baseline'}
      expect(baseline.size).to eq(1)
			violations=g1.drop_withdrawals.select{|g|g.reason=='Protocol Violation'}
      expect(violations.size).to eq(3)
			dw=DropWithdrawal.where('nct_id=? and ctgov_group_id=? and reason=?',nct_id,'P6','Protocol Violation').first
			expect(dw.participant_count).to eq(62)
			dw=DropWithdrawal.where('nct_id=? and ctgov_group_id=? and reason=?',nct_id,'P5','Protocol Violation').first
			expect(dw.participant_count).to eq(62)
			dw=DropWithdrawal.where('nct_id=? and ctgov_group_id=? and reason=?',nct_id,'P4','Protocol Violation').first
			expect(dw.participant_count).to eq(0)
			dw=DropWithdrawal.where('nct_id=? and ctgov_group_id=? and period_title=?',nct_id,'P1','Baseline').first
			expect(dw.participant_count).to eq(48)
			expect(dw.group.ctgov_group_id).to eq(dw.ctgov_group_id)
		end
  end
