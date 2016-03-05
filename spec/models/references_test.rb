  RSpec.describe Reference do
    it "should save study references" do
      nct_id='NCT00000125'
      study=Asker.new.create_study(nct_id)
			expect(study.references.size).to eq(49)
			expect(study.study_references.size).to eq(49)
			expect(study.result_references.size).to eq(0)
		end

    it "should save result references" do
      nct_id='NCT02028676'
      study=Asker.new.create_study(nct_id)
			expect(study.result_references.size).to eq(2)
    end
  end
