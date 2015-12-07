  RSpec.describe Milestone do
    it "should save milestones with correct period info" do
      nct_id='NCT00006409'
      study=Asker.new.create_study(nct_id)
      milestones=study.milestones
      expect(milestones.select{|m|m.period.title=='Baseline'}.size).to eq(18)
      expect(milestones.select{|m|m.period.title=='Post-2 Year Intervention'}.size).to eq(18)
      expect(milestones.select{|m|m.period.title=='Post-3 Year Intervention'}.size).to eq(18)
    end

    it "should save milestones with correct participant count info" do
      nct_id='NCT02028676'
      study=Asker.new.create_study(nct_id)
      milestones=study.milestones.select{|m|m.period.title=='Initial Enrolment: Induction ART'}
      expect(milestones.size).to eq(27)
      started_milestones=milestones.select{|m|m.title=='STARTED'}
      completed_milestones=milestones.select{|m|m.title=='COMPLETED'}
      expect(started_milestones.size).to eq(9)
      p5_started_milestone=started_milestones.select{|m|m.ctgov_group_enumerator==5}.first
      p9_started_milestone=started_milestones.select{|m|m.ctgov_group_enumerator==9}.first
      expect(p5_started_milestone.participant_count).to eq(405)
      expect(p9_started_milestone.participant_count).to eq(0)
      p5_completed_milestone=completed_milestones.select{|m|m.ctgov_group_enumerator==5}.first
      p9_completed_milestone=completed_milestones.select{|m|m.ctgov_group_enumerator==9}.first
      expect(p5_completed_milestone.participant_count).to eq(405)
      expect(p9_completed_milestone.participant_count).to eq(0)

      milestones=study.milestones.select{|m|m.period.title=='Subsequent Once vs Twice Daily ABC+3TC'}
      expect(milestones.size).to eq(27)
      started_milestones=milestones.select{|m|m.title=='STARTED'}
      completed_milestones=milestones.select{|m|m.title=='COMPLETED'}
      expect(started_milestones.size).to eq(9)
      p5_started_milestone=started_milestones.select{|m|m.ctgov_group_enumerator==5}.first
      p9_started_milestone=started_milestones.select{|m|m.ctgov_group_enumerator==9}.first
      expect(p5_started_milestone.participant_count).to eq(0)
      expect(p9_started_milestone.participant_count).to eq(0)
      p5_completed_milestone=completed_milestones.select{|m|m.ctgov_group_enumerator==5}.first
      p9_completed_milestone=completed_milestones.select{|m|m.ctgov_group_enumerator==9}.first
      expect(p5_completed_milestone.participant_count).to eq(0)
      expect(p9_completed_milestone.participant_count).to eq(0)

      milestones=study.milestones.select{|m|m.period.title=='Subsequent Cotrimoxazole Randomization'}
      expect(milestones.size).to eq(27)
      started_milestones=milestones.select{|m|m.title=='STARTED'}
      completed_milestones=milestones.select{|m|m.title=='COMPLETED'}
      expect(started_milestones.size).to eq(9)
      p5_started_milestone=started_milestones.select{|m|m.ctgov_group_enumerator==5}.first
      p9_started_milestone=started_milestones.select{|m|m.ctgov_group_enumerator==9}.first
      expect(p5_started_milestone.participant_count).to eq(0)
      expect(p9_started_milestone.participant_count).to eq(382)
      p5_completed_milestone=completed_milestones.select{|m|m.ctgov_group_enumerator==5}.first
      p9_completed_milestone=completed_milestones.select{|m|m.ctgov_group_enumerator==9}.first
      expect(p5_completed_milestone.participant_count).to eq(0)
      expect(p9_completed_milestone.participant_count).to eq(382)

    end
  end
