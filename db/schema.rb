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

ActiveRecord::Schema.define(version: 20140620210430) do

  create_table "countries", force: true do |t|
    t.string  "country",  limit: 100
    t.string  "code",     limit: 10
    t.boolean "closed",               default: false
    t.string  "iso_code"
  end

  create_table "email_addresses", force: true do |t|
    t.string   "email"
    t.integer  "person_id"
    t.boolean  "primary",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "global_registry_id"
  end

  add_index "email_addresses", ["email"], name: "email", using: :btree
  add_index "email_addresses", ["person_id"], name: "person_id", using: :btree

  create_table "infobase_bookmarks", force: true do |t|
    t.integer "user_id"
    t.string  "name",    limit: 64
    t.string  "value"
  end

  add_index "infobase_bookmarks", ["name"], name: "index_infobase_bookmarks_on_name", using: :btree
  add_index "infobase_bookmarks", ["user_id"], name: "index_infobase_bookmarks_on_user_id", using: :btree

  create_table "infobase_users", force: true do |t|
    t.integer  "user_id"
    t.string   "type",       default: "InfobaseUser"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ministries", force: true do |t|
    t.string "name"
    t.string "abbreviation"
    t.string "global_registry_id"
  end

  create_table "ministry_activity", primary_key: "ActivityID", force: true do |t|
    t.string   "status",                   limit: 2
    t.date     "periodBegin"
    t.datetime "periodEnd_deprecated"
    t.string   "strategy",                 limit: 2
    t.string   "transUsername",            limit: 50
    t.integer  "fk_targetAreaID",                     null: false
    t.integer  "fk_teamID",                           null: false
    t.string   "statusHistory_deprecated", limit: 2
    t.string   "url"
    t.string   "facebook"
    t.integer  "sent_teamID"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gcx_site"
    t.string   "global_registry_id"
  end

  add_index "ministry_activity", ["fk_targetAreaID", "strategy"], name: "index_ministry_activity_on_fk_targetareaid_and_strategy", unique: true, using: :btree
  add_index "ministry_activity", ["fk_targetAreaID"], name: "fk_targetAreaID_idx", using: :btree
  add_index "ministry_activity", ["fk_targetAreaID"], name: "index1", using: :btree
  add_index "ministry_activity", ["fk_teamID"], name: "index2", using: :btree
  add_index "ministry_activity", ["periodBegin"], name: "index3", using: :btree
  add_index "ministry_activity", ["strategy"], name: "index5", using: :btree

  create_table "ministry_activity_history", force: true do |t|
    t.integer  "activity_id",                       null: false
    t.string   "from_status_deprecated", limit: 2
    t.string   "status",                 limit: 2
    t.datetime "period_begin"
    t.datetime "period_end_deprecated"
    t.string   "trans_username",         limit: 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ministry_activity_history", ["activity_id"], name: "activity_id", using: :btree
  add_index "ministry_activity_history", ["period_begin"], name: "period_begin", using: :btree
  add_index "ministry_activity_history", ["status"], name: "to_status", using: :btree

  create_table "ministry_address", primary_key: "AddressID", force: true do |t|
    t.datetime "startdate"
    t.datetime "enddate"
    t.string   "address1",  limit: 60
    t.string   "address2",  limit: 60
    t.string   "address3",  limit: 60
    t.string   "address4",  limit: 60
    t.string   "city",      limit: 35
    t.string   "state",     limit: 6
    t.string   "zip",       limit: 10
    t.string   "country",   limit: 64
  end

  create_table "ministry_assoc_dependents", id: false, force: true do |t|
    t.integer "DependentID",                           null: false
    t.string  "accountNo",   limit: 11,                null: false
    t.boolean "dbioDummy",              default: true, null: false
  end

  create_table "ministry_assoc_otherministries", id: false, force: true do |t|
    t.string  "NonCccMinID",  limit: 64,                null: false
    t.string  "TargetAreaID", limit: 64,                null: false
    t.boolean "dbioDummy",               default: true, null: false
  end

  create_table "ministry_authorization", primary_key: "AuthorizationID", force: true do |t|
    t.datetime "authdate"
    t.string   "role",                 limit: 30
    t.string   "authorized",           limit: 1
    t.integer  "sequence"
    t.string   "fk_AuthorizedBy",      limit: 11
    t.string   "fk_AuthorizationNote", limit: 64
    t.integer  "fk_changeRequestID"
  end

  add_index "ministry_authorization", ["fk_AuthorizationNote"], name: "index3", using: :btree
  add_index "ministry_authorization", ["fk_AuthorizedBy"], name: "index1", using: :btree
  add_index "ministry_authorization", ["fk_changeRequestID"], name: "index2", using: :btree

  create_table "ministry_changerequest", primary_key: "ChangeRequestID", force: true do |t|
    t.datetime "requestdate"
    t.datetime "effectivedate"
    t.datetime "applieddate"
    t.string   "type",           limit: 30
    t.string   "fk_requestedBy", limit: 11
    t.string   "updateStaff",    limit: 11
    t.string   "region",         limit: 10
  end

  add_index "ministry_changerequest", ["fk_requestedBy"], name: "index1", using: :btree

  create_table "ministry_dependent", primary_key: "DependentID", force: true do |t|
    t.string   "firstName",  limit: 80
    t.string   "middleName", limit: 80
    t.string   "lastName",   limit: 80
    t.datetime "birthdate"
    t.string   "gender",     limit: 1
  end

  create_table "ministry_fieldchange", primary_key: "FieldChangeID", force: true do |t|
    t.string  "field",              limit: 30
    t.string  "oldValue"
    t.string  "newValue"
    t.integer "Fk_hasFieldChanges"
  end

  create_table "ministry_involvement", primary_key: "involvementID", force: true do |t|
    t.integer "fk_PersonID"
    t.integer "fk_StrategyID"
  end

  create_table "ministry_locallevel", primary_key: "teamID", force: true do |t|
    t.string   "name",                   limit: 100
    t.string   "lane",                   limit: 10
    t.string   "note"
    t.string   "region",                 limit: 2
    t.string   "address1",               limit: 35
    t.string   "address2",               limit: 35
    t.string   "city",                   limit: 30
    t.string   "state",                  limit: 6
    t.string   "zip",                    limit: 10
    t.string   "country",                limit: 64
    t.string   "phone",                  limit: 24
    t.string   "fax",                    limit: 24
    t.string   "email",                  limit: 50
    t.string   "url"
    t.string   "isActive",               limit: 1
    t.datetime "startdate"
    t.datetime "stopdate"
    t.string   "Fk_OrgRel",              limit: 64
    t.string   "no",                     limit: 2
    t.string   "abbrv",                  limit: 2
    t.string   "hasMultiRegionalAccess"
    t.string   "dept_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "global_registry_id"
  end

  add_index "ministry_locallevel", ["global_registry_id"], name: "index_ministry_locallevel_on_global_registry_id", using: :btree

  create_table "ministry_missional_team_member", force: true do |t|
    t.integer  "personID"
    t.integer  "teamID"
    t.boolean  "is_people_soft"
    t.boolean  "is_leader"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "global_registry_id"
  end

  add_index "ministry_missional_team_member", ["personID"], name: "personID", using: :btree
  add_index "ministry_missional_team_member", ["teamID"], name: "teamID", using: :btree

  create_table "ministry_movement_contact", id: false, force: true do |t|
    t.integer  "personID"
    t.integer  "ActivityID"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ministry_movement_contact", ["ActivityID"], name: "ActivityID", using: :btree
  add_index "ministry_movement_contact", ["personID", "ActivityID"], name: "both", using: :btree
  add_index "ministry_movement_contact", ["personID"], name: "personID", using: :btree

  create_table "ministry_newaddress", primary_key: "addressID", force: true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "address3",            limit: 55
    t.string   "address4",            limit: 55
    t.string   "city",                limit: 50
    t.string   "state",               limit: 50
    t.string   "zip",                 limit: 15
    t.string   "country",             limit: 64
    t.string   "homePhone",           limit: 26
    t.string   "workPhone",           limit: 250
    t.string   "cellPhone",           limit: 25
    t.string   "fax",                 limit: 25
    t.string   "skype"
    t.string   "email",               limit: 200
    t.string   "url",                 limit: 100
    t.string   "contactName"
    t.string   "contactRelationship", limit: 50
    t.string   "addressType",         limit: 20
    t.datetime "dateCreated"
    t.datetime "dateChanged"
    t.string   "createdBy",           limit: 50
    t.string   "changedBy",           limit: 50
    t.integer  "fk_PersonID"
    t.string   "email2",              limit: 200
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "facebook_link"
    t.string   "myspace_link"
    t.string   "title"
    t.string   "dorm"
    t.string   "room"
    t.string   "preferredPhone",      limit: 25
    t.string   "phone1_type",                     default: "cell"
    t.string   "phone2_type",                     default: "home"
    t.string   "phone3_type",                     default: "work"
    t.string   "global_registry_id",  limit: 40
  end

  add_index "ministry_newaddress", ["addressType", "fk_PersonID"], name: "unique_person_addressType", unique: true, using: :btree
  add_index "ministry_newaddress", ["addressType"], name: "index_ministry_newAddress_on_addressType", using: :btree
  add_index "ministry_newaddress", ["email"], name: "email", using: :btree
  add_index "ministry_newaddress", ["fk_PersonID"], name: "fk_PersonID", using: :btree

  create_table "ministry_noncccmin", primary_key: "NonCccMinID", force: true do |t|
    t.string "ministry",    limit: 50
    t.string "firstName",   limit: 30
    t.string "lastName",    limit: 30
    t.string "address1",    limit: 35
    t.string "address2",    limit: 35
    t.string "city",        limit: 30
    t.string "state",       limit: 6
    t.string "zip",         limit: 10
    t.string "country",     limit: 64
    t.string "homePhone",   limit: 24
    t.string "workPhone",   limit: 24
    t.string "mobilePhone", limit: 24
    t.string "email",       limit: 80
    t.string "url",         limit: 50
    t.string "pager",       limit: 24
    t.string "fax",         limit: 24
    t.string "note"
  end

  create_table "ministry_note", primary_key: "NoteID", force: true do |t|
    t.datetime "dateEntered"
    t.string   "title",                limit: 80
    t.text     "note"
    t.string   "Fk_loaNote",           limit: 64
    t.string   "Fk_resignationLetter", limit: 64
    t.string   "Fk_authorizationNote", limit: 64
  end

  create_table "ministry_person", primary_key: "personID", force: true do |t|
    t.string   "accountNo",                     limit: 11
    t.string   "lastName",                      limit: 50
    t.string   "firstName",                     limit: 50
    t.string   "middleName",                    limit: 50
    t.string   "preferredName",                 limit: 50
    t.string   "gender",                        limit: 1
    t.string   "region",                        limit: 5
    t.boolean  "workInUS",                                                                  default: true,  null: false
    t.boolean  "usCitizen",                                                                 default: true,  null: false
    t.string   "citizenship",                   limit: 50
    t.boolean  "isStaff"
    t.string   "title",                         limit: 5
    t.string   "campus",                        limit: 128
    t.string   "universityState",               limit: 5
    t.string   "yearInSchool",                  limit: 20
    t.string   "major",                         limit: 70
    t.string   "minor",                         limit: 70
    t.string   "greekAffiliation",              limit: 50
    t.string   "maritalStatus",                 limit: 20
    t.string   "numberChildren",                limit: 2
    t.boolean  "isChild",                                                                   default: false, null: false
    t.text     "bio",                           limit: 2147483647
    t.string   "image",                         limit: 100
    t.string   "occupation",                    limit: 50
    t.string   "blogfeed",                      limit: 200
    t.datetime "cruCommonsInvite"
    t.datetime "cruCommonsLastLogin"
    t.datetime "dateCreated"
    t.datetime "dateChanged"
    t.string   "createdBy",                     limit: 50
    t.string   "changedBy",                     limit: 50
    t.integer  "fk_ssmUserId"
    t.integer  "fk_StaffSiteProfileID"
    t.integer  "fk_spouseID"
    t.integer  "fk_childOf"
    t.date     "birth_date"
    t.date     "date_became_christian"
    t.date     "graduation_date"
    t.string   "level_of_school"
    t.string   "staff_notes"
    t.string   "donor_number",                  limit: 11
    t.string   "url",                           limit: 2000
    t.string   "isSecure",                      limit: 1
    t.integer  "primary_campus_involvement_id"
    t.integer  "mentor_id"
    t.string   "lastAttended",                  limit: 20
    t.string   "ministry"
    t.string   "strategy",                      limit: 20
    t.integer  "fb_uid",                        limit: 8
    t.datetime "date_attributes_updated"
    t.decimal  "balance_daily",                                    precision: 10, scale: 2
    t.string   "siebel_contact_id"
    t.string   "sp_gcx_site"
    t.string   "global_registry_id"
  end

  add_index "ministry_person", ["accountNo"], name: "accountNo_ministry_Person", using: :btree
  add_index "ministry_person", ["campus"], name: "campus", using: :btree
  add_index "ministry_person", ["fb_uid"], name: "index_ministry_person_on_fb_uid", using: :btree
  add_index "ministry_person", ["firstName", "lastName"], name: "firstName_lastName", using: :btree
  add_index "ministry_person", ["fk_spouseID"], name: "index_ministry_person_on_fk_spouseid", using: :btree
  add_index "ministry_person", ["fk_ssmUserId"], name: "fk_ssmUserId", using: :btree
  add_index "ministry_person", ["global_registry_id"], name: "index_ministry_person_on_global_registry_id", using: :btree
  add_index "ministry_person", ["lastName"], name: "lastname_ministry_Person", using: :btree
  add_index "ministry_person", ["region"], name: "region_ministry_Person", using: :btree
  add_index "ministry_person", ["siebel_contact_id"], name: "index_ministry_person_on_siebel_contact_id", using: :btree

  create_table "ministry_regionalstat", primary_key: "RegionalStatID", force: true do |t|
    t.datetime "periodBegin"
    t.datetime "periodEnd"
    t.integer  "nsSc"
    t.integer  "nsWsn"
    t.integer  "nsCat"
    t.integer  "nsIcrD"
    t.integer  "nsIcrI"
    t.integer  "nsIcrE"
    t.integer  "niSc"
    t.integer  "niWsn"
    t.integer  "niCat"
    t.integer  "niIcrD"
    t.integer  "niIcrI"
    t.integer  "niIcrE"
    t.string   "fk_regionalTeamID", limit: 64
  end

  add_index "ministry_regionalstat", ["fk_regionalTeamID"], name: "fk_regionalTeamID", using: :btree

  create_table "ministry_regionalteam", primary_key: "teamID", force: true do |t|
    t.string   "name",               limit: 100
    t.string   "note"
    t.string   "region",             limit: 2
    t.string   "address1",           limit: 35
    t.string   "address2",           limit: 35
    t.string   "city",               limit: 30
    t.string   "state",              limit: 6
    t.string   "zip",                limit: 10
    t.string   "country",            limit: 64
    t.string   "phone",              limit: 24
    t.string   "fax",                limit: 24
    t.string   "email",              limit: 50
    t.string   "url"
    t.string   "isActive",           limit: 1
    t.datetime "startdate"
    t.datetime "stopdate"
    t.string   "no",                 limit: 80
    t.string   "abbrv",              limit: 80
    t.string   "hrd",                limit: 50
    t.string   "spPhone",            limit: 24
    t.string   "global_registry_id"
  end

  create_table "ministry_staff", force: true do |t|
    t.string   "accountNo",                limit: 15,                                         null: false
    t.string   "firstName",                limit: 30
    t.string   "middleInitial",            limit: 1
    t.string   "lastName",                 limit: 30
    t.string   "isMale",                   limit: 1
    t.string   "position",                 limit: 30
    t.string   "countryStatus",            limit: 10
    t.string   "jobStatus",                limit: 60
    t.string   "ministry",                 limit: 35
    t.string   "strategy",                 limit: 20
    t.string   "isNewStaff",               limit: 1
    t.string   "primaryEmpLocState",       limit: 6
    t.string   "primaryEmpLocCountry",     limit: 64
    t.string   "primaryEmpLocCity",        limit: 35
    t.string   "primaryEmpLocDesc",        limit: 128
    t.string   "spouseFirstName",          limit: 22
    t.string   "spouseMiddleName",         limit: 15
    t.string   "spouseLastName",           limit: 30
    t.string   "spouseAccountNo",          limit: 11
    t.string   "spouseEmail",              limit: 50
    t.string   "fianceeFirstName",         limit: 15
    t.string   "fianceeMiddleName",        limit: 15
    t.string   "fianceeLastName",          limit: 30
    t.string   "fianceeAccountno",         limit: 11
    t.string   "isFianceeStaff",           limit: 1
    t.date     "fianceeJoinStaffDate"
    t.string   "isFianceeJoiningNS",       limit: 1
    t.string   "joiningNS",                limit: 1
    t.string   "homePhone",                limit: 24
    t.string   "workPhone",                limit: 24
    t.string   "mobilePhone",              limit: 24
    t.string   "pager",                    limit: 24
    t.string   "email",                    limit: 50
    t.string   "isEmailSecure",            limit: 1
    t.string   "url"
    t.date     "newStaffTrainingdate"
    t.string   "fax",                      limit: 24
    t.string   "note",                     limit: 2048
    t.string   "region",                   limit: 10
    t.string   "countryCode",              limit: 3
    t.string   "ssn",                      limit: 9
    t.string   "maritalStatus",            limit: 1
    t.string   "deptId",                   limit: 10
    t.string   "jobCode",                  limit: 6
    t.string   "accountCode",              limit: 25
    t.string   "compFreq",                 limit: 1
    t.decimal  "compRate",                              precision: 9, scale: 2
    t.string   "compChngAmt",              limit: 21
    t.string   "jobTitle",                 limit: 80
    t.string   "deptName",                 limit: 30
    t.string   "coupleTitle",              limit: 12
    t.string   "otherPhone",               limit: 24
    t.string   "preferredName",            limit: 50
    t.string   "namePrefix",               limit: 4
    t.date     "origHiredate"
    t.date     "birthDate"
    t.date     "marriageDate"
    t.date     "hireDate"
    t.date     "rehireDate"
    t.date     "loaStartDate"
    t.date     "loaEndDate"
    t.string   "loaReason",                limit: 80
    t.integer  "severancePayMonthsReq"
    t.date     "serviceDate"
    t.date     "lastIncDate"
    t.date     "jobEntryDate"
    t.date     "deptEntryDate"
    t.date     "reportingDate"
    t.string   "employmentType",           limit: 20
    t.string   "resignationReason",        limit: 80
    t.date     "resignationDate"
    t.string   "contributionsToOtherAcct", limit: 1
    t.string   "contributionsToAcntName",  limit: 80
    t.string   "contributionsToAcntNo",    limit: 11
    t.integer  "fk_primaryAddress"
    t.integer  "fk_secondaryAddress"
    t.integer  "fk_teamID"
    t.string   "isSecure",                 limit: 1
    t.string   "isSupported",              limit: 1
    t.string   "removedFromPeopleSoft",    limit: 1,                            default: "N"
    t.string   "isNonUSStaff",             limit: 1
    t.integer  "person_id"
    t.string   "middleName",               limit: 30
    t.string   "paygroup",                 limit: 3
    t.string   "idType",                   limit: 2
    t.string   "statusDescr",              limit: 30
    t.string   "internationalStatus",      limit: 3
    t.decimal  "balance",                               precision: 9, scale: 2
    t.string   "cccHrSendingDept",         limit: 10
    t.string   "cccHrCaringDept",          limit: 10
    t.string   "cccCaringMinistry",        limit: 10
    t.string   "assignmentLength",         limit: 4
    t.string   "relay_email",              limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ministry_staff", ["accountNo"], name: "accountNo", unique: true, using: :btree
  add_index "ministry_staff", ["firstName"], name: "index_ministry_staff_on_firstName", using: :btree
  add_index "ministry_staff", ["fk_primaryAddress"], name: "index2", using: :btree
  add_index "ministry_staff", ["fk_secondaryAddress"], name: "index3", using: :btree
  add_index "ministry_staff", ["fk_teamID"], name: "index1", using: :btree
  add_index "ministry_staff", ["lastName"], name: "index4", using: :btree
  add_index "ministry_staff", ["person_id"], name: "ministry_staff_person_id_index", using: :btree
  add_index "ministry_staff", ["region"], name: "index5", using: :btree

  create_table "ministry_staffchangerequest", primary_key: "ChangeRequestID", force: true do |t|
    t.string "updateStaff", limit: 64
  end

  create_table "ministry_statistic", primary_key: "StatisticID", force: true do |t|
    t.date     "periodBegin"
    t.date     "periodEnd"
    t.integer  "exposures"
    t.integer  "exposuresViaMedia"
    t.integer  "evangelisticOneOnOne"
    t.integer  "evangelisticGroup"
    t.integer  "decisions"
    t.integer  "attendedLastConf"
    t.integer  "invldNewBlvrs"
    t.integer  "invldStudents"
    t.integer  "invldFreshmen"
    t.integer  "invldSophomores"
    t.integer  "invldJuniors"
    t.integer  "invldSeniors"
    t.integer  "invldGrads"
    t.integer  "studentLeaders"
    t.integer  "volunteers"
    t.integer  "staff"
    t.integer  "nonStaffStint"
    t.integer  "staffStint"
    t.integer  "fk_Activity"
    t.integer  "multipliers"
    t.integer  "laborersSent"
    t.integer  "decisionsHelpedByMedia"
    t.integer  "decisionsHelpedByOneOnOne"
    t.integer  "decisionsHelpedByGroup"
    t.integer  "decisionsHelpedByOngoingReln"
    t.integer  "ongoingEvangReln"
    t.string   "updated_by"
    t.datetime "updated_at"
    t.string   "peopleGroup"
    t.integer  "holySpiritConversations"
    t.integer  "dollars_raised"
    t.integer  "sp_year"
    t.datetime "created_at"
    t.integer  "spiritual_conversations"
    t.integer  "faculty_sent"
    t.integer  "faculty_involved"
    t.integer  "faculty_engaged"
    t.integer  "faculty_leaders"
  end

  add_index "ministry_statistic", ["fk_Activity"], name: "index1", using: :btree
  add_index "ministry_statistic", ["periodBegin"], name: "index2", using: :btree
  add_index "ministry_statistic", ["periodEnd", "fk_Activity", "peopleGroup"], name: "activityWeekPeopleGroup", unique: true, using: :btree
  add_index "ministry_statistic", ["periodEnd"], name: "index3", using: :btree

  create_table "ministry_strategy", primary_key: "strategyID", force: true do |t|
    t.string  "name"
    t.string  "abreviation"
    t.integer "position",    default: 0, null: false
    t.boolean "event",                   null: false
    t.boolean "city",                    null: false
    t.boolean "crs",                     null: false
  end

  create_table "ministry_targetarea", primary_key: "targetAreaID", force: true do |t|
    t.string   "name",                   limit: 100
    t.string   "address1",               limit: 35
    t.string   "address2",               limit: 35
    t.string   "city",                   limit: 30
    t.string   "state",                  limit: 32
    t.string   "zip",                    limit: 10
    t.string   "country",                limit: 64
    t.string   "phone",                  limit: 24
    t.string   "fax",                    limit: 24
    t.string   "email",                  limit: 50
    t.string   "url"
    t.string   "abbrv",                  limit: 32
    t.string   "fice",                   limit: 32
    t.string   "mainCampusFice",         limit: 32
    t.string   "isNoFiceOK",             limit: 1
    t.text     "note"
    t.string   "altName",                limit: 100
    t.string   "isSecure",               limit: 1
    t.string   "isClosed",               limit: 1
    t.string   "region"
    t.string   "mpta",                   limit: 30
    t.string   "urlToLogo"
    t.integer  "enrollment"
    t.string   "monthSchoolStarts",      limit: 10
    t.string   "monthSchoolStops",       limit: 10
    t.string   "isSemester",             limit: 1
    t.string   "isApproved",             limit: 1
    t.string   "aoaPriority",            limit: 10
    t.string   "aoa",                    limit: 100
    t.string   "ciaUrl"
    t.string   "infoUrl"
    t.string   "calendar",               limit: 50
    t.string   "program1",               limit: 50
    t.string   "program2",               limit: 50
    t.string   "program3",               limit: 50
    t.string   "program4",               limit: 50
    t.string   "program5",               limit: 50
    t.string   "emphasis",               limit: 50
    t.string   "sex",                    limit: 50
    t.string   "institutionType",        limit: 50
    t.string   "highestOffering",        limit: 65
    t.string   "affiliation",            limit: 50
    t.string   "carnegieClassification", limit: 100
    t.string   "irsStatus",              limit: 50
    t.integer  "establishedDate"
    t.integer  "tuition"
    t.datetime "modified"
    t.string   "eventType",              limit: 2
    t.integer  "eventKeyID"
    t.string   "type",                   limit: 20
    t.string   "county"
    t.boolean  "ongoing_special_event",                                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "latitude",                           precision: 11, scale: 7
    t.decimal  "longitude",                          precision: 11, scale: 7
    t.string   "global_registry_id"
    t.string   "gate"
  end

  add_index "ministry_targetarea", ["country"], name: "index4", using: :btree
  add_index "ministry_targetarea", ["isApproved"], name: "index2", using: :btree
  add_index "ministry_targetarea", ["isClosed"], name: "index7", using: :btree
  add_index "ministry_targetarea", ["isSecure"], name: "index5", using: :btree
  add_index "ministry_targetarea", ["name"], name: "index1", using: :btree
  add_index "ministry_targetarea", ["region"], name: "index6", using: :btree
  add_index "ministry_targetarea", ["state"], name: "index3", using: :btree

  create_table "pr_answer_sheet_question_sheets", force: true do |t|
    t.integer  "answer_sheet_id"
    t.integer  "question_sheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pr_answer_sheets", force: true do |t|
    t.integer  "question_sheet_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "completed_at"
  end

  create_table "pr_answers", force: true do |t|
    t.integer  "answer_sheet_id",         null: false
    t.integer  "question_id",             null: false
    t.text     "value"
    t.string   "short_value"
    t.integer  "attachment_file_size"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.datetime "attachment_updated_at"
  end

  add_index "pr_answers", ["answer_sheet_id"], name: "index_pr_answers_on_answer_sheet_id", using: :btree
  add_index "pr_answers", ["question_id"], name: "index_pr_answers_on_question_id", using: :btree
  add_index "pr_answers", ["short_value"], name: "index_pr_answers_on_short_value", using: :btree

  create_table "pr_conditions", force: true do |t|
    t.integer "question_sheet_id", null: false
    t.integer "trigger_id",        null: false
    t.string  "expression",        null: false
    t.integer "toggle_page_id",    null: false
    t.integer "toggle_id"
  end

  create_table "pr_elements", force: true do |t|
    t.string   "kind",                      limit: 40,                   null: false
    t.string   "style",                     limit: 40
    t.string   "label",                     limit: 1000
    t.text     "content"
    t.boolean  "required"
    t.string   "slug",                      limit: 36
    t.integer  "position"
    t.string   "object_name"
    t.string   "attribute_name"
    t.string   "source"
    t.string   "value_xpath"
    t.string   "text_xpath"
    t.integer  "question_grid_id"
    t.string   "cols"
    t.boolean  "is_confidential"
    t.string   "total_cols"
    t.string   "css_id"
    t.string   "css_class"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "related_question_sheet_id"
    t.integer  "conditional_id"
    t.text     "tooltip"
    t.boolean  "hide_label",                             default: false
    t.boolean  "hide_option_labels",                     default: false
    t.integer  "max_length"
  end

  add_index "pr_elements", ["position"], name: "index_pr_elements_on_question_sheet_id_and_position_and_page_id", using: :btree
  add_index "pr_elements", ["slug"], name: "index_pr_elements_on_slug", using: :btree

  create_table "pr_email_templates", force: true do |t|
    t.string   "name",       limit: 1000, null: false
    t.text     "content"
    t.boolean  "enabled"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pr_email_templates", ["name"], name: "index_pr_email_templates_on_name", length: {"name"=>255}, using: :btree

  create_table "pr_page_elements", force: true do |t|
    t.integer  "page_id"
    t.integer  "element_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pr_pages", force: true do |t|
    t.integer "question_sheet_id",                             null: false
    t.string  "label",             limit: 100,                 null: false
    t.integer "number"
    t.boolean "no_cache",                      default: false
    t.boolean "hidden",                        default: false
  end

  create_table "pr_personal_forms", force: true do |t|
    t.integer  "person_id"
    t.integer  "question_sheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pr_question_sheet_pr_infos", force: true do |t|
    t.integer  "question_sheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "form_type",         default: "review"
    t.integer  "summary_form_id"
  end

  create_table "pr_question_sheets", force: true do |t|
    t.string  "label",        limit: 60,                 null: false
    t.boolean "archived",                default: false
    t.boolean "fake_deleted",            default: false
  end

  create_table "pr_references", force: true do |t|
    t.integer  "question_id"
    t.integer  "applicant_answer_sheet_id"
    t.datetime "email_sent_at"
    t.string   "relationship"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email"
    t.string   "status"
    t.datetime "submitted_at"
    t.string   "access_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pr_reminders", force: true do |t|
    t.integer  "person_id"
    t.string   "label"
    t.text     "note"
    t.date     "reminder_date"
    t.boolean  "send_email",      default: false
    t.integer  "email_days_diff", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "email_sent_at"
  end

  create_table "pr_reviewers", force: true do |t|
    t.integer  "review_id"
    t.integer  "person_id"
    t.datetime "invitation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_key"
    t.datetime "submitted_at"
  end

  create_table "pr_reviews", force: true do |t|
    t.integer  "subject_id"
    t.integer  "initiator_id"
    t.string   "status"
    t.integer  "percent"
    t.date     "due"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "purpose"
    t.integer  "question_sheet_id"
    t.datetime "completed_at"
    t.integer  "show_summary_form_days", default: 14
    t.boolean  "fake_deleted",           default: false
    t.boolean  "force_display",          default: false
  end

  add_index "pr_reviews", ["initiator_id"], name: "initiator_id", using: :btree
  add_index "pr_reviews", ["subject_id"], name: "subject_id", using: :btree

  create_table "pr_sessions", force: true do |t|
    t.text "session_id"
    t.text "data"
  end

  create_table "pr_summary_forms", force: true do |t|
    t.integer  "person_id"
    t.integer  "review_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pr_users", force: true do |t|
    t.integer  "ssm_id"
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simplesecuritymanager_user", primary_key: "userID", force: true do |t|
    t.string   "globallyUniqueID",          limit: 80
    t.string   "username",                  limit: 200,                 null: false
    t.string   "password",                  limit: 80
    t.string   "passwordQuestion",          limit: 200
    t.string   "passwordAnswer",            limit: 200
    t.datetime "lastFailure"
    t.integer  "lastFailureCnt"
    t.datetime "lastLogin"
    t.datetime "createdOn"
    t.boolean  "emailVerified",                         default: false, null: false
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "developer"
    t.string   "facebook_hash"
    t.string   "facebook_username"
    t.integer  "fb_user_id",                limit: 8
    t.string   "password_reset_key"
    t.string   "email"
    t.string   "encrypted_password"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         default: 0
    t.datetime "current_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_sign_in_at"
    t.string   "locale"
    t.integer  "checked_guid",              limit: 1,   default: 0,     null: false
    t.text     "settings"
    t.string   "needs_merge"
    t.string   "password_plain"
    t.integer  "global_registry_id",        limit: 8
  end

  add_index "simplesecuritymanager_user", ["email"], name: "index_simplesecuritymanager_user_on_email", unique: true, using: :btree
  add_index "simplesecuritymanager_user", ["fb_user_id"], name: "index_simplesecuritymanager_user_on_fb_user_id", using: :btree
  add_index "simplesecuritymanager_user", ["global_registry_id"], name: "index_simplesecuritymanager_user_on_global_registry_id", using: :btree
  add_index "simplesecuritymanager_user", ["globallyUniqueID"], name: "globallyUniqueID", unique: true, using: :btree
  add_index "simplesecuritymanager_user", ["username"], name: "CK_simplesecuritymanager_user_username", unique: true, using: :btree

  create_table "staffsite_staffsiteprofile", primary_key: "StaffSiteProfileID", force: true do |t|
    t.string  "firstName",        limit: 64
    t.string  "lastName",         limit: 64
    t.string  "userName",         limit: 64
    t.boolean "changePassword"
    t.boolean "captureHRinfo"
    t.string  "accountNo",        limit: 64
    t.boolean "isStaff"
    t.string  "email",            limit: 64
    t.string  "passwordQuestion", limit: 64
    t.string  "passwordAnswer",   limit: 64
  end

  add_index "staffsite_staffsiteprofile", ["userName"], name: "index1", using: :btree

end
