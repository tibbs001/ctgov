  RSpec.describe Group do
		it "should save groups and their outcomes" do
			nct_id='NCT02028676'
			xml=Nokogiri::XML(Faraday.get("http://clinicaltrials.gov/show/#{nct_id}?resultsxml=true").body)
			opts={:xml=>xml,:study_xml=>xml,:nct_id=>nct_id}
			groups=Group.create_all_from(opts)
			expect(groups.size).to eq(9)
		end

		it "should attach outcomes to the appropriate group & calculate participant count based on outcome measures" do
      nct_id='NCT00006409'
      study=Asker.new.create_study(nct_id)
			g4_array=study.groups.select{|g|g.ctgov_group_enumerator==4}
			expect(g4_array.size).to eq(1)
			g4=g4_array.first
			outcome=g4.outcomes.first
			expect(g4.outcomes.size).to eq(2)
			expect(outcome.outcome_measures.size).to eq(2)
			expect(outcome.outcome_measures.first.group).to eq(g4)
			expect(outcome.outcome_measures.last.group).to eq(g4)
			expect(g4.derived_participant_count).to eq(1545)
			g1=study.groups.select{|g|g.ctgov_group_enumerator==1}.first
			g2=study.groups.select{|g|g.ctgov_group_enumerator==2}.first
			g3=study.groups.select{|g|g.ctgov_group_enumerator==3}.first
			g5=study.groups.select{|g|g.ctgov_group_enumerator==5}.first
			g6=study.groups.select{|g|g.ctgov_group_enumerator==6}.first
			expect(g1.derived_participant_count).to eq(0)
			expect(g2.derived_participant_count).to eq(0)
			expect(g3.derived_participant_count).to eq(1540)
			expect(g5.derived_participant_count).to eq(1664)
			expect(g6.derived_participant_count).to eq(1714)
			expect(study.derived_value.enrollment).to eq(6463)
		end

		it "should save groups that are missing in the participant_flow section" do
      nct_id='NCT02320695'
      study=Asker.new.create_study(nct_id)
			g4_array=study.groups.select{|g|g.ctgov_group_enumerator==4}
			expect(g4_array.size).to eq(1)
			g4=g4_array.first
			expect(g4.outcome_analyses.size).to eq(2)
			g4a=g4.outcome_analyses.select{|x|x.outcome.title=='Mean Change From Post-Tape Stripping in Subject Assessment of Stinging Sensation One Minute After Investigational Product Application'}.first
			expect(g4a.group.title).to eq('Antibiotic/Pain Relieving Ointment')
			expect(g4a.non_inferiority).to eq('Yes')
			expect(g4a.non_inferiority_description.length).to eq(382)
			expect(g4a.dispersion_type).to eq('Standard Error of the Mean')
			expect(g4a.dispersion_value).to eq(0.12)
			expect(g4a.p_value).to eq(0.522)
			expect(g4a.method).to eq('ANCOVA')
			expect(g4a.method_description).to eq('Terms included treatment as factor, post tape-stripping score as covariate and subject as random effect to incorporate within-subject correlations.')
			expect(g4a.param_type).to eq('Mean Difference (Net)')
			expect(g4a.param_value).to eq(-0.08)
			expect(g4a.ci_percent).to eq('95')
			expect(g4a.ci_n_sides).to eq('2-Sided')
			expect(g4a.ci_lower_limit).to eq(-0.32)
			expect(g4a.ci_upper_limit).to eq(0.20)
		end
  end
