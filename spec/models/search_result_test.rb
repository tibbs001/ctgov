  RSpec.describe SearchResult do
    it "should save 20 search result" do
      expect(SearchResult.count).to eq(0)
      expect(LoadEvent.where("event_type='search_result' and status='complete'").count).to eq(0)
      Asker.brief_search({:term=>"Still's Disease"})
      expect(SearchResult.count).to eq(20)
      expect(LoadEvent.where("event_type='search_result' and status='complete'").count).to eq(20)
    end
  end
