  RSpec.describe Group do
		it "should save groups and their outcomes" do
			nct_id='NCT02028676'
			xml=Nokogiri::XML(Faraday.get("http://clinicaltrials.gov/show/#{nct_id}?resultsxml=true").body)
			opts={:xml=>xml,:study_xml=>xml,:nct_id=>nct_id}
			groups=Group.create_all_from(opts)
			expect(groups.size).to eq(9)
		end

		it "should save groups that are missing in the participant_flow section" do
      nct_id='NCT02320695'
			xml=Nokogiri::XML(Faraday.get("http://clinicaltrials.gov/show/#{nct_id}?resultsxml=true").body)
			opts={:xml=>xml,:study_xml=>xml,:nct_id=>nct_id}
			groups=Group.create_all_from(opts)
			g4_array=groups.select{|g|g.ctgov_group_enumerator==4}
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
