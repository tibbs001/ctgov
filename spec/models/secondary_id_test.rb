  RSpec.describe SecondaryId do
    it "should save 1 secondary ID" do
      nct_id='NCT00000102'
      study=Asker.new.create_study(nct_id)
      expect(study.secondary_ids.size).to eq(1)
      expect(study.secondary_ids.first.secondary_id).to eq('M01RR001070')
      expect(study.org_study_id).to eq('NCRR-M01RR01070-0506')
    end
  end
