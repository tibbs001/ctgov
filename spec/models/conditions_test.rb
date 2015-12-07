  RSpec.describe Condition do
    it "should save conditions" do
      nct_id='NCT00023673'
      study=Asker.new.create_study(nct_id)
      expect(study.conditions.size).to eq(1)
      c=study.conditions.first
      expect(c.name).to eq('Lung Cancer')
    end
  end
