RSpec.describe DerivedValue do

	 it "should save correct derived values" do
		nct_id='NCT00000137'
		study=Asker.new.create_study(nct_id)
		expect(study.derived_value.registered_in_fiscal_year).to eq(1999)
		expect(study.derived_value.sponsor_type).to eq('NIH')
		expect(study.derived_value.enrollment).to eq(nil)
		expect(study.derived_value.results_reported).to eq(nil)
		expect(study.derived_value.number_of_facilities).to eq(0)
		expect(study.derived_value.number_of_sae_subjects).to eq(0)
		expect(study.derived_value.number_of_nsae_subjects).to eq(0)
	end

end
