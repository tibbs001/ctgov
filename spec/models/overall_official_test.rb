  RSpec.describe OverallOfficial do
    it "should save overall officials" do
      nct_id='NCT02028676'
      study=Asker.new.create_study(nct_id)
      expect(study.overall_officials.size).to eq(10)
      official=(study.overall_officials.select{|m|m.name=='Diana M Gibb, MD'}).first
      expect(official.role).to eq('Principal Investigator')
    end
  end
