  RSpec.describe Facility do
    it "should save facilities" do
      nct_id='NCT01285791'
      study=Asker.new.create_study(nct_id)
      expect(study.facilities.size).to eq(1)
      f=study.facilities.select{|x|x.name=='Hadassah Medical Organization'}.first
      expect(f.name).to eq('Hadassah Medical Organization')
      expect(f.status).to eq('')

    end
  end
