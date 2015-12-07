  RSpec.describe DropWithdrawal do
    it "should save drop_withdrawals with correct period info" do
      nct_id='NCT00006409'
      study=Asker.new.create_study(nct_id)
      drop_withdrawals=study.drop_withdrawals
      expect(drop_withdrawals.select{|dw|dw.period.title=='Baseline'}.size).to eq(6)
      expect(drop_withdrawals.select{|dw|dw.period.title=='Post-2 Year Intervention'}.size).to eq(6)
      expect(drop_withdrawals.select{|dw|dw.period.title=='Post-3 Year Intervention'}.size).to eq(6)
      expect(drop_withdrawals.select{|dw|dw.reason=='Protocol Violation'}.size).to eq(18)
    end
  end
