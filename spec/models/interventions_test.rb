  RSpec.describe Intervention do
    it "should save interventions" do
      nct_id='NCT02028676'
      study=Asker.new.create_study(nct_id)
      expect(study.interventions.size).to eq(9)
      i=study.interventions.select{|m|m.name=='Clinically Driven Monitoring (CDM)'}.first
      expect(i.intervention_type).to eq('Other')
      expect(i.other_names.size).to eq(0)
      i=study.interventions.select{|m|m.name=='Arm B: ZDV+ABC+3TC+NNRTI-&gt;ABC+3TC+NNRTI maintenance'}.first
      expect(i.intervention_type).to eq('Drug')
      expect(i.description).to eq("Children initiated ART using an induction-maintenance approach, starting with open-label four-drug lamivudine, abacavir, NNRTI, plus zidovudine for 36 weeks, then open-label lamivudine, abacavir, plus NNRTI subsequently. The NNRTI (nevirapine or efavirenz) was chosen by clinicians according to local availability and age.")
      expect(i.other_names.size).to eq(8)
      other_name=(i.other_names.select{|m|m.name='ABC: abacavir: Ziagen'}).first
      expect(other_name.name).to eq('ABC: abacavir: Ziagen')
    end

    it "should save interventions" do
      nct_id='NCT00023673'
      study=Asker.new.create_study(nct_id)
      expect(study.interventions.size).to eq(3)
      i=study.interventions.select{|m|m.intervention_type=='Radiation'}.first
      expect(i.name).to eq('three-dimensional conformal radiation therapy')
      expect(i.intervention_arm_group_labels.size).to eq (4)
      expect(i.intervention_arm_group_labels.select{|l|l.label=='Phase II: 74 Gy/37 fx + chemotherapy'}.size).to eq(1)
      expect(i.intervention_arm_group_labels.select{|l|l.label=='Phase I: 70 Gy/35 fx + chemotherapy'}.size).to eq(1)
      expect(i.intervention_arm_group_labels.select{|l|l.label=='Phase I: 74 Gy/37 fx + chemotherapy'}.size).to eq(1)
    end
  end
