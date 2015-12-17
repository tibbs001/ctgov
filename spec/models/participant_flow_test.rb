  RSpec.describe ParticipantFlow do
		it "should save participant flow info" do
			 nct_id='NCT02028676'
			 xml=Nokogiri::XML(Faraday.get("http://clinicaltrials.gov/show/#{nct_id}?resultsxml=true").body)
			 opts={:xml=>xml,:nct_id=>nct_id}
			 pf=ParticipantFlow.create_from(opts)
			 expect(pf.recruitment_details.size).to eq(349)
			 expect(pf.pre_assignment_details.size).to eq(343)
		end

  end
