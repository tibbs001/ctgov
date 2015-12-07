  RSpec.describe ActualOutcome do
    it "should save actual outcomes" do
      nct_id='NCT00000125'
      study=Asker.new.create_study(nct_id)
      expect(study.actual_outcomes.size).to eq(2)
      p2=study.actual_outcomes.select{|x|x.ctgov_group_id=='O2'}.first
      expect(p2.type).to eq('Primary')
      expect(p2.title).to eq('Incidence of Primary Open-Angle Glaucoma in Hypotensive Patients')
      expect(p2.group_title).to eq('Treatment')
      expect(p2.description).to eq('Comparison of the cumulative proportion of participants who develop primary open-angle glaucoma in the observation and medication groups.')
      expect(p2.group_description).to eq('Topical ocular hypotensive eye drops from February 1994 through March 2009.')
      expect(p2.population).to eq('1636 ocular hypertensive participants were randomized to either close observation or treatment with topical hypotensive eyedrops from February 1994 through June 2002. In June 2002 the observation participants were offered treatment with topical hypotensive eyedrops.')
    end
  end
