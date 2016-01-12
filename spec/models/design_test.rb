  RSpec.describe Design do
    it "should have correct design relationships" do
      nct_id='NCT00008216'
      study=Asker.new.create_study(nct_id)
      expect(study.design.description).to eq('Observational Model: Cohort, Time Perspective: Prospective')
      expect(study.design.masking).to eq(nil)
      expect(study.design.observational_model).to eq('Cohort')
      expect(study.design.time_perspective).to eq('Prospective')
    end

    it "should have target_duration" do
      nct_id='NCT02089750'
      design=Asker.new.create_study(nct_id).design
      expect(design.nct_id).to eq(nct_id)
      expect(design.description).to eq('Allocation: Randomized, Endpoint Classification: Efficacy Study, Intervention Model: Parallel Assignment, Masking: Double Blind (Investigator, Outcomes Assessor), Primary Purpose: Treatment')
      expect(design.primary_purpose).to eq('Treatment')
			expect(design.time_perspective).to eq(nil)
			expect(design.observational_model).to eq(nil)
			expect(design.intervention_model).to eq('Parallel Assignment')
			expect(design.endpoint_classification).to eq('Efficacy Study')
      expect(design.allocation).to eq('Randomized')
      expect(design.masking).to eq('Double Blind')
      expect(design.masked_roles).to eq('Investigator, Outcomes Assessor')
    end

  end

