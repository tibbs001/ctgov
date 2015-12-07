  RSpec.describe OutcomeMeasure do
    it 'should save the category correctly' do
      nct_id='NCT00263328'
      study=Asker.new.create_study(nct_id)
      expect(study.outcome_measures.size).to eq(2951)
      measure1_entries=study.outcome_measures.select{|x|x.title=='Calculated Glomerular Filtration Rate (GFR) Using the Modification of Diet in Renal Disease (MDRD) Equation'}
      expect(measure1_entries.size).to eq(54)
      m1=measure1_entries.select{|x| x.ctgov_group_id=='O1' && x.category=='Month 9 (n=18,14,12)'}.first
      expect(m1.units).to eq('mL/min/1.73 m^2')
      expect(m1.param).to eq('Mean')
      expect(m1.dispersion).to eq('Standard Deviation')
      expect(m1.spread).to eq('19.79')
      expect(m1.measure_value).to eq('67.06')
      m2=measure1_entries.select{|x| x.ctgov_group_id=='O2' && x.category=='Month 9 (n=18,14,12)'}.first
      expect(m2.units).to eq('mL/min/1.73 m^2')
      expect(m2.param).to eq('Mean')
      expect(m2.dispersion).to eq('Standard Deviation')
      expect(m2.spread).to eq('12.46')
      expect(m2.measure_value).to eq('65.99')
      m3=measure1_entries.select{|x| x.ctgov_group_id=='O3' && x.category=='Month 9 (n=18,14,12)'}.first
      expect(m3.units).to eq('mL/min/1.73 m^2')
      expect(m3.param).to eq('Mean')
      expect(m3.dispersion).to eq('Standard Deviation')
      expect(m3.spread).to eq('13.63')
      expect(m3.measure_value).to eq('67.05')
    end

    it "should save outcome measures" do
      nct_id='NCT00001151'
      study=Asker.new.create_study(nct_id)
      expect(study.actual_outcomes.size).to eq(1)
      outcome=study.actual_outcomes.first
      expect(outcome.outcome_type).to eq('Primary')
      expect(outcome.title).to eq('Number of Participants With Normal Serum Calcium Concentrations')
      expect(outcome.description).to eq('Normal calcium concentration 8.2-10.6 mg/dL')
      expect(outcome.outcome_measures.size).to eq(2)
      outcome_measure1=study.actual_outcomes.first.outcome_measures.select{|x|x.title='Number of Participants'}.first
      outcome_measure2=study.actual_outcomes.first.outcome_measures.select{|x|x.title='Number of Participants With Normal Serum Calcium Concentrations'}.first
      expect(outcome_measure1.units).to eq('participants')
      expect(outcome_measure1.param).to eq('Number')
      expect(outcome_measure2.description).to eq('Normal calcium concentration 8.2-10.6 mg/dL')
    end
  end
