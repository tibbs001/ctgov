RSpec.describe PmaRecord do
	it "should save pma records" do
		nct_id='NCT00336284'
		study=Asker.new.create_study(nct_id)

		data={:ct_pma_id=>'85630',:nct_id=>'NCT00336284',:pma_number=>'P000009',:supplement_number=>'S033'}
		uid=Digest::SHA1.hexdigest(data.to_s)
		study.pma_mappings << PmaMapping.create!(data.merge({:unique_id=>uid}))

		data={:ct_pma_id=>'85713',:nct_id=>'NCT00336284',:pma_number=>'P050023',:supplement_number=>'S020'}
		uid=Digest::SHA1.hexdigest(data.to_s)
		study.pma_mappings << PmaMapping.create!(data.merge({:unique_id=>uid}))

		data={:ct_pma_id=>'85739',:nct_id=>'NCT00336284',:pma_number=>'P070008',:supplement_number=>'S009'}
		uid=Digest::SHA1.hexdigest(data.to_s)
		study.pma_mappings << PmaMapping.create!(data.merge({:unique_id=>uid}))

		data={:ct_pma_id=>'86139',:nct_id=>'NCT00336284',:pma_number=>'P950037',:supplement_number=>'S068'}
		uid=Digest::SHA1.hexdigest(data.to_s)
		study.pma_mappings << PmaMapping.create!(data.merge({:unique_id=>uid}))

		expect(study.pma_mappings.size).to eq(4)

		# verify that it won't create duplicate pma records
		study.derived_value.create_pma_records
		expect(study.pma_records.size).to eq(4)
		study.derived_value.create_pma_records
		expect(study.pma_records.size).to eq(4)

		rec=study.pma_records.select{|p|p.pma_number=='P050023'}.first
		expect(rec.supplement_number).to eq('S020')
		expect(rec.decision_code).to eq('APPR')

		expect(rec.supplement_type).to eq("Normal 180 Day Track")
		expect(rec.decision_date).to eq("2009-05-12".to_date)
		expect(rec.product_code).to eq("MRM")
		expect(rec.city).to eq("Lake Oswego")
		expect(rec.zip).to eq("97035")
		expect(rec.generic_name.upcase).to eq("DEFIBRILLATOR, IMPLANTABLE, DUAL-CHAMBER")
		expect(rec.applicant.upcase).to eq("BIOTRONIK, INC.")
		expect(rec.advisory_committee).to eq("CV")
		expect(rec.expedited_review_flag).to eq("N")
		expect(rec.ao_statement.upcase).to include("APPROVAL FOR MODIFICATION OF PRODUCT LABELING FOR DEVICES THAT UTILIZE HOME MONITORING. SPECIFICALLY")
		expect(rec.fei_numbers).to eq("1028232,3002806500,3008159616,3010877961,1000165971,3009345704")
		expect(rec.device_name).to eq("Defibrillator, Implantable, Dual-Chamber")
		expect(rec.device_class).to eq("3")
		expect(rec.medical_specialty_description).to eq("Unknown")
		expect(rec.registration_numbers).to eq("3008159616,1028232,3010877961,1000165971,3009345704,9610139")
		expect(rec.state).to eq("OR")
		expect(rec.date_received).to eq("2009-01-26".to_date)
		expect(rec.trade_name.upcase).to eq("LUMAX FAMILY OF ICDS")
		expect(rec.supplement_reason).to eq("Labeling Change - Indications/instructions/shelf life/tradename")
		expect(rec.advisory_committee_description).to eq("Cardiovascular")
		expect(rec.street_1).to eq("6024 Jean Road")


	end
end
