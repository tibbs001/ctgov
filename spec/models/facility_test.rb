  RSpec.describe Facility do
    it "should save facilities" do
      nct_id='NCT00042289'
      study=Asker.new.create_study(nct_id)
      expect(study.facilities.size).to eq(91)
      f=study.facilities.select{|x|x.name=='UCSF Pediatric AIDS CRS'}.first
      expect(f.status).to eq('Withdrawn')
      expect(f.city).to eq('San Francisco')
      expect(f.state).to eq('California')
      expect(f.zip).to eq('94110')
      expect(f.country).to eq('United States')

#			Only recruting facilitites include contact/investigator data.
#			this info will change & make tests fail.
#      expect(f.contact_backup_name).to eq(': Hadas Lemberg, PhD')
#      expect(f.contact_backup_phone).to eq('00 972 2 6777572')
#      expect(f.contact_backup_email).to eq('lhadas@hadassah.org.il')

#      expect(f.investigator_name).to eq('Ido Mizrahi, M.D')
#      expect(f.investigator_role).to eq('Principal Investigator')

    end
  end
