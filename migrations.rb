--  oversight_info - authority

create or replace view studies           as select 
  nct_id as id,
  nct_id,
  download_date_dt as downloaded_date,
--  to_date(verification_date,'month YYYY') as verification_date,
--  to_date(lastchanged_date,'month dd, YYYY') as last_changed_date,
--  to_date(firstreceived_date,'month dd, YYYY') as first_received_date,
--  to_date(start_date,'month YYYY') as start_date,
--  to_date(completion_date,'month YYYY') as completion_date,
--  to_date(primary_completion_date,'month YYYY') as primary_completion_date,
--  to_date(firstreceived_results_date,'month YYYY') as first_received_results_date,
  verification_date as verification_date,
  lastchanged_date as last_changed_date,
  firstreceived_date as first_received_date,
  start_date as start_date,
  completion_date as completion_date,
  primary_completion_date as primary_completion_date,
  firstreceived_results_date as first_received_results_date,
  completion_date_type,
  primary_completion_date_type,
  org_study_id as org_id,
  brief_title, 
  official_title as title,
  brief_summary,
  detailed_description as description,
  acronym,
  source as study_source,
  has_dmc,
  is_section_801,
  is_fda_regulated,
  overall_status,
  phase,
  study_type,
  study_design,
  number_of_arms,
  number_of_groups,
  enrollment_type,
  enrollment,
  biospec_retention,
  biospec_descr as biospec_description,
  criteria,
  gender,
  minimum_age,
  maximum_age,
  healthy_volunteers,
  sampling_method,
  study_pop as population,
  why_stopped,
  has_expanded_access,
  url,
  target_duration,
  study_rank,
  limitations_and_caveats 
from clintrialsgov.clinical_study;

create or replace view agreements  as select agreement_id as id,nct_id,pi_employee,restrictive_agreement as agreement from clintrialsgov.results_restriction_agreements;
create or replace view aliases     as select nct_alias_id as id,nct_id,nct_alias from clintrialsgov.nct_aliases;
create or replace view authorities as select authority_id as id,nct_id,authority from clintrialsgov.authorities;
create or replace view conditions  as select condition_id as id,nct_id,condition from clintrialsgov.conditions;
create or replace view general_contacts    as select central_contact_id as id,nct_id,contact_type,name_degree,phone,phone_ext,email from clintrialsgov.central_contacts;
create or replace view countries   as select location_countries_id as id,nct_id,country from clintrialsgov.location_countries;
create or replace view designs     as select design_id as id,nct_id,design_name,design_value,masked_role from clintrialsgov.designs;
create or replace view facilities  as select facility_id as id,nct_id,status,facility_name,city,state,zip,country from clintrialsgov.facilities;
create or replace view investigators as select investigator_id as id,nct_id,facility_id,name_degree,role,affiliation from clintrialsgov.investigators;
create or replace view interventions as select intervention_id as id,nct_id,intervention_type,intervention_name as name,description from clintrialsgov.interventions;
create or replace view keywords    as select keyword_id as id, nct_id, keyword from clintrialsgov.keywords;
create or replace view links       as select link_id as id, nct_id, url, description from clintrialsgov.links;
create or replace view secondary_ids  as select sec_id as id,nct_id, secondary_id from clintrialsgov.secondary_ids;
create or replace view overall_officials   as select overall_official_id as id,nct_id,role,name_degree,affiliation from clintrialsgov.overall_officials;
create or replace view participants as select participant_flow_id as id,nct_id,period_title as title,recruitment_details,pre_assignment_details from clintrialsgov.results_partic_flows;
create or replace view populations as select rslts_baseline_id as id,nct_id,population from clintrialsgov.results_baseline;
create or replace view references  as select reference_id as id,nct_id,reference_type,citation,pmid from clintrialsgov.references;
create or replace view responsible_parties as select responsible_party_id as id,nct_id,name_title,organization,responsible_party_type,investigator_affiliation,investigator_full_name as investigator_name,investigator_title from clintrialsgov.responsible_parties;
create or replace view sponsors    as select sponsor_id as id,nct_id,sponsor_type,agency,agency_class from clintrialsgov.sponsors;

create or replace view arms        as select arm_group_id as id,nct_id,arm_group_label as label,arm_group_type as arm_type,description,group_id from clintrialsgov.arm_groups;
create or replace view arms_outcomes_analyses   as select results_outcome_anal_grp_id as id,results_outcome_analysis_id as outcomes_analysis_id,arm_group_id as arm_id from clintrialsgov.results_outcome_analysis_grp;
create or replace view arms_baseline_measures as select baseline_measure_catgy_id as id,arm_group_id as arm_id,baseline_id as baseline_measure_id,category_title,baseline_value,spread,lower_limit,upper_limit from clintrialsgov.results_baseline_measure_catgy;
create or replace view arms_interventions  as select iag.int_arm_group_id as id,iag.intervention_id,a.arm_group_id as arm_id from clintrialsgov.intervention_arm_groups iag,clintrialsgov.arm_groups a where a.arm_group_label=iag.arm_group_label;
create or replace view arm_milestones   as select milestone_group_id as id,arm_group_id as arm_id,milestone_id,partflow_count as participant_count,participant_description as description from  clintrialsgov.results_partflow_mlstn_grp;
create or replace view arm_outcomes     as select outcome_measure_catgy_id as id,outcome_measure_id,category_title as title,arm_group_id as arm_id,outcome_value,spread,lower_limit,upper_limit from  clintrialsgov.results_outcome_measure_ctgy;

create or replace view facility_contacts as select facility_contact_id as id,facility_id as facility_id,contact_type,name_degree,phone,phone_ext,email from clintrialsgov.facility_contacts;

create or replace view prespecified_outcomes as select outcome_id as id,nct_id,study_outcomes_type as outcome_type,measure,safety_issue,time_frame,description from clintrialsgov.study_outcome;
create or replace view outcomes   as select outcome_id as id,nct_id, outcome_type,outcome_title as title,safety_issue,time_frame,outcome_description as description,population,posting_date from clintrialsgov.results_outcomes;
create or replace view baseline_measures as select baseline_id as id,rslts_baseline_id as population_id,baseline_measure_title as title,description,units_of_measure,measure_type,dispersion from clintrialsgov.results_baseline_measures;
create or replace view outcomes_measures  as select outcome_measure_id as id,outcome_id as outcome_id,outcome_measure_title as title,measure_description as description,unit_of_measure,measure_type,dispersion from  clintrialsgov.results_outcome_measure;
create or replace view outcomes_contacts as select point_of_contact_id as id,nct_id,name_or_title,organization,phone,email from clintrialsgov.results_point_of_contact;

create or replace view milestones        as select milestone_id as id,milestone_type,milestone_title as title from clintrialsgov.results_partflow_mlstn;
create or replace view participants_milestones as select participant_flow_id as participant_id,milestone_id from clintrialsgov.results_partflow_mlstn;

create or replace view outcomes_analyses  as select results_outcome_analysis_id as id,outcome_id,param_type,dispersion_type,ci_percent,ci_lower_limit,ci_upper_limit,groups_desc,non_inferiority,non_inferiority_desc,p_value,p_value_desc,method as study_method,method_desc,param_value,estimate_desc,dispersion_value,ci_n_sides,ci_upper_limit_na_comment as comments from clintrialsgov.results_outcome_analysis;
create or replace view intervention_other_names as select o.int_other_name_id as id,o.intervention_id,o.other_name from clintrialsgov.intervention_other_names o, clintrialsgov.interventions i where i.intervention_id=o.intervention_id;

create or replace view removed_countries as select removed_countries_id as id,nct_id, country from clintrialsgov.removed_countries;

create or replace view arms_reported_events       as select reported_event_catgy_grp_id as id,reported_event_category_id as reported_event_id,arm_group_id as arm_id,subjects_affected,subjects_at_risk,events from clintrialsgov.reported_event_ctgy_grp;

create or replace view reported_events  as
select re.reported_event_id as id,re.nct_id,re.event_type,re.time_frame,re.description,re.frequency_threshold,re.default_vocab,re.default_assessment,
c.category_title as title, c.category_sub_title as sub_title, c.category_description, c.category_assessment as assessment
from clintrialsgov.reported_events re, clintrialsgov.reported_event_ctgy c
where c.reported_event_category_id=re.reported_event_id;


