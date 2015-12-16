  RSpec.describe Group do
		it "should save groups and their outcomes" do
			 nct_id='NCT02028676'
			 xml=Nokogiri::XML(Faraday.get("http://clinicaltrials.gov/show/NCT02028676?resultsxml=true").body)
			 opts={:xml => xml,:nct_id=>nct_id}
			 groups=Group.create_all_from(opts)
			 expect(groups.size).to eq(9)
		end

  end
