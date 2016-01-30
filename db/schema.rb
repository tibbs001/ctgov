# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160130223407) do

  create_table "baseline_measures", force: :cascade do |t|
    t.string   "ctgov_group_id",         limit: 255
    t.integer  "ctgov_group_enumerator", limit: 4
    t.string   "category",               limit: 255
    t.string   "title",                  limit: 255
    t.text     "description",            limit: 65535
    t.string   "units",                  limit: 255
    t.string   "param",                  limit: 255
    t.string   "measure_value",          limit: 255
    t.string   "lower_limit",            limit: 255
    t.string   "upper_limit",            limit: 255
    t.string   "dispersion",             limit: 255
    t.string   "spread",                 limit: 255
    t.text     "measure_description",    limit: 65535
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "nct_id",                 limit: 255
  end

  create_table "brief_summaries", force: :cascade do |t|
    t.text   "description", limit: 65535
    t.string "nct_id",      limit: 255
  end

  add_index "brief_summaries", ["nct_id"], name: "index_brief_summaries_on_nct_id", using: :btree

  create_table "browse_conditions", force: :cascade do |t|
    t.string   "mesh_term",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "nct_id",     limit: 255
  end

  add_index "browse_conditions", ["nct_id"], name: "index_browse_conditions_on_nct_id", using: :btree

  create_table "browse_interventions", force: :cascade do |t|
    t.string   "mesh_term",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "nct_id",     limit: 255
  end

  add_index "browse_interventions", ["nct_id"], name: "index_browse_interventions_on_nct_id", using: :btree

  create_table "conditions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "nct_id",     limit: 255
  end

  add_index "conditions", ["name"], name: "index_conditions_on_name", using: :btree
  add_index "conditions", ["nct_id"], name: "index_conditions_on_nct_id", using: :btree

  create_table "data_definitions", force: :cascade do |t|
    t.string "column_name",    limit: 255
    t.string "table_name",     limit: 255
    t.text   "value_list",     limit: 65535
    t.string "ctgov_source",   limit: 255
    t.string "nlm_required",   limit: 255
    t.string "fdaaa_required", limit: 255
    t.text   "nlm_definition", limit: 65535
    t.text   "ctti_notes",     limit: 65535
    t.string "data_source",    limit: 255
    t.string "data_field",     limit: 255
  end

  create_table "design_validations", force: :cascade do |t|
    t.string "design_name",  limit: 255
    t.string "design_value", limit: 255
    t.string "masked_role",  limit: 255
    t.string "nct_id",       limit: 255
  end

  add_index "design_validations", ["nct_id"], name: "index_design_validations_on_nct_id", using: :btree

  create_table "designs", force: :cascade do |t|
    t.text   "description",             limit: 65535
    t.string "masking",                 limit: 255
    t.string "masked_roles",            limit: 255
    t.string "primary_purpose",         limit: 255
    t.string "intervention_model",      limit: 255
    t.string "endpoint_classification", limit: 255
    t.string "allocation",              limit: 255
    t.string "time_perspective",        limit: 255
    t.string "observational_model",     limit: 255
    t.string "nct_id",                  limit: 255
  end

  add_index "designs", ["nct_id"], name: "index_designs_on_nct_id", using: :btree

  create_table "detailed_descriptions", force: :cascade do |t|
    t.text   "description", limit: 65535
    t.string "nct_id",      limit: 255
  end

  add_index "detailed_descriptions", ["nct_id"], name: "index_detailed_descriptions_on_nct_id", using: :btree

  create_table "drop_withdrawals", force: :cascade do |t|
    t.string   "period_title",           limit: 255
    t.string   "ctgov_group_id",         limit: 255
    t.integer  "ctgov_group_enumerator", limit: 4
    t.string   "reason",                 limit: 255
    t.integer  "participant_count",      limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "nct_id",                 limit: 255
    t.integer  "group_id",               limit: 4
  end

  create_table "eligibilities", force: :cascade do |t|
    t.string "sampling_method",    limit: 255
    t.string "gender",             limit: 255
    t.string "minimum_age",        limit: 255
    t.string "maximum_age",        limit: 255
    t.string "healthy_volunteers", limit: 255
    t.text   "study_population",   limit: 65535
    t.text   "criteria",           limit: 65535
    t.string "nct_id",             limit: 255
  end

  add_index "eligibilities", ["nct_id"], name: "index_eligibilities_on_nct_id", using: :btree

  create_table "expected_groups", force: :cascade do |t|
    t.string   "ctgov_group_id",         limit: 255
    t.integer  "ctgov_group_enumerator", limit: 4
    t.string   "title",                  limit: 255
    t.string   "group_type",             limit: 255
    t.text     "description",            limit: 65535
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "nct_id",                 limit: 255
  end

  add_index "expected_groups", ["nct_id"], name: "index_expected_groups_on_nct_id", using: :btree

  create_table "expected_outcomes", force: :cascade do |t|
    t.string "outcome_type", limit: 255
    t.text   "title",        limit: 65535
    t.text   "measure",      limit: 65535
    t.text   "time_frame",   limit: 65535
    t.string "safety_issue", limit: 255
    t.string "population",   limit: 255
    t.text   "description",  limit: 65535
    t.string "nct_id",       limit: 255
  end

  add_index "expected_outcomes", ["nct_id"], name: "index_expected_outcomes_on_nct_id", using: :btree

  create_table "facilities", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "status",               limit: 255
    t.string   "city",                 limit: 255
    t.string   "state",                limit: 255
    t.string   "zip",                  limit: 255
    t.string   "country",              limit: 255
    t.string   "latitude",             limit: 255
    t.string   "longitude",            limit: 255
    t.string   "contact_name",         limit: 255
    t.string   "contact_phone",        limit: 255
    t.string   "contact_email",        limit: 255
    t.string   "contact_backup_name",  limit: 255
    t.string   "contact_backup_phone", limit: 255
    t.string   "contact_backup_email", limit: 255
    t.text     "investigator_name",    limit: 65535
    t.text     "investigator_role",    limit: 65535
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "nct_id",               limit: 255
  end

  add_index "facilities", ["nct_id"], name: "index_facilities_on_nct_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "ctgov_group_id",            limit: 255
    t.integer  "ctgov_group_enumerator",    limit: 4
    t.string   "group_type",                limit: 255
    t.string   "title",                     limit: 255
    t.text     "description",               limit: 65535
    t.integer  "participant_count",         limit: 4
    t.integer  "derived_participant_count", limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "nct_id",                    limit: 255
  end

  create_table "intervention_arm_group_labels", force: :cascade do |t|
    t.string   "label",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "nct_id",          limit: 255
    t.string   "intervention_id", limit: 255
  end

  add_index "intervention_arm_group_labels", ["intervention_id"], name: "index_intervention_arm_group_labels_on_intervention_id", using: :btree
  add_index "intervention_arm_group_labels", ["nct_id"], name: "index_intervention_arm_group_labels_on_nct_id", using: :btree

  create_table "intervention_other_names", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "nct_id",          limit: 255
    t.string   "intervention_id", limit: 255
  end

  add_index "intervention_other_names", ["intervention_id"], name: "index_intervention_other_names_on_intervention_id", using: :btree
  add_index "intervention_other_names", ["name"], name: "index_intervention_other_names_on_name", using: :btree
  add_index "intervention_other_names", ["nct_id"], name: "index_intervention_other_names_on_nct_id", using: :btree

  create_table "interventions", force: :cascade do |t|
    t.string   "intervention_type", limit: 255
    t.string   "name",              limit: 255
    t.text     "description",       limit: 65535
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "nct_id",            limit: 255
  end

  add_index "interventions", ["name"], name: "index_interventions_on_name", using: :btree
  add_index "interventions", ["nct_id"], name: "index_interventions_on_nct_id", using: :btree

  create_table "keywords", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "nct_id",     limit: 255
  end

  add_index "keywords", ["name"], name: "index_keywords_on_name", using: :btree
  add_index "keywords", ["nct_id"], name: "index_keywords_on_nct_id", using: :btree

  create_table "links", force: :cascade do |t|
    t.text   "url",         limit: 65535
    t.text   "description", limit: 65535
    t.string "nct_id",      limit: 255
  end

  add_index "links", ["nct_id"], name: "index_links_on_nct_id", using: :btree

  create_table "load_events", force: :cascade do |t|
    t.string   "nct_id",      limit: 255
    t.string   "event_type",  limit: 255
    t.string   "status",      limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "location_countries", force: :cascade do |t|
    t.string "name",    limit: 255
    t.string "removed", limit: 255
    t.string "nct_id",  limit: 255
  end

  add_index "location_countries", ["name"], name: "index_location_countries_on_name", using: :btree
  add_index "location_countries", ["nct_id"], name: "index_location_countries_on_nct_id", using: :btree

  create_table "milestones", force: :cascade do |t|
    t.string   "period_title",           limit: 255
    t.string   "ctgov_group_id",         limit: 255
    t.integer  "ctgov_group_enumerator", limit: 4
    t.string   "title",                  limit: 255
    t.text     "description",            limit: 65535
    t.integer  "participant_count",      limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "nct_id",                 limit: 255
    t.integer  "group_id",               limit: 4
  end

  create_table "outcome_analyses", force: :cascade do |t|
    t.string   "ctgov_group_id",              limit: 255
    t.integer  "ctgov_group_enumerator",      limit: 4
    t.string   "title",                       limit: 255
    t.string   "non_inferiority",             limit: 255
    t.text     "non_inferiority_description", limit: 65535
    t.decimal  "p_value",                                   precision: 15, scale: 10
    t.string   "param_type",                  limit: 255
    t.decimal  "param_value",                               precision: 15, scale: 10
    t.string   "dispersion_type",             limit: 255
    t.decimal  "dispersion_value",                          precision: 15, scale: 10
    t.string   "ci_percent",                  limit: 255
    t.string   "ci_n_sides",                  limit: 255
    t.decimal  "ci_lower_limit",                            precision: 15, scale: 10
    t.decimal  "ci_upper_limit",                            precision: 16, scale: 8
    t.string   "method",                      limit: 255
    t.text     "description",                 limit: 65535
    t.text     "group_description",           limit: 65535
    t.text     "method_description",          limit: 65535
    t.text     "estimate_description",        limit: 65535
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.string   "nct_id",                      limit: 255
    t.integer  "outcome_id",                  limit: 4
    t.integer  "group_id",                    limit: 4
  end

  create_table "outcome_measures", force: :cascade do |t|
    t.string   "ctgov_group_id",         limit: 255
    t.integer  "ctgov_group_enumerator", limit: 4
    t.string   "category",               limit: 255
    t.string   "title",                  limit: 255
    t.text     "description",            limit: 65535
    t.string   "units",                  limit: 255
    t.string   "param",                  limit: 255
    t.string   "measure_value",          limit: 255
    t.string   "lower_limit",            limit: 255
    t.string   "upper_limit",            limit: 255
    t.string   "dispersion",             limit: 255
    t.string   "spread",                 limit: 255
    t.text     "measure_description",    limit: 65535
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "nct_id",                 limit: 255
    t.integer  "outcome_id",             limit: 4
    t.integer  "group_id",               limit: 4
  end

  create_table "outcomes", force: :cascade do |t|
    t.string   "outcome_type",           limit: 255
    t.string   "ctgov_group_id",         limit: 255
    t.integer  "ctgov_group_enumerator", limit: 4
    t.text     "group_title",            limit: 65535
    t.text     "group_description",      limit: 65535
    t.text     "title",                  limit: 65535
    t.text     "description",            limit: 65535
    t.string   "measure",                limit: 255
    t.text     "time_frame",             limit: 65535
    t.string   "safety_issue",           limit: 255
    t.text     "population",             limit: 65535
    t.integer  "participant_count",      limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "nct_id",                 limit: 255
    t.integer  "group_id",               limit: 4
  end

  create_table "overall_officials", force: :cascade do |t|
    t.string "name",        limit: 255
    t.string "role",        limit: 255
    t.string "affiliation", limit: 255
    t.string "nct_id",      limit: 255
  end

  add_index "overall_officials", ["nct_id"], name: "index_overall_officials_on_nct_id", using: :btree

  create_table "oversight_authorities", force: :cascade do |t|
    t.string "name",   limit: 255
    t.string "nct_id", limit: 255
  end

  add_index "oversight_authorities", ["nct_id"], name: "index_oversight_authorities_on_nct_id", using: :btree

  create_table "participant_flows", force: :cascade do |t|
    t.text     "recruitment_details",    limit: 65535
    t.text     "pre_assignment_details", limit: 65535
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "nct_id",                 limit: 255
  end

  create_table "reported_event_overviews", force: :cascade do |t|
    t.string   "time_frame",  limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "nct_id",      limit: 255
  end

  create_table "reported_events", force: :cascade do |t|
    t.string   "ctgov_group_id",         limit: 255
    t.integer  "ctgov_group_enumerator", limit: 4
    t.string   "group_title",            limit: 255
    t.text     "group_description",      limit: 65535
    t.text     "description",            limit: 65535
    t.text     "time_frame",             limit: 65535
    t.string   "category",               limit: 255
    t.string   "event_type",             limit: 255
    t.string   "frequency_threshold",    limit: 255
    t.string   "default_vocab",          limit: 255
    t.string   "default_assessment",     limit: 255
    t.string   "title",                  limit: 255
    t.integer  "subjects_affected",      limit: 4
    t.integer  "subjects_at_risk",       limit: 4
    t.integer  "event_count",            limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "nct_id",                 limit: 255
  end

  create_table "responsible_parties", force: :cascade do |t|
    t.string "responsible_party_type", limit: 255
    t.text   "affiliation",            limit: 65535
    t.string "name",                   limit: 255
    t.string "title",                  limit: 255
    t.string "nct_id",                 limit: 255
  end

  add_index "responsible_parties", ["nct_id"], name: "index_responsible_parties_on_nct_id", using: :btree

  create_table "result_agreements", force: :cascade do |t|
    t.string   "pi_employee",    limit: 255
    t.text     "agreement",      limit: 65535
    t.string   "agreement_type", limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "nct_id",         limit: 255
  end

  create_table "result_contacts", force: :cascade do |t|
    t.string   "name_or_title", limit: 255
    t.string   "organization",  limit: 255
    t.string   "phone",         limit: 255
    t.string   "email",         limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "nct_id",        limit: 255
  end

  create_table "result_details", force: :cascade do |t|
    t.text     "recruitment_details",    limit: 65535
    t.text     "pre_assignment_details", limit: 65535
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "nct_id",                 limit: 255
  end

  create_table "search_results", force: :cascade do |t|
    t.date     "search_datestamp"
    t.string   "search_term",      limit: 255
    t.string   "nct_id",           limit: 255
    t.integer  "order",            limit: 4
    t.decimal  "score",                        precision: 6, scale: 4
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "secondary_ids", force: :cascade do |t|
    t.string "secondary_id", limit: 255
    t.string "nct_id",       limit: 255
  end

  add_index "secondary_ids", ["nct_id"], name: "index_secondary_ids_on_nct_id", using: :btree

  create_table "sponsors", force: :cascade do |t|
    t.string "sponsor_type", limit: 255
    t.string "agency",       limit: 255
    t.string "agency_class", limit: 255
    t.string "nct_id",       limit: 255
  end

  add_index "sponsors", ["nct_id"], name: "index_sponsors_on_nct_id", using: :btree

  create_table "studies", id: false, force: :cascade do |t|
    t.string   "nct_id",                          limit: 255
    t.date     "start_date"
    t.date     "first_received_date"
    t.date     "verification_date"
    t.date     "last_changed_date"
    t.date     "primary_completion_date"
    t.date     "completion_date"
    t.date     "first_received_results_date"
    t.date     "download_date"
    t.string   "start_date_str",                  limit: 255
    t.string   "first_received_date_str",         limit: 255
    t.string   "verification_date_str",           limit: 255
    t.string   "last_changed_date_str",           limit: 255
    t.string   "primary_completion_date_str",     limit: 255
    t.string   "completion_date_str",             limit: 255
    t.string   "first_received_results_date_str", limit: 255
    t.string   "download_date_str",               limit: 255
    t.string   "completion_date_type",            limit: 255
    t.string   "primary_completion_date_type",    limit: 255
    t.string   "org_study_id",                    limit: 255
    t.string   "secondary_id",                    limit: 255
    t.text     "brief_title",                     limit: 65535
    t.text     "official_title",                  limit: 65535
    t.string   "overall_status",                  limit: 255
    t.string   "phase",                           limit: 255
    t.string   "target_duration",                 limit: 255
    t.decimal  "actual_duration",                               precision: 5, scale: 2
    t.integer  "reported_enrollment",             limit: 4
    t.integer  "derived_enrollment",              limit: 4
    t.string   "enrollment_type",                 limit: 255
    t.string   "study_type",                      limit: 255
    t.integer  "number_of_arms",                  limit: 4
    t.integer  "number_of_groups",                limit: 4
    t.string   "sponsor_type",                    limit: 255
    t.string   "source",                          limit: 255
    t.integer  "results_reported",                limit: 4
    t.string   "biospec_retention",               limit: 255
    t.text     "biospec_description",             limit: 65535
    t.string   "study_rank",                      limit: 255
    t.string   "limitations_and_caveats",         limit: 255
    t.string   "delivery_mechanism",              limit: 255
    t.string   "description",                     limit: 255
    t.string   "acronym",                         limit: 255
    t.string   "why_stopped",                     limit: 255
    t.boolean  "is_section_801"
    t.boolean  "is_fda_regulated"
    t.boolean  "has_expanded_access"
    t.boolean  "has_dmc"
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
  end

  add_index "studies", ["nct_id"], name: "index_studies_on_nct_id", using: :btree
  add_index "studies", ["study_type"], name: "index_studies_on_study_type", using: :btree

  create_table "study_references", force: :cascade do |t|
    t.text   "citation",       limit: 65535
    t.string "pmid",           limit: 255
    t.string "reference_type", limit: 255
    t.string "nct_id",         limit: 255
  end

  add_index "study_references", ["nct_id"], name: "index_study_references_on_nct_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
