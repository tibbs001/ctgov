  RSpec.describe ReportedEvent do
    it "should save with correct info" do
      nct_id='NCT02028676'
      study=Asker.new.create_study(nct_id)
      expect(study.reported_events.size).to eq(351)
    end
  end
