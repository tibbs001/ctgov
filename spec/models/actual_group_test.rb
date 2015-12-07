  RSpec.describe ActualGroup do
    it "should save actual groups" do
      nct_id='NCT00000125'
      study=Asker.new.create_study(nct_id)
      expect(study.actual_outcomes.size).to eq(2)

      p1=study.actual_groups.select{|x|x.ctgov_group_id=='P1'}.first
      expect(p1.title).to eq('Observation')
      expect(p1.description).to eq('Close Observation')

      p2=study.actual_groups.select{|x|x.ctgov_group_id=='P2'}.first
      expect(p2.title).to eq('Treatment')
      expect(p2.description).to eq('Topical ocular hypotensive eye drops.')

    end
  end
