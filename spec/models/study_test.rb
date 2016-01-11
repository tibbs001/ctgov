  RSpec.describe Study do
    #  study=Asker.new.create_study('NCT02028676')
    it "should have expected relationships" do
      nct_id='NCT00023673'
      study=Asker.new.create_study(nct_id)
      expect(study.nct_id).to eq(nct_id)
      expect(study.outcomes.size).to eq(6)
      expect(study.groups.size).to eq(4)
      g1=study.groups.select{|g|g.ctgov_group_enumerator==1}.first
      g2=study.groups.select{|g|g.ctgov_group_enumerator==2}.first
      expect(g1.milestones.size).to eq(3)
      expect(g2.milestones.size).to eq(3)
      milestones=Milestone.where('nct_id =?',nct_id)
      expect(milestones.size).to eq(12)
      p4=milestones.select{|x|x.ctgov_group_enumerator==4}
      expect(p4.size).to eq(3)
      p4_started=p4.select{|x|x.title=='STARTED'}.first
      p4_completed=p4.select{|x|x.title=='COMPLETED'}.first
      p4_not_completed=p4.select{|x|x.title=='NOT COMPLETED'}.first
      expect(p4_started.participant_count).to eq(46)
      expect(p4_completed.participant_count).to eq(44)
      expect(p4_not_completed.participant_count).to eq(2)
      expect(study.drop_withdrawals.size).to eq(8)
      dw=DropWithdrawal.where('nct_id = ?',nct_id)
      expect(dw.size).to eq(8)
    end
  end

  RSpec.describe Study do
    it "should have target_duration" do
      nct_id='NCT00008216'
      study=Asker.new.create_study(nct_id)
      expect(study.nct_id).to eq(nct_id)
      expect(study.design.description).to eq('Observational Model: Cohort, Time Perspective: Prospective')
      expect(study.target_duration).to eq('36 Months')
    end
  end

  RSpec.describe Study do
    it 'should not create duplicate relationships' do
      nct_id='NCT02028676'
      study=Asker.new.create_study(nct_id)
      expect(study.nct_id).to eq(nct_id)
      expect(study.expected_groups.size).to eq(9)
      expect(study.facilities.size).to eq(4)
      expect(study.result_references.size).to eq(2)
      expect(study.result_contacts.size).to eq(1)
      expect(study.baseline_measures.size).to eq(390)

      baselines=(study.baseline_measures.select{|m|m.category=='Female'})
      expect(baselines.size).to eq(40)
      female_baselines=(baselines.select{|m|m.title=='Gender'})
      expect(female_baselines.size).to eq(10)
      b1_baselines=(study.baseline_measures.select{|m|m.ctgov_group_id=='B1'})
      expect(b1_baselines.size).to eq(39)

      baseline_title="Weight-for-age Z-score: Period 3 (randomization to once vs twice daily ABC+3TC)"
      period3_zscore=[]
      study.baseline_measures.each{|x|period3_zscore << x if x.title==baseline_title}
      expect(period3_zscore.size).to eq(10)

      baseline_title="Weight-for-age Z-score: Period 4 (randomization to stop versus continue cotrimoxazole)"
      period4_zscore=[]
      study.baseline_measures.each{|x|period4_zscore << x if x.title==baseline_title}
      expect(period4_zscore.size).to eq(10)

      b1_male_baselines=(b1_baselines.select{|m|m.category=='Male' and m.title=='Gender'})
      expect(b1_male_baselines.size).to eq(1)
      expect(b1_male_baselines.first.measure_value).to eq('298')

      expect(study.expected_groups.size).to eq(9)
      expect(study.overall_officials.size).to eq(10)
      expect(study.outcomes.size).to eq(162)
      expect(study.facilities.size).to eq(4)
      expect(study.references.size).to eq(2)
      expect(study.result_contacts.size).to eq(1)
      measure=(study.baseline_measures.select{|m| m.dispersion=='Inter-Quartile Range'}).first
    end
  end

  RSpec.describe Study do
    it "should have correct biospec and why_stopped values" do
      nct_id='NCT00000105'
      study=Asker.new.create_study(nct_id)
      expect(study.nct_id).to eq(nct_id)
      expect(study.why_stopped).to eq('Replaced by another study.')
      expect(study.biospec_retention).to eq('Samples With DNA')
      expect(study.biospec_description).to eq('analysis of blood samples before and 4 weeks postvaccination')
      expect(study.has_expanded_access).to eq(false)
			expect(study.summary).to include("The purpose of this study is to learn how the immune system works in response to vaccines")
    end
  end

  RSpec.describe Study do
    it "should have all the outcomes data" do
      nct_id='NCT02028676'  # study with rich set of outcomes data
      study=Asker.new.create_study(nct_id)
      expect(study.nct_id).to eq(nct_id)
      expect(study.location_countries.map(&:name)).to include('Uganda')
      expect(study.expected_groups.size).to eq(9)
      expect(study.groups.size).to eq(9)

      official=nil
      study.overall_officials.each{|o| official=o if o.name == 'Philippa Musoke, PhD'}
      expect(official.nct_id).to eq(nct_id)
      expect(official.role).to eq('Principal Investigator')
      expect(official.affiliation).to eq("Baylor College of Medicine Children's Foundation, Mulago, Uganda")
      expect(study.overall_officials.size).to eq(10)
      expect(study.overall_officials.first.nct_id).to eq(nct_id)
      expect(study.overall_officials.map(&:name)).to include('Diana M Gibb, MD')
      expect(study.overall_officials.map(&:name)).to include('Victor Musiime, PhD')
      expect(study.overall_officials.map(&:role)).to include('Principal Investigator')
      expect(study.overall_officials.map(&:affiliation)).to include('Medical Research Council')

      fac=''
      study.facilities.each{|f| fac=f if f.name == 'University of Zimbabwe Medical School'}
      expect(fac.city).to eq('Harare')
      expect(fac.country).to eq('Zimbabwe')
      expect(study.facilities.size).to eq(4)
      expect(fac.nct_id).to eq(nct_id)

      expect(study.references.first.nct_id).to eq(nct_id)
      expect(study.references.size).to eq(2)
      ref=study.references.select{|x| x.pmid=='23473847'}.first
      expect(ref.reference_type).to eq('results_reference')
      expect(study.references.map(&:citation)).to include("ARROW Trial team, Kekitiinwa A, Cook A, Nathoo K, Mugyenyi P, Nahirya-Ntege P, Bakeera-Kitaka S, Thomason M, Bwakura-Dangarembizi M, Musiime V, Munderi P, Naidoo-James B, Vhembo T, Tumusiime C, Katuramu R, Crawley J, Prendergast AJ, Musoke P, Walker AS, Gibb DM. Routine versus clinically driven laboratory monitoring and first-line antiretroviral therapy strategies in African children with HIV (ARROW): a 5-year open-label randomised factorial trial. Lancet. 2013 Apr 20;381(9875):1391-403. doi: 10.1016/S0140-6736(12)62198-9. Epub 2013 Mar 7.")
      expect(study.recruitment_details).to eq('All recruited children (n=1206) were randomly assigned to CDM vs LCM and the three different induction ART strategies at enrolment (3/2007-11/2008). This was a factorial randomisation meaning that the children were effectively randomized into 6 parallel groups. Baseline characteristics are presented below separately for each initial randomization.')
      expect(study.pre_assignment_details).to eq("There were two additional nested substudy randomizations after initial trial enrolment (see inclusion/exclusion criteria for eligibility). From 8/2009 to 6/2010, eligible children were randomized to once vs twice daily abacavir+lamivudine. From 9/2009 to 2/2011, eligible children were randomized to stop vs continue cotrimoxazole prophylaxis.")
      expect(study.result_detail.nct_id).to eq(nct_id)
      expect(study.result_contacts.size).to eq(1)
      expect(study.result_contacts.first.name_or_title).to eq('Professor Ann Sarah Walker')
      expect(study.result_contacts.first.phone).to eq('+44 20 7670 4726')
      expect(study.result_contacts.first.email).to eq('rmjlasw@ucl.ac.uk')
      expect(study.result_contacts.first.nct_id).to eq(nct_id)
      expect(study.result_agreements.first.pi_employee).to eq('Principal Investigators are NOT employed by the organization sponsoring the study.')
      expect(study.result_agreements.first.agreement).to eq("There is NOT an agreement between Principal Investigators and the Sponsor (or its agents) that restricts the PI's rights to discuss or publish trial results after the trial is completed. ")
      expect(study.result_agreements.first.nct_id).to eq(nct_id)
      expect(study.baseline_measures.size).to eq(390)

      b2_baselines=study.baseline_measures.select{|x|x.ctgov_group_id=='B2'}
      b3_baselines=study.baseline_measures.select{|x|x.ctgov_group_id=='B3'}
      b8_baselines=study.baseline_measures.select{|x|x.ctgov_group_id=='B8'}
      expect(b2_baselines.size).to eq (39)
      b2_baseline_age_array=b2_baselines.select{|x|x.title=='Age'}
      expect(b2_baseline_age_array.size).to eq(1)
      b2_baseline_age=b2_baseline_age_array.first
      expect(b2_baseline_age.nct_id).to eq(nct_id)
      expect(b2_baseline_age.param).to eq('Median')
      expect(b2_baseline_age.units).to eq('years')
      expect(b2_baseline_age.dispersion).to eq('Inter-Quartile Range')
      expect(b2_baseline_age.measure_value).to eq('6.0')
      expect(b2_baseline_age.lower_limit).to eq('2.6')
      expect(b2_baseline_age.upper_limit).to eq('9.4')
      expect(b2_baseline_age.description).to eq('Age at trial enrollment (antiretroviral therapy initiation).')

      expect(b8_baselines.size).to eq(39)
      b8_baseline_zscore=b8_baselines.select{|x|x.title=='Weight-for-age Z-score: Period 1 (trial enrollment, CDM vs LCM)'}.first
      expect(b8_baseline_zscore.nct_id).to eq(nct_id)
      expect(b8_baseline_zscore.units).to eq('Z-score')
      expect(b8_baseline_zscore.param).to eq('Median')
      expect(b8_baseline_zscore.dispersion).to eq('Inter-Quartile Range')
      expect(b8_baseline_zscore.measure_value).to eq('NA')
      expect(b8_baseline_zscore.lower_limit).to eq(nil)
      expect(b8_baseline_zscore.upper_limit).to eq(nil)
      expect(b8_baseline_zscore.description).to eq('Weight-for-age Z-score at trial enrollment (antiretroviral therapy initiation).')
      expect(b8_baseline_zscore.measure_description).to eq('Different randomized comparison')
      p1_col=(study.milestones.select{|g|g.ctgov_group_id=='P1'})
      expect(p1_col.size).to eq(12)
      expect(study.outcomes.size).to eq(162)
      outcomes=(study.outcomes.select{|g|g.title=="LCM vs CDM: Disease Progression to a New WHO Stage 4 Event or Death"})
      expect(outcomes.size).to eq(2)
      outcome=outcomes.select{|x|x.group_title=='Clinically Driven Monitoring (CDM)'}.first
      expect(outcome.outcome_type).to eq('Primary')
      expect(outcome.safety_issue).to eq('No')
      expect(outcome.group.ctgov_group_id).to eq('P1')
      expect(outcome.population).to eq('All randomized participants (time-to-event)')
      expect(outcome.description).to eq('Number of participants with disease progression to a new WHO stage 4 event or death, to be analysed using time-to-event methods')
      expect(outcome.group_description).to eq('Participants were examined by a doctor and had routine full blood count with white cell differential, lymphocyte subsets (CD4, CD8), biochemistry tests (bilirubin, urea, creatinine, aspartate aminotransferase, alanine aminotransferase) at screening, randomisation (lymphocytes only), weeks 4, 8, and 12, then every 12 weeks. Screening results were used to assess eligibility. All subsequent results at and after randomisation were only returned if requested for clinical management (authorised by centre project leaders); haemoglobin results at week 8 were automatically returned on the basis of early anaemia in a previous adult trial as were grade 4 laboratory toxicities (protocol safety criteria). Total lymphocytes and CD4 tests were never returned for CDM participants, but for all children other investigations (including tests from the routine panels) could be requested and concomitant drugs prescribed, as clinically indicated at extra patient-initiated or scheduled visits.')
      expect(outcome.measures.size).to eq(2)

      num_participants=(outcome.measures.select{|m|m.title=='Number of Participants'})
      expect(num_participants.size).to eq(1)
      measure=num_participants.select{|x|x.ctgov_group_enumerator==1}.first
      expect(measure.param).to eq('Number')
      expect(measure.units).to eq('participants')
      expect(measure.measure_value).to eq('606')
      expect(outcome.analyses.size).to eq(2)

      analyses=(outcome.analyses.select{|m|m.method=='Comparison of poisson rates'})
      expect(analyses.size).to eq(1)
      analysis=analyses.select{|x|x.ctgov_group_enumerator==1}.first
      expect(analysis.p_value).to eq(0.43)
      expect(analysis.non_inferiority).to eq('Yes')
      expect(analysis.non_inferiority_description).to eq('With assumptions detailed above, &gt;90% power and one-sided alpha=0.05, 1160 children would be required to exclude an increase in progression rate of 1.6% from 2.5% to 4.1% per year in the CDM arm (upper 95% confidence limit of LCM: CDM hazard ratio 1.64).')
      expect(analysis.method_description).to eq('Statistical analysis plan specified that p-value was to be calculated from the log-rank test, so not provided for the risk difference')
      expect(analysis.param_type).to eq('Risk Difference (RD)')
      expect(analysis.param_value).to eq(0.32)
      expect(analysis.ci_percent).to eq('95')
      expect(analysis.ci_n_sides).to eq('2-Sided')
      expect(analysis.ci_lower_limit).to eq(-0.47)
      expect(analysis.ci_upper_limit).to eq(1.12)
      expect(analysis.estimate_description).to eq('Difference is CDM minus LCM')
    end

    it "should instantiate an instance of Study with these values" do
      nct_id='NCT00178087'
      study=Asker.new.create_study(nct_id)
      expect(study.number_of_groups).to eq(1)
      expect(study.eligibility.nct_id).to eq(nct_id)
      expect(study.facilities.first.nct_id).to eq(nct_id)
      expect(study.eligibility.sampling_method).to eq('Non-Probability Sample')
      expect(study.eligibility.gender).to eq 'Both'
      expect(study.eligibility.minimum_age).to eq '55 Years'
      expect(study.eligibility.maximum_age).to eq 'N/A'
      expect(study.eligibility.healthy_volunteers).to eq 'Accepts Healthy Volunteers'
      expect(study.eligibility.study_population).to eq("\n        150 elderly, non-demented, non-depressed subjects, 60 non-depressed mild cognitive\n        impairment subjects and 270 late-life depression subjects\n      ")
    end

    it "should instantiate an instance of Study with expected values" do
      nct_id='NCT00005669'
      study=Asker.new.create_study(nct_id)
      expect(study.last_changed_date == nil)
      expect(study.kind_of? Study)
      expect(study.nct_id).to eq nct_id
      expect(study.start_date_str).to eq "May 2000"
      expect(study.completion_date_str).to eq "May 2011"
      expect(study.primary_completion_date_str).to eq "August 2009"
      expect(study.start_date).to eq Date.parse(study.start_date_str)
      expect(study.completion_date).to eq Date.parse(study.completion_date_str)
      expect(study.primary_completion_date).to eq Date.parse(study.primary_completion_date_str)
      expect(study.verification_date).to eq Date.parse(study.verification_date_str)
      expect(study.detailed_description.description.length).to eq(1907)
      expect(study.completion_date_type).to eq('Actual')
      expect(study.primary_completion_date_type).to eq('Actual')
      expect(study.org_study_id).to eq('000134')
      expect(study.has_dmc).to eq(true)
      expect(study.is_section_801).to eq(true)
      expect(study.is_fda_regulated).to eq(true)
      expect(study.facilities.first.country).to eq('United States')
      expect(study.facilities.first.name).to eq('National Institutes of Health Clinical Center, 9000 Rockville Pike')
      expect(study.facilities.first.city).to eq('Bethesda')
      expect(study.facilities.first.state).to eq('Maryland')
      expect(study.facilities.first.zip).to eq('20892')
      expect(study.expected_groups.size).to eq(study.number_of_arms.to_i)
      g=study.expected_groups.select{|x| x.title=='1 - Metformin HCL'}.first
      expect(g.description).to eq('Subjects receive metformin plus a weight loss program')
      expect(g.type).to eq('Active Comparator')
      expect(study.keywords.size).to eq(7)
      expect(study.study_type).to eq('Interventional')
      expect(study.location_countries.size).to eq(1)
      expect(study.location_countries.first.nct_id).to eq(nct_id)
      expect(study.location_countries.first.name).to eq('United States')
      expect(study.oversight_authorities.first.nct_id).to eq(nct_id)
      expect(study.oversight_authorities.size).to eq(2)
      expect(study.oversight_authorities.map(&:name)).to include('United States: Federal Government')
      expect(study.design.nct_id).to eq(nct_id)
      expect(study.design.description).to eq('Allocation: Randomized, Endpoint Classification: Safety/Efficacy Study, Intervention Model: Parallel Assignment, Masking: Double Blind (Subject, Caregiver, Investigator, Outcomes Assessor), Primary Purpose: Treatment')
      expect(study.browse_conditions.first.nct_id).to eq(nct_id)
      expect(study.browse_conditions.size).to eq(3)
      expect(study.browse_interventions.size).to eq(1)
      expect(study.browse_interventions.first.mesh_term).to eq('Metformin')
      expect(study.browse_interventions.first.nct_id).to eq(nct_id)

      expect(study.expected_outcomes.first.nct_id).to eq(nct_id)
      expect(study.expected_outcomes.size).to eq(5)
      expect(study.expected_outcomes.first.nct_id).to eq(nct_id)

      expect(study.secondary_ids.size).to eq(1)
      expect(study.secondary_ids.map(&:secondary_id)).to include('00-CH-0134')
      expected_primary_outcome=study.outcomes.select{|o|o.type=='Primary' && o.group_title='Placebo Plus Weight Reduction Counseling'}.first
      expect(expected_primary_outcome.nct_id).to eq(nct_id)
      expect(expected_primary_outcome.time_frame).to eq('6 months')
      expect(expected_primary_outcome.safety_issue).to eq('No')
      expect(expected_primary_outcome.title).to eq('Changes in Body Weight as Determined by Body Mass Index-standard Deviation Score (BMI-SDS).')
      expect(study.eligibility.criteria.length).to eq(2337)
      expect(study.links.size).to eq(1)
      expect(study.links.first.nct_id).to eq(nct_id)
      expect(study.links.map(&:url)).to include('http://clinicalstudies.info.nih.gov/detail/B_2000-CH-0134.html')
      expect(study.links.map(&:description)).to include('NIH Clinical Center Detailed Web Page')
      expect(study.references.first.nct_id).to eq(nct_id)
      expect(study.references.size).to eq(3)
      expect(study.references.map(&:pmid)).to include('9481594')
      expect(study.references.map(&:pmid)).to include('20124139')
      expect(study.responsible_parties.first.nct_id).to eq(nct_id)
      expect(study.responsible_parties.size).to eq(1)
      expect(study.responsible_parties.map(&:name)).to include('Jack Yanovski, M.D.')
      expect(study.sponsors.first.nct_id).to eq(nct_id)
      expect(study.sponsors.size).to eq(2)
      expect(study.sponsors.select{|x|x.sponsor_type=='lead'}.first.agency).to eq('Jack Yanovski, M.D.')
      expect(study.sponsors.select{|x|x.sponsor_type=='collaborator'}.first.agency).to eq('Eunice Kennedy Shriver National Institute of Child Health and Human Development (NICHD)')
    end

    it "should cluster data into appropriate groups and save data values accurately" do
      nct_id='NCT00005669'
      study=Asker.new.create_study(nct_id)

      #MILESTONES
      g1=study.milestones.select{|x|x.ctgov_group_enumerator==1}
      g2=study.milestones.select{|x|x.ctgov_group_enumerator==2}
      expect(g1.size).to eq(3)
      expect(g2.size).to eq(3)
      expect(g1.select{|x|x.title=='NOT COMPLETED'}.first.participant_count).to eq(8)
      expect(g1.select{|x|x.title=='COMPLETED'}.first.participant_count).to eq(45)
      expect(g1.select{|x|x.title=='STARTED'}.first.participant_count).to eq(53)
      expect(g2.select{|x|x.title=='NOT COMPLETED'}.first.participant_count).to eq(7)
      expect(g2.select{|x|x.title=='COMPLETED'}.first.participant_count).to eq(40)
      expect(g2.select{|x|x.title=='STARTED'}.first.participant_count).to eq(47)

      #BASELINE MEASURES
      g1=study.baseline_measures.select{|x|x.ctgov_group_enumerator==1}
      g2=study.baseline_measures.select{|x|x.ctgov_group_enumerator==2}
      g3=study.baseline_measures.select{|x|x.ctgov_group_enumerator==3}
      expect(g1.size).to eq(8)
      expect(g2.size).to eq(8)
      expect(g3.size).to eq(8)
      expect(g1.select{|x|x.title=='Gender' && x.category=='Male'}.first.measure_value).to eq('23')
      expect(g1.select{|x|x.title=='Gender' && x.category=='Female'}.first.measure_value).to eq('30')
      expect(g1.select{|x|x.title=='Age' && x.category==''}.first.measure_value).to eq('10.1')
      expect(g1.select{|x|x.title=='Age' && x.category=='Between 18 and 65 years'}.first.measure_value).to eq('0')
      expect(g1.select{|x|x.title=='Age' && x.category=='&gt;=65 years'}.first.measure_value).to eq('0')
      expect(g1.select{|x|x.title=='Age' && x.category=='&lt;=18 years'}.first.measure_value).to eq('53')
      expect(g1.select{|x|x.title=='Number of Participants'}.first.measure_value).to eq('53')

      expect(g2.select{|x|x.title=='Gender' && x.category=='Male'}.first.measure_value).to eq('17')
      expect(g2.select{|x|x.title=='Gender' && x.category=='Female'}.first.measure_value).to eq('30')
      expect(g2.select{|x|x.title=='Age' && x.category==''}.first.measure_value).to eq('10.4')
      expect(g2.select{|x|x.title=='Age' && x.category=='Between 18 and 65 years'}.first.measure_value).to eq('0')
      expect(g1.select{|x|x.title=='Age' && x.category=='&gt;=65 years'}.first.measure_value).to eq('0')
      expect(g2.select{|x|x.title=='Age' && x.category=='&lt;=18 years'}.first.measure_value).to eq('47')
      expect(g2.select{|x|x.title=='Number of Participants'}.first.measure_value).to eq('47')

      expect(g3.select{|x|x.title=='Gender' && x.category=='Male'}.first.measure_value).to eq('40')
      expect(g3.select{|x|x.title=='Gender' && x.category=='Female'}.first.measure_value).to eq('60')
      expect(g3.select{|x|x.title=='Age' && x.category==''}.first.measure_value).to eq('10.2')
      expect(g3.select{|x|x.title=='Age' && x.category=='Between 18 and 65 years'}.first.measure_value).to eq('0')
      expect(g3.select{|x|x.title=='Age' && x.category=='&gt;=65 years'}.first.measure_value).to eq('0')
      expect(g3.select{|x|x.title=='Age' && x.category=='&lt;=18 years'}.first.measure_value).to eq('100')
      expect(g3.select{|x|x.title=='Number of Participants'}.first.measure_value).to eq('100')

      #REPORTED EVENTS
      g1=study.reported_events.select{|x|x.ctgov_group_enumerator==1}
      g2=study.reported_events.select{|x|x.ctgov_group_enumerator==2}
      g3=study.reported_events.select{|x|x.ctgov_group_enumerator==3}
      expect(g1.size).to eq(8)
      expect(g2.size).to eq(8)
      expect(g3.size).to eq(0)

      expect(g1.select{|x|x.title=='Decreased Happiness'}.first.subjects_affected).to eq(14)
      expect(g1.select{|x|x.title=='Decreased Happiness'}.first.subjects_at_risk).to eq(53)
      expect(g1.select{|x|x.title=='Decreased Happiness'}.first.event_count).to eq(14)
      expect(g1.select{|x|x.title=='Fatigue'}.first.subjects_affected).to eq(20)
      expect(g1.select{|x|x.title=='Fatigue'}.first.subjects_at_risk).to eq(53)
      expect(g1.select{|x|x.title=='Fatigue'}.first.event_count).to eq(29)
      expect(g1.select{|x|x.title=='Increased Bowel Movements'}.first.subjects_affected).to eq(22)
      expect(g1.select{|x|x.title=='Increased Bowel Movements'}.first.subjects_at_risk).to eq(53)
      expect(g1.select{|x|x.title=='Increased Bowel Movements'}.first.event_count).to eq(25)
      expect(g1.select{|x|x.title=='Bloating'}.first.subjects_affected).to eq(13)
      expect(g1.select{|x|x.title=='Bloating'}.first.subjects_at_risk).to eq(53)
      expect(g1.select{|x|x.title=='Bloating'}.first.event_count).to eq(20)
      expect(g1.select{|x|x.title=='Vomiting'}.first.subjects_affected).to eq(22)
      expect(g1.select{|x|x.title=='Vomiting'}.first.subjects_at_risk).to eq(53)
      expect(g1.select{|x|x.title=='Vomiting'}.first.event_count).to eq(36)
      expect(g1.select{|x|x.title=='Liquid Stools'}.first.subjects_affected).to eq(22)
      expect(g1.select{|x|x.title=='Liquid Stools'}.first.subjects_at_risk).to eq(53)
      expect(g1.select{|x|x.title=='Liquid Stools'}.first.event_count).to eq(34)
      expect(g1.select{|x|x.title=='Nausea'}.first.subjects_affected).to eq(28)
      expect(g1.select{|x|x.title=='Nausea'}.first.subjects_at_risk).to eq(53)
      expect(g1.select{|x|x.title=='Nausea'}.first.event_count).to eq(55)
      expect(g1.select{|x|x.title=='Total, other adverse events'}.first.subjects_affected).to eq(48)
      expect(g1.select{|x|x.title=='Total, other adverse events'}.first.subjects_at_risk).to eq(53)

      expect(g2.select{|x|x.title=='Decreased Happiness'}.first.subjects_affected).to eq(6)
      expect(g2.select{|x|x.title=='Decreased Happiness'}.first.subjects_at_risk).to eq(47)
      expect(g2.select{|x|x.title=='Decreased Happiness'}.first.event_count).to eq(9)
      expect(g2.select{|x|x.title=='Fatigue'}.first.subjects_affected).to eq(7)
      expect(g2.select{|x|x.title=='Fatigue'}.first.subjects_at_risk).to eq(47)
      expect(g2.select{|x|x.title=='Fatigue'}.first.event_count).to eq(10)
      expect(g2.select{|x|x.title=='Increased Bowel Movements'}.first.subjects_affected).to eq(11)
      expect(g2.select{|x|x.title=='Increased Bowel Movements'}.first.subjects_at_risk).to eq(47)
      expect(g2.select{|x|x.title=='Increased Bowel Movements'}.first.event_count).to eq(13)
      expect(g2.select{|x|x.title=='Bloating'}.first.subjects_affected).to eq(6)
      expect(g2.select{|x|x.title=='Bloating'}.first.subjects_at_risk).to eq(47)
      expect(g2.select{|x|x.title=='Bloating'}.first.event_count).to eq(7)
      expect(g2.select{|x|x.title=='Vomiting'}.first.subjects_affected).to eq(10)
      expect(g2.select{|x|x.title=='Vomiting'}.first.subjects_at_risk).to eq(47)
      expect(g2.select{|x|x.title=='Vomiting'}.first.event_count).to eq(10)
      expect(g2.select{|x|x.title=='Liquid Stools'}.first.subjects_affected).to eq(8)
      expect(g2.select{|x|x.title=='Liquid Stools'}.first.subjects_at_risk).to eq(47)
      expect(g2.select{|x|x.title=='Liquid Stools'}.first.event_count).to eq(8)
      expect(g2.select{|x|x.title=='Nausea'}.first.subjects_affected).to eq(17)
      expect(g2.select{|x|x.title=='Nausea'}.first.subjects_at_risk).to eq(47)
      expect(g2.select{|x|x.title=='Nausea'}.first.event_count).to eq(18)
      expect(g2.select{|x|x.title=='Total, other adverse events'}.first.subjects_affected).to eq(46)
      expect(g2.select{|x|x.title=='Total, other adverse events'}.first.subjects_at_risk).to eq(47)
    end

    it "should save correct derived values" do
		  nct_id='NCT00000137'
      study=Asker.new.create_study(nct_id)
			expect(study.design_type).to eq('randomized double blind')
    end

  end
