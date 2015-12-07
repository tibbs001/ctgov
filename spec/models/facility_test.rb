  RSpec.describe Facility do
    it "should save facilities" do
      nct_id='NCT01285791'
      study=Asker.new.create_study(nct_id)
      expect(study.facilities.size).to eq(1)
      f=study.facilities.select{|x|x.name=='Hadassah Medical Organization'}.first
      expect(f.name).to eq('Hadassah Medical Organization')
      expect(f.status).to eq('Not yet recruiting')
      expect(f.contact_name).to eq('Arik Tzukert, DMD')
      expect(f.contact_phone).to eq('00 972 2 6776095')
      expect(f.contact_email).to eq('arik@hadassah.org.il')

      expect(f.contact_backup_name).to eq(': Hadas Lemberg, PhD')
      expect(f.contact_backup_phone).to eq('00 972 2 6777572')
      expect(f.contact_backup_email).to eq('lhadas@hadassah.org.il')

      expect(f.investigator_name).to eq('Ido Mizrahi, M.D')
      expect(f.investigator_role).to eq('Principal Investigator')

    end
  end
