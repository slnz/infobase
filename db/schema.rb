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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111008164745) do

  create_table "academic_departments", :force => true do |t|
    t.string "name"
  end

# Could not dump table "access_grants" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000067c8f48>

# Could not dump table "access_tokens" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000067b2180>

# Could not dump table "activities" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000067a13d0>

# Could not dump table "aoas" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000006798848>

  create_table "api_logs", :force => true do |t|
    t.string   "platform"
    t.string   "action"
    t.integer  "identity"
    t.integer  "organization_id"
    t.text     "error"
    t.text     "url"
    t.string   "access_token"
    t.string   "remote_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "platform_release"
    t.string   "platform_product"
    t.string   "app"
  end

# Could not dump table "auth_requests" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000067696d8>

# Could not dump table "authentications" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000067598c8>

# Could not dump table "clients" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000673e500>

  create_table "cms_assoc_filecategory", :id => false, :force => true do |t|
    t.string  "CmsFileID",     :limit => 64,                   :null => false
    t.string  "CmsCategoryID", :limit => 64,                   :null => false
    t.boolean "dbioDummy",                   :default => true
  end

# Could not dump table "cms_cmscategory" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000006724f10>

# Could not dump table "cms_cmsfile" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000066fe900>

  create_table "cms_viewcategoryidfiles", :id => false, :force => true do |t|
    t.integer  "CmsFileID",                     :default => 0, :null => false
    t.string   "mime",          :limit => 128
    t.string   "title",         :limit => 256
    t.integer  "accessCount"
    t.datetime "dateAdded"
    t.datetime "dateModified"
    t.string   "moderatedYet",  :limit => 1
    t.text     "summary"
    t.string   "quality",       :limit => 256
    t.datetime "expDate"
    t.datetime "lastAccessed"
    t.string   "modMsg",        :limit => 4000
    t.string   "keywords",      :limit => 4000
    t.string   "url",           :limit => 128
    t.string   "detail",        :limit => 4000
    t.string   "language",      :limit => 128
    t.string   "version",       :limit => 128
    t.string   "author",        :limit => 256
    t.string   "submitter",     :limit => 256
    t.string   "contact",       :limit => 256
    t.integer  "rating"
    t.string   "CmsCategoryID", :limit => 64,                  :null => false
  end

  create_table "cms_viewfileidcategories", :id => false, :force => true do |t|
    t.integer "CmsCategoryID",                  :default => 0, :null => false
    t.integer "parentCategory"
    t.string  "catName",        :limit => 256
    t.string  "catDesc",        :limit => 2000
    t.string  "path",           :limit => 2000
    t.string  "pathid",         :limit => 2000
    t.string  "CmsFileID",      :limit => 64,                  :null => false
  end

  create_table "cms_viewfilesandcategories", :id => false, :force => true do |t|
    t.integer  "CmsFileID",                      :default => 0, :null => false
    t.string   "mime",           :limit => 128
    t.string   "title",          :limit => 256
    t.integer  "accessCount"
    t.datetime "dateAdded"
    t.datetime "dateModified"
    t.string   "moderatedYet",   :limit => 1
    t.text     "summary"
    t.string   "quality",        :limit => 256
    t.datetime "expDate"
    t.datetime "lastAccessed"
    t.string   "modMsg",         :limit => 4000
    t.string   "keywords",       :limit => 4000
    t.string   "url",            :limit => 128
    t.string   "detail",         :limit => 4000
    t.string   "language",       :limit => 128
    t.string   "version",        :limit => 128
    t.string   "author",         :limit => 256
    t.string   "submitter",      :limit => 256
    t.string   "contact",        :limit => 256
    t.integer  "rating"
    t.integer  "CmsCategoryID",                  :default => 0, :null => false
    t.integer  "parentCategory"
    t.string   "catName",        :limit => 256
    t.string   "catDesc",        :limit => 2000
    t.string   "path",           :limit => 2000
    t.string   "pathid",         :limit => 2000
  end

# Could not dump table "contact_assignments" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000006687ff8>

# Could not dump table "counties" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000667a948>

  create_table "countries", :force => true do |t|
    t.string  "country",  :limit => 100
    t.string  "code",     :limit => 10
    t.boolean "closed",                  :default => false
    t.string  "iso_code"
  end

# Could not dump table "crs2_additional_expenses_item" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000006655030>

# Could not dump table "crs2_additional_info_item" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000066430b0>

# Could not dump table "crs2_answer" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000662bb40>

# Could not dump table "crs2_conference" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000065e4e98>

# Could not dump table "crs2_configuration" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000065d56a0>

# Could not dump table "crs2_custom_questions_item" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000065d6190>

# Could not dump table "crs2_custom_stylesheet" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000006e9c4f0>

# Could not dump table "crs2_expense" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000070ce0e8>

# Could not dump table "crs2_expense_selection" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000723a260>

# Could not dump table "crs2_module_usage" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000073c9518>

  create_table "crs2_person", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",            :null => false
    t.datetime "birth_date"
    t.string   "campus"
    t.string   "current_address1"
    t.string   "current_address2"
    t.string   "current_city"
    t.string   "current_country"
    t.string   "current_phone"
    t.string   "current_state"
    t.string   "current_zip"
    t.string   "email"
    t.string   "first_name"
    t.string   "gender"
    t.datetime "graduation_date"
    t.string   "greek_affiliation"
    t.string   "last_name"
    t.string   "major"
    t.string   "marital_status"
    t.string   "middle_name"
    t.string   "permanent_address1"
    t.string   "permanent_address2"
    t.string   "permanent_city"
    t.string   "permanent_country"
    t.string   "permanent_phone"
    t.string   "permanent_state"
    t.string   "permanent_zip"
    t.string   "university_state"
    t.string   "year_in_school"
  end

# Could not dump table "crs2_profile" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007bb98e0>

# Could not dump table "crs2_profile_question" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007d604a0>

# Could not dump table "crs2_question" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007d462a8>

# Could not dump table "crs2_question_option" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007d2d9b0>

# Could not dump table "crs2_registrant" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007ce0548>

# Could not dump table "crs2_registrant_type" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007c31250>

# Could not dump table "crs2_registration" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007c05178>

# Could not dump table "crs2_transaction" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007bc7648>

  create_table "crs2_url_base", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",                                 :null => false
    t.string   "authority",               :default => "", :null => false
    t.string   "scheme",     :limit => 5, :default => "", :null => false
  end

  create_table "crs2_user", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",    :null => false
    t.datetime "last_login"
  end

# Could not dump table "crs2_user_role" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007b97fb0>

# Could not dump table "crs_answer" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007b8c980>

# Could not dump table "crs_childregistration" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007b78480>

  create_table "crs_conference", :primary_key => "conferenceID", :force => true do |t|
    t.datetime "createDate"
    t.string   "attributesAsked",          :limit => 30
    t.string   "name",                     :limit => 64
    t.string   "theme",                    :limit => 128
    t.string   "password",                 :limit => 20
    t.string   "staffPassword",            :limit => 20
    t.string   "region",                   :limit => 3
    t.string   "briefDescription",         :limit => 8000
    t.string   "contactName",              :limit => 60
    t.string   "contactEmail",             :limit => 50
    t.string   "contactPhone",             :limit => 24
    t.string   "contactAddress1",          :limit => 35
    t.string   "contactAddress2",          :limit => 35
    t.string   "contactCity",              :limit => 30
    t.string   "contactState",             :limit => 6
    t.string   "contactZip",               :limit => 10
    t.string   "splashPageURL",            :limit => 128
    t.string   "confImageId",              :limit => 64
    t.string   "fontFace",                 :limit => 64
    t.string   "backgroundColor",          :limit => 6
    t.string   "foregroundColor",          :limit => 6
    t.string   "highlightColor",           :limit => 6
    t.string   "confirmationEmail",        :limit => 4000
    t.string   "acceptCreditCards",        :limit => 1
    t.string   "acceptEChecks",            :limit => 1
    t.string   "acceptScholarships",       :limit => 1
    t.string   "authnetPassword",          :limit => 200
    t.datetime "preRegStart"
    t.datetime "preRegEnd"
    t.datetime "defaultDateStaffArrive"
    t.datetime "defaultDateStaffLeave"
    t.datetime "defaultDateGuestArrive"
    t.datetime "defaultDateGuestLeave"
    t.datetime "defaultDateStudentArrive"
    t.datetime "defaultDateStudentLeave"
    t.datetime "masterDefaultDateArrive"
    t.datetime "masterDefaultDateLeave"
    t.string   "ministryType",             :limit => 2
    t.string   "isCloaked",                :limit => 1
    t.float    "onsiteCost"
    t.float    "commuterCost"
    t.float    "preRegDeposit"
    t.float    "discountFullPayment"
    t.float    "discountEarlyReg"
    t.datetime "discountEarlyRegDate"
    t.string   "checkPayableTo",           :limit => 40
    t.string   "merchantAcctNum",          :limit => 64
    t.string   "backgroundColor3",         :limit => 6
    t.string   "backgroundColor2",         :limit => 6
    t.string   "highlightColor2",          :limit => 6
    t.string   "requiredColor",            :limit => 6
    t.string   "acceptVisa",               :limit => 1
    t.string   "acceptMasterCard",         :limit => 1
    t.string   "acceptAmericanExpress",    :limit => 1
    t.string   "acceptDiscover",           :limit => 1
    t.integer  "staffProfileNumber"
    t.integer  "staffProfileReqNumber"
    t.integer  "guestProfileNumber"
    t.integer  "guestProfileReqNumber"
    t.integer  "studentProfileNumber"
    t.integer  "studentProfileReqNumber"
    t.string   "askStudentChildren",       :limit => 1
    t.string   "askStaffChildren",         :limit => 1
    t.string   "askGuestChildren",         :limit => 1
    t.string   "studentLabel",             :limit => 64
    t.string   "staffLabel",               :limit => 64
    t.string   "guestLabel",               :limit => 64
    t.string   "studentDesc"
    t.string   "staffDesc"
    t.string   "guestDesc"
    t.string   "askStudentSpouse",         :limit => 1
    t.string   "askStaffSpouse",           :limit => 1
    t.string   "askGuestSpouse",           :limit => 1
  end

# Could not dump table "crs_customitem" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007a02c90>

# Could not dump table "crs_merchandise" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000079f08b0>

  create_table "crs_merchandisechoice", :id => false, :force => true do |t|
    t.integer "fk_MerchandiseID",  :null => false
    t.integer "fk_RegistrationID", :null => false
  end

# Could not dump table "crs_payment" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000079ccb18>

# Could not dump table "crs_question" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000079be310>

  create_table "crs_questiontext", :primary_key => "questionTextID", :force => true do |t|
    t.string  "body",       :limit => 7000
    t.string  "answerType", :limit => 50
    t.string  "status",     :limit => 50
    t.integer "oldID"
  end

# Could not dump table "crs_registration" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007998250>

# Could not dump table "crs_registrationtype" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000079679c0>

  create_table "crs_report", :primary_key => "reportID", :force => true do |t|
    t.string  "query",       :limit => 1000
    t.string  "xsl"
    t.string  "name"
    t.integer "reportGroup"
    t.string  "sorts",       :limit => 1000
    t.string  "sortNames",   :limit => 1000
  end

# Could not dump table "email_addresses" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000794f3c0>

  create_table "engine_schema_info", :id => false, :force => true do |t|
    t.string  "engine_name"
    t.integer "version"
  end

# Could not dump table "followup_comments" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000793c518>

# Could not dump table "hr_ms_payment" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007921498>

# Could not dump table "hr_review360_review360" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000078dc118>

# Could not dump table "hr_review360_review360light" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000078be2a8>

  create_table "hr_review360_reviewsession", :primary_key => "ReviewSessionID", :force => true do |t|
    t.string   "name",            :limit => 80
    t.string   "purpose"
    t.datetime "dateDue"
    t.datetime "dateStarted"
    t.string   "revieweeID",      :limit => 128
    t.string   "administratorID", :limit => 128
    t.string   "requestedByID",   :limit => 128
  end

  create_table "hr_review360_reviewsessionlight", :primary_key => "ReviewSessionLightID", :force => true do |t|
    t.string   "name",            :limit => 80
    t.string   "purpose"
    t.datetime "dateDue"
    t.datetime "dateStarted"
    t.string   "revieweeID",      :limit => 128
    t.string   "administratorID", :limit => 128
    t.string   "requestedByID",   :limit => 128
  end

# Could not dump table "hr_si_applications" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000077d3668>

# Could not dump table "hr_si_payment" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000077bbbd0>

  create_table "hr_si_project", :primary_key => "SIProjectID", :force => true do |t|
    t.string   "name"
    t.string   "partnershipRegion",             :limit => 50
    t.string   "history",                       :limit => 8000
    t.string   "city"
    t.string   "country"
    t.string   "details",                       :limit => 8000
    t.string   "status"
    t.string   "destinationGatewayCity"
    t.datetime "departDateFromGateCity"
    t.datetime "arrivalDateAtLocation"
    t.string   "locationGatewayCity"
    t.datetime "departDateFromLocation"
    t.datetime "arrivalDateAtGatewayCity"
    t.integer  "flightBudget"
    t.string   "gatewayCitytoLocationFlightNo"
    t.string   "locationToGatewayCityFlightNo"
    t.string   "inCountryContact"
    t.string   "scholarshipAccountNo"
    t.string   "operatingAccountNo"
    t.string   "AOA"
    t.string   "MPTA"
    t.integer  "staffCost"
    t.integer  "studentCost"
    t.text     "studentCostExplaination"
    t.boolean  "insuranceFormsReceived"
    t.boolean  "CAPSFeePaid"
    t.boolean  "adminFeePaid"
    t.string   "storiesXX"
    t.string   "stats"
    t.boolean  "secure"
    t.boolean  "projEvalCompleted"
    t.integer  "evangelisticExposures"
    t.integer  "receivedChrist"
    t.integer  "jesusFilmExposures"
    t.integer  "jesusFilmReveivedChrist"
    t.integer  "coverageActivitiesExposures"
    t.integer  "coverageActivitiesDecisions"
    t.integer  "holySpiritDecisions"
    t.string   "website"
    t.string   "destinationAddress"
    t.string   "destinationPhone"
    t.string   "siYear"
    t.integer  "fk_isCoord"
    t.integer  "fk_isAPD"
    t.integer  "fk_isPD"
    t.string   "projectType",                   :limit => 1
    t.datetime "studentStartDate"
    t.datetime "studentEndDate"
    t.datetime "staffStartDate"
    t.datetime "staffEndDate"
    t.datetime "leadershipStartDate"
    t.datetime "leadershipEndDate"
    t.datetime "createDate"
    t.binary   "lastChangedDate",               :limit => 8
    t.integer  "lastChangedBy"
    t.string   "displayLocation"
    t.boolean  "partnershipRegionOnly"
    t.integer  "internCost"
    t.boolean  "onHold"
    t.integer  "maxNoStaffPMale"
    t.integer  "maxNoStaffPFemale"
    t.integer  "maxNoStaffPCouples"
    t.integer  "maxNoStaffPFamilies"
    t.integer  "maxNoStaffP"
    t.integer  "maxNoInternAMale"
    t.integer  "maxNoInternAFemale"
    t.integer  "maxNoInternACouples"
    t.integer  "maxNoInternAFamilies"
    t.integer  "maxNoInternA"
    t.integer  "maxNoInternPMale"
    t.integer  "maxNoInternPFemale"
    t.integer  "maxNoInternPCouples"
    t.integer  "maxNoInternPFamilies"
    t.integer  "maxNoInternP"
    t.integer  "maxNoStudentAMale"
    t.integer  "maxNoStudentAFemale"
    t.integer  "maxNoStudentACouples"
    t.integer  "maxNoStudentAFamilies"
    t.integer  "maxNoStudentA"
    t.integer  "maxNoStudentPMale"
    t.integer  "maxNoStudentPFemale"
    t.integer  "maxNoStudentPCouples"
    t.integer  "maxNoStudentPFamilies"
    t.integer  "maxNoStudentP"
  end

# Could not dump table "hr_si_reference" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000076cb9f0>

# Could not dump table "hr_si_users" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000076c0f28>

# Could not dump table "infobase_bookmarks" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000076b9250>

  create_table "infobase_users", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",       :default => "InfobaseAdminUser"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lat_long_by_zip_code", :force => true do |t|
    t.string  "zip"
    t.decimal "lat",  :precision => 15, :scale => 10
    t.decimal "long", :precision => 15, :scale => 10
  end

  create_table "linczone_contacts", :primary_key => "ContactID", :force => true do |t|
    t.timestamp "EntryDate"
    t.string    "FirstName",            :limit => 120
    t.string    "LastName",             :limit => 120
    t.string    "HomeAddress",          :limit => 200
    t.string    "City",                 :limit => 20
    t.string    "State",                :limit => 20
    t.string    "Zip",                  :limit => 80
    t.string    "Email",                :limit => 120
    t.string    "HighSchool",           :limit => 120
    t.string    "CampusName",           :limit => 200
    t.string    "CampusID",             :limit => 80
    t.string    "ReferrerFirstName",    :limit => 120
    t.string    "ReferrerLastName",     :limit => 120
    t.string    "ReferrerRelationship", :limit => 100
    t.string    "ReferrerEmail",        :limit => 200
    t.string    "InfoCCC",              :limit => 1,   :default => "F"
    t.string    "InfoNav",              :limit => 1,   :default => "F"
    t.string    "InfoIV",               :limit => 1,   :default => "F"
    t.string    "InfoFCA",              :limit => 1,   :default => "F"
    t.string    "InfoBSU",              :limit => 1,   :default => "F"
    t.string    "InfoCACM",             :limit => 1,   :default => "F"
    t.string    "InfoEFCA",             :limit => 1,   :default => "F"
    t.string    "InfoGCM",              :limit => 1,   :default => "F"
    t.string    "InfoWesley",           :limit => 1,   :default => "F"
  end

  create_table "mail_delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "mail_groups" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000076647f0>

# Could not dump table "mail_members" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000076590f8>

  create_table "mail_owners", :force => true do |t|
    t.integer  "group_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "exception",  :default => false
  end

# Could not dump table "mail_users" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000076410e8>

# Could not dump table "merge_audits" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000076379f8>

  create_table "mh_answer_sheets", :force => true do |t|
    t.integer  "question_sheet_id", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "completed_at"
    t.integer  "person_id"
  end

# Could not dump table "mh_answers" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000761fda8>

  create_table "mh_conditions", :force => true do |t|
    t.integer "question_sheet_id", :null => false
    t.integer "trigger_id",        :null => false
    t.string  "expression",        :null => false
    t.integer "toggle_page_id",    :null => false
    t.integer "toggle_id"
  end

  create_table "mh_education_histories", :force => true do |t|
    t.integer  "person_id"
    t.string   "type"
    t.string   "concentration_id1"
    t.string   "concentration_name1"
    t.string   "concentration_id2"
    t.string   "concentration_name2"
    t.string   "concentration_id3"
    t.string   "concentration_name3"
    t.string   "year_id"
    t.string   "year_name"
    t.string   "degree_id"
    t.string   "degree_name"
    t.string   "school_id"
    t.string   "school_name"
    t.string   "provider"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "school_type"
  end

# Could not dump table "mh_elements" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000075d8b60>

# Could not dump table "mh_email_templates" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000075cbf28>

# Could not dump table "mh_friends" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000075c0560>

  create_table "mh_interests", :force => true do |t|
    t.string   "name"
    t.string   "interest_id"
    t.string   "provider"
    t.string   "category"
    t.integer  "person_id"
    t.datetime "interest_created_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mh_locations", :force => true do |t|
    t.string   "location_id"
    t.string   "name"
    t.string   "provider"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mh_page_elements", :force => true do |t|
    t.integer  "page_id"
    t.integer  "element_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hidden",     :default => false
    t.boolean  "archived",   :default => false
  end

  create_table "mh_pages", :force => true do |t|
    t.integer "question_sheet_id",                                   :null => false
    t.string  "label",             :limit => 100,                    :null => false
    t.integer "number"
    t.boolean "no_cache",                         :default => false
    t.boolean "hidden",                           :default => false
  end

# Could not dump table "mh_question_sheets" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000758bfe0>

  create_table "mh_references", :force => true do |t|
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

  create_table "ministries", :force => true do |t|
    t.string "name"
  end

# Could not dump table "ministry_activity" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007562b68>

# Could not dump table "ministry_activity_history" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007555dc8>

  create_table "ministry_address", :primary_key => "AddressID", :force => true do |t|
    t.datetime "startdate"
    t.datetime "enddate"
    t.string   "address1",  :limit => 60
    t.string   "address2",  :limit => 60
    t.string   "address3",  :limit => 60
    t.string   "address4",  :limit => 60
    t.string   "city",      :limit => 35
    t.string   "state",     :limit => 6
    t.string   "zip",       :limit => 10
    t.string   "country",   :limit => 64
  end

  create_table "ministry_assoc_dependents", :id => false, :force => true do |t|
    t.integer "DependentID",                                 :null => false
    t.string  "accountNo",   :limit => 11,                   :null => false
    t.boolean "dbioDummy",                 :default => true, :null => false
  end

  create_table "ministry_assoc_otherministries", :id => false, :force => true do |t|
    t.string  "NonCccMinID",  :limit => 64,                   :null => false
    t.string  "TargetAreaID", :limit => 64,                   :null => false
    t.boolean "dbioDummy",                  :default => true, :null => false
  end

# Could not dump table "ministry_authorization" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007529f20>

# Could not dump table "ministry_changerequest" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000751a9a8>

  create_table "ministry_dependent", :primary_key => "DependentID", :force => true do |t|
    t.string   "firstName",  :limit => 80
    t.string   "middleName", :limit => 80
    t.string   "lastName",   :limit => 80
    t.datetime "birthdate"
    t.string   "gender",     :limit => 1
  end

  create_table "ministry_fieldchange", :primary_key => "FieldChangeID", :force => true do |t|
    t.string  "field",              :limit => 30
    t.string  "oldValue"
    t.string  "newValue"
    t.integer "Fk_hasFieldChanges"
  end

  create_table "ministry_involvement", :primary_key => "involvementID", :force => true do |t|
    t.integer "fk_PersonID"
    t.integer "fk_StrategyID"
  end

  create_table "ministry_locallevel", :primary_key => "teamID", :force => true do |t|
    t.string   "name",                   :limit => 100
    t.string   "lane",                   :limit => 10
    t.string   "note"
    t.string   "region",                 :limit => 2
    t.string   "address1",               :limit => 35
    t.string   "address2",               :limit => 35
    t.string   "city",                   :limit => 30
    t.string   "state",                  :limit => 6
    t.string   "zip",                    :limit => 10
    t.string   "country",                :limit => 64
    t.string   "phone",                  :limit => 24
    t.string   "fax",                    :limit => 24
    t.string   "email",                  :limit => 50
    t.string   "url"
    t.string   "isActive",               :limit => 1
    t.datetime "startdate"
    t.datetime "stopdate"
    t.string   "Fk_OrgRel",              :limit => 64
    t.string   "no",                     :limit => 2
    t.string   "abbrv",                  :limit => 2
    t.string   "hasMultiRegionalAccess"
    t.string   "dept_id"
  end

# Could not dump table "ministry_missional_team_member" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000074dd1c0>

# Could not dump table "ministry_movement_contact" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000074d6758>

# Could not dump table "ministry_newaddress" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000074aa158>

  create_table "ministry_noncccmin", :primary_key => "NonCccMinID", :force => true do |t|
    t.string "ministry",    :limit => 50
    t.string "firstName",   :limit => 30
    t.string "lastName",    :limit => 30
    t.string "address1",    :limit => 35
    t.string "address2",    :limit => 35
    t.string "city",        :limit => 30
    t.string "state",       :limit => 6
    t.string "zip",         :limit => 10
    t.string "country",     :limit => 64
    t.string "homePhone",   :limit => 24
    t.string "workPhone",   :limit => 24
    t.string "mobilePhone", :limit => 24
    t.string "email",       :limit => 80
    t.string "url",         :limit => 50
    t.string "pager",       :limit => 24
    t.string "fax",         :limit => 24
    t.string "note"
  end

  create_table "ministry_note", :primary_key => "NoteID", :force => true do |t|
    t.datetime "dateEntered"
    t.string   "title",                :limit => 80
    t.text     "note"
    t.string   "Fk_loaNote",           :limit => 64
    t.string   "Fk_resignationLetter", :limit => 64
    t.string   "Fk_authorizationNote", :limit => 64
  end

# Could not dump table "ministry_person" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007447968>

# Could not dump table "ministry_regionalstat" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000074302e0>

  create_table "ministry_regionalteam", :primary_key => "teamID", :force => true do |t|
    t.string   "name",      :limit => 100
    t.string   "note"
    t.string   "region",    :limit => 2
    t.string   "address1",  :limit => 35
    t.string   "address2",  :limit => 35
    t.string   "city",      :limit => 30
    t.string   "state",     :limit => 6
    t.string   "zip",       :limit => 10
    t.string   "country",   :limit => 64
    t.string   "phone",     :limit => 24
    t.string   "fax",       :limit => 24
    t.string   "email",     :limit => 50
    t.string   "url"
    t.string   "isActive",  :limit => 1
    t.datetime "startdate"
    t.datetime "stopdate"
    t.string   "no",        :limit => 80
    t.string   "abbrv",     :limit => 80
    t.string   "hrd",       :limit => 50
    t.string   "spPhone",   :limit => 24
  end

# Could not dump table "ministry_staff" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000739d580>

  create_table "ministry_staffchangerequest", :primary_key => "ChangeRequestID", :force => true do |t|
    t.string "updateStaff", :limit => 64
  end

# Could not dump table "ministry_statistic" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007371890>

  create_table "ministry_strategy", :primary_key => "strategyID", :force => true do |t|
    t.string "name"
    t.string "abreviation"
  end

# Could not dump table "ministry_targetarea" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000732cda8>

  create_table "ministry_viewdependentsstaff", :id => false, :force => true do |t|
    t.string  "accountNo",                :limit => 11,                    :null => false
    t.string  "firstName",                :limit => 30
    t.string  "middleInitial",            :limit => 1
    t.string  "lastName",                 :limit => 30
    t.string  "isMale",                   :limit => 1
    t.string  "position",                 :limit => 30
    t.string  "countryStatus",            :limit => 10
    t.string  "jobStatus",                :limit => 60
    t.string  "ministry",                 :limit => 35
    t.string  "strategy",                 :limit => 20
    t.string  "isNewStaff",               :limit => 1
    t.string  "primaryEmpLocState",       :limit => 6
    t.string  "primaryEmpLocCountry",     :limit => 64
    t.string  "primaryEmpLocCity",        :limit => 35
    t.string  "spouseFirstName",          :limit => 22
    t.string  "spouseMiddleName",         :limit => 15
    t.string  "spouseLastName",           :limit => 30
    t.string  "spouseAccountNo",          :limit => 11
    t.string  "spouseEmail",              :limit => 50
    t.string  "fianceeFirstName",         :limit => 15
    t.string  "fianceeMiddleName",        :limit => 15
    t.string  "fianceeLastName",          :limit => 30
    t.string  "isFianceeStaff",           :limit => 1
    t.date    "fianceeJoinStaffDate"
    t.string  "isFianceeJoiningNS",       :limit => 1
    t.string  "joiningNS",                :limit => 1
    t.string  "homePhone",                :limit => 24
    t.string  "workPhone",                :limit => 24
    t.string  "mobilePhone",              :limit => 24
    t.string  "pager",                    :limit => 24
    t.string  "email",                    :limit => 50
    t.string  "isEmailSecure",            :limit => 1
    t.string  "url"
    t.date    "newStaffTrainingdate"
    t.string  "fax",                      :limit => 24
    t.string  "note",                     :limit => 2048
    t.string  "region",                   :limit => 10
    t.string  "countryCode",              :limit => 3
    t.string  "ssn",                      :limit => 9
    t.string  "maritalStatus",            :limit => 1
    t.string  "deptId",                   :limit => 10
    t.string  "jobCode",                  :limit => 6
    t.string  "accountCode",              :limit => 25
    t.string  "compFreq",                 :limit => 1
    t.string  "compRate",                 :limit => 20
    t.string  "compChngAmt",              :limit => 21
    t.string  "jobTitle",                 :limit => 80
    t.string  "deptName",                 :limit => 30
    t.string  "coupleTitle",              :limit => 12
    t.string  "otherPhone",               :limit => 24
    t.string  "preferredName",            :limit => 50
    t.string  "namePrefix",               :limit => 4
    t.date    "origHiredate"
    t.date    "birthDate"
    t.date    "marriageDate"
    t.date    "hireDate"
    t.date    "rehireDate"
    t.date    "loaStartDate"
    t.date    "loaEndDate"
    t.string  "loaReason",                :limit => 80
    t.integer "severancePayMonthsReq"
    t.date    "serviceDate"
    t.date    "lastIncDate"
    t.date    "jobEntryDate"
    t.date    "deptEntryDate"
    t.date    "reportingDate"
    t.string  "employmentType",           :limit => 20
    t.string  "resignationReason",        :limit => 80
    t.date    "resignationDate"
    t.string  "contributionsToOtherAcct", :limit => 1
    t.string  "contributionsToAcntName",  :limit => 80
    t.string  "contributionsToAcntNo",    :limit => 11
    t.integer "fk_primaryAddress"
    t.integer "fk_secondaryAddress"
    t.integer "fk_teamID"
    t.string  "isSecure",                 :limit => 1
    t.string  "isSupported",              :limit => 1
    t.integer "DependentID",                                               :null => false
    t.string  "fianceeAccountno",         :limit => 11
    t.string  "removedFromPeopleSoft",    :limit => 1,    :default => "N"
    t.string  "primaryEmpLocDesc",        :limit => 128
  end

  create_table "ministry_viewnoncccmintargetarea", :id => false, :force => true do |t|
    t.string  "NonCccMinID",       :limit => 64,                 :null => false
    t.integer "TargetAreaID",                     :default => 0, :null => false
    t.string  "name",              :limit => 100
    t.string  "address1",          :limit => 35
    t.string  "address2",          :limit => 35
    t.string  "city",              :limit => 30
    t.string  "state",             :limit => 32
    t.string  "zip",               :limit => 10
    t.string  "country",           :limit => 64
    t.string  "phone",             :limit => 24
    t.string  "fax",               :limit => 24
    t.string  "email",             :limit => 50
    t.string  "url"
    t.string  "abbrv",             :limit => 32
    t.string  "fice",              :limit => 32
    t.string  "note"
    t.string  "altName",           :limit => 100
    t.string  "isSecure",          :limit => 1
    t.string  "isClosed",          :limit => 1
    t.string  "region"
    t.string  "mpta",              :limit => 30
    t.string  "urlToLogo"
    t.string  "enrollment",        :limit => 10
    t.string  "monthSchoolStarts", :limit => 10
    t.string  "monthSchoolStops",  :limit => 10
    t.string  "isSemester",        :limit => 1
    t.string  "isApproved",        :limit => 1
    t.string  "aoaPriority",       :limit => 10
    t.string  "aoa",               :limit => 100
    t.string  "ciaUrl"
    t.string  "infoUrl"
  end

  create_table "ministry_viewsortedactivities", :id => false, :force => true do |t|
    t.string   "name",            :limit => 100
    t.string   "url"
    t.string   "facebook"
    t.integer  "ActivityID",                     :default => 0, :null => false
    t.string   "status",          :limit => 2
    t.datetime "periodBegin"
    t.string   "strategy",        :limit => 2
    t.string   "transUsername",   :limit => 50
    t.integer  "fk_teamID"
    t.integer  "fk_targetAreaID"
  end

  create_table "ministry_viewstaffdependents", :id => false, :force => true do |t|
    t.integer  "DependentID",               :default => 0, :null => false
    t.string   "firstName",   :limit => 80
    t.string   "middleName",  :limit => 80
    t.string   "lastName",    :limit => 80
    t.datetime "birthdate"
    t.string   "gender",      :limit => 1
    t.string   "accountNo",   :limit => 11,                :null => false
  end

  create_table "ministry_viewtargetareanoncccmin", :id => false, :force => true do |t|
    t.integer "NonCccMinID",                :default => 0, :null => false
    t.string  "ministry",     :limit => 50
    t.string  "firstName",    :limit => 30
    t.string  "lastName",     :limit => 30
    t.string  "address1",     :limit => 35
    t.string  "address2",     :limit => 35
    t.string  "city",         :limit => 30
    t.string  "state",        :limit => 6
    t.string  "zip",          :limit => 10
    t.string  "country",      :limit => 64
    t.string  "homePhone",    :limit => 24
    t.string  "workPhone",    :limit => 24
    t.string  "mobilePhone",  :limit => 24
    t.string  "email",        :limit => 80
    t.string  "url",          :limit => 50
    t.string  "pager",        :limit => 24
    t.string  "fax",          :limit => 24
    t.string  "note"
    t.string  "TargetAreaID", :limit => 64,                :null => false
  end

# Could not dump table "mpd_contact_actions" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000724aa20>

# Could not dump table "mpd_contacts" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000722e848>

# Could not dump table "mpd_events" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000072219e0>

  create_table "mpd_expense_types", :force => true do |t|
    t.string "name",                            :null => false
    t.float  "default_amount", :default => 0.0
  end

# Could not dump table "mpd_expenses" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000072100f0>

# Could not dump table "mpd_letter_images" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000071fd8d8>

  create_table "mpd_letter_templates", :force => true do |t|
    t.string  "name",                                 :null => false
    t.string  "thumbnail_filename",   :default => ""
    t.string  "pdf_preview_filename", :default => ""
    t.text    "description"
    t.integer "number_of_images",     :default => 0
  end

# Could not dump table "mpd_letters" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000071e1908>

# Could not dump table "mpd_priorities" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000732d898>

  create_table "mpd_roles", :force => true do |t|
    t.string "name"
  end

# Could not dump table "mpd_roles_users" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000076c6090>

# Could not dump table "mpd_sessions" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007d692f8>

# Could not dump table "mpd_users" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007d4fb00>

  create_table "nag_users", :force => true do |t|
    t.integer  "ssm_id",                    :null => false
    t.datetime "last_login"
    t.datetime "created_at"
    t.integer  "created_by", :default => 0
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  create_table "nags", :force => true do |t|
    t.text   "query"
    t.string "email"
    t.string "subject"
    t.text   "body"
    t.string "emailfield"
    t.text   "userbody"
    t.text   "usersubject"
    t.string "period"
  end

# Could not dump table "old_wsn_sp_wsnapplication" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007a40090>

# Could not dump table "organization_memberships" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007a2c8b0>

# Could not dump table "organizational_roles" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007a19b70>

# Could not dump table "organizations" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007a02970>

  create_table "person_accesses", :force => true do |t|
    t.boolean  "national_access"
    t.boolean  "regional_access"
    t.boolean  "ics_access"
    t.boolean  "intern_access"
    t.boolean  "stint_access"
    t.boolean  "mtl_access"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "phone_numbers" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000079df790>

  create_table "plugin_schema_info", :id => false, :force => true do |t|
    t.string  "plugin_name"
    t.integer "version"
  end

  create_table "pr_admins", :force => true do |t|
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pr_answer_sheet_question_sheets", :force => true do |t|
    t.integer  "answer_sheet_id"
    t.integer  "question_sheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pr_answer_sheets", :force => true do |t|
    t.integer  "question_sheet_id", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "completed_at"
  end

# Could not dump table "pr_answers" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000079aaf90>

  create_table "pr_conditions", :force => true do |t|
    t.integer "question_sheet_id", :null => false
    t.integer "trigger_id",        :null => false
    t.string  "expression",        :null => false
    t.integer "toggle_page_id",    :null => false
    t.integer "toggle_id"
  end

# Could not dump table "pr_elements" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000079749b8>

# Could not dump table "pr_email_templates" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007967858>

  create_table "pr_page_elements", :force => true do |t|
    t.integer  "page_id"
    t.integer  "element_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pr_pages", :force => true do |t|
    t.integer "question_sheet_id",                                   :null => false
    t.string  "label",             :limit => 100,                    :null => false
    t.integer "number"
    t.boolean "no_cache",                         :default => false
    t.boolean "hidden",                           :default => false
  end

  create_table "pr_personal_forms", :force => true do |t|
    t.integer  "person_id"
    t.integer  "question_sheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pr_question_sheet_pr_infos", :force => true do |t|
    t.integer  "question_sheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "form_type",         :default => "review"
    t.integer  "summary_form_id"
  end

  create_table "pr_question_sheets", :force => true do |t|
    t.string  "label",        :limit => 60,                    :null => false
    t.boolean "archived",                   :default => false
    t.boolean "fake_deleted",               :default => false
  end

  create_table "pr_references", :force => true do |t|
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

  create_table "pr_reminders", :force => true do |t|
    t.integer  "person_id"
    t.string   "label"
    t.text     "note"
    t.date     "reminder_date"
    t.boolean  "send_email",      :default => false
    t.integer  "email_days_diff", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "email_sent_at"
  end

  create_table "pr_reviewers", :force => true do |t|
    t.integer  "review_id"
    t.integer  "person_id"
    t.datetime "invitation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_key"
    t.datetime "submitted_at"
  end

  create_table "pr_reviews", :force => true do |t|
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
    t.integer  "show_summary_form_days", :default => 14
    t.boolean  "fake_deleted",           :default => false
  end

  create_table "pr_sessions", :force => true do |t|
    t.text "session_id"
    t.text "data"
  end

  create_table "pr_summary_forms", :force => true do |t|
    t.integer  "person_id"
    t.integer  "review_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pr_users", :force => true do |t|
    t.integer  "ssm_id"
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "profile_pictures" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000078d0fc0>

  create_table "questionnaires", :force => true do |t|
    t.string   "title",      :limit => 200
    t.string   "type",       :limit => 50
    t.datetime "created_at"
  end

# Could not dump table "rails_admin_histories" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000078bc980>

  create_table "rails_crons", :force => true do |t|
    t.text    "command"
    t.integer "start"
    t.integer "finish"
    t.integer "every"
    t.boolean "concurrent"
  end

# Could not dump table "received_sms" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000078a35e8>

  create_table "rejoicables", :force => true do |t|
    t.integer  "person_id"
    t.integer  "created_by_id"
    t.integer  "organization_id"
    t.integer  "followup_comment_id"
    t.string   "what",                :limit => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rideshare_event", :force => true do |t|
    t.integer "conference_id"
    t.string  "event_name",    :limit => 50
    t.string  "password",      :limit => 50, :null => false
    t.text    "email_content"
  end

# Could not dump table "rideshare_ride" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000078725b0>

  create_table "roles", :force => true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "i18n"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "school_years", :force => true do |t|
    t.string   "name"
    t.string   "level"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sent_sms", :force => true do |t|
    t.text     "message"
    t.string   "recipient"
    t.text     "reports"
    t.string   "moonshado_claimcheck"
    t.string   "sent_via"
    t.integer  "received_sms_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "si_answer_sheets" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000784a510>

# Could not dump table "si_answers" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000783b448>

# Could not dump table "si_applies" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000782f710>

# Could not dump table "si_apply_sheets" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007824d10>

# Could not dump table "si_character_references" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007812138>

# Could not dump table "si_conditions" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007806a18>

# Could not dump table "si_elements" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000077edf90>

  create_table "si_email_templates", :force => true do |t|
    t.string  "name",    :limit => 60, :null => false
    t.text    "content"
    t.boolean "enabled"
    t.string  "subject"
  end

# Could not dump table "si_pages" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000077d9b58>

# Could not dump table "si_payments" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000077cc3e0>

  create_table "si_question_sheets", :force => true do |t|
    t.string "label", :limit => 60, :null => false
  end

  create_table "si_roles", :force => true do |t|
    t.string "role",       :null => false
    t.string "user_class", :null => false
  end

  create_table "si_sleeve_sheets", :force => true do |t|
    t.integer "sleeve_id",                       :null => false
    t.integer "question_sheet_id",               :null => false
    t.string  "title",             :limit => 60, :null => false
    t.string  "assign_to",         :limit => 36, :null => false
  end

# Could not dump table "si_sleeves" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000077add00>

# Could not dump table "si_users" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000077a2630>

# Could not dump table "simplesecuritymanager_user" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000777ce08>

# Could not dump table "sitrack_children" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007771fd0>

  create_table "sitrack_columns", :force => true do |t|
    t.string   "name",              :limit => 30,                  :null => false
    t.string   "column_type",       :limit => 20,                  :null => false
    t.string   "select_clause",     :limit => 7000,                :null => false
    t.string   "where_clause"
    t.string   "update_clause",     :limit => 2000
    t.string   "table_clause",      :limit => 100
    t.integer  "show_in_directory", :limit => 1,    :default => 1, :null => false
    t.integer  "writeable",         :limit => 1,    :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "maxlength"
  end

# Could not dump table "sitrack_enum_values" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007755740>

# Could not dump table "sitrack_feeds" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000774e170>

  create_table "sitrack_forms", :force => true do |t|
    t.integer  "approver_id",                                     :null => false
    t.string   "type",                            :limit => 50,   :null => false
    t.integer  "current_years_salary"
    t.integer  "previous_years_salary"
    t.integer  "additional_salary"
    t.integer  "adoption"
    t.integer  "counseling"
    t.integer  "childrens_expenses"
    t.integer  "college"
    t.integer  "private_school"
    t.integer  "graduate_studies"
    t.integer  "auto_purchase"
    t.integer  "settling_in_expenses"
    t.integer  "reimbursable_expenses"
    t.integer  "tax_rate"
    t.datetime "date_of_change"
    t.string   "action"
    t.string   "reopen_as",                       :limit => 100
    t.datetime "freeze_start"
    t.datetime "freeze_end"
    t.string   "change_assignment_from_team",     :limit => 100
    t.string   "change_assignment_from_location", :limit => 100
    t.string   "change_assignment_to_team",       :limit => 100
    t.string   "change_assignment_to_location",   :limit => 100
    t.string   "restint_location",                :limit => 100
    t.string   "departure_date_certainty",        :limit => 100
    t.integer  "hours_per_week"
    t.string   "other_explanation",               :limit => 1000
    t.datetime "new_staff_training_date"
    t.string   "payroll_action",                  :limit => 100
    t.string   "payroll_reason",                  :limit => 100
    t.string   "hrd",                             :limit => 100
    t.string   "spouse_name",                     :limit => 100
    t.boolean  "spouse_transitioning"
    t.string   "salary_reason",                   :limit => 1000
    t.integer  "annual_salary"
    t.integer  "hr_si_application_id",                            :null => false
    t.text     "additional_notes"
  end

# Could not dump table "sitrack_mpd" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000077098b8>

# Could not dump table "sitrack_queries" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000076fdd88>

# Could not dump table "sitrack_saved_criteria" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000076f0868>

# Could not dump table "sitrack_session_values" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000076e6020>

# Could not dump table "sitrack_sessions" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000076de898>

# Could not dump table "sitrack_tracking" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000768af18>

# Could not dump table "sitrack_users" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000767e1c8>

# Could not dump table "sitrack_view_columns" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007675d70>

# Could not dump table "sitrack_views" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000766c6d0>

  create_table "sms_carriers", :force => true do |t|
    t.string   "name"
    t.string   "moonshado_name"
    t.string   "email"
    t.integer  "recieved",       :default => 0
    t.integer  "sent_emails",    :default => 0
    t.integer  "bounced_emails", :default => 0
    t.integer  "sent_sms",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "sms_keywords" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000764cb00>

# Could not dump table "sms_sessions" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000076408f0>

# Could not dump table "sn_campus_involvements" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000762ee48>

  create_table "sn_campus_ministry_group", :force => true do |t|
    t.integer "group_id"
    t.integer "campus_id"
    t.integer "ministry_id"
  end

  create_table "sn_columns", :force => true do |t|
    t.string   "title"
    t.string   "update_clause"
    t.string   "from_clause"
    t.text     "select_clause"
    t.string   "column_type"
    t.string   "writeable"
    t.string   "join_clause"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_model"
    t.string   "source_column"
    t.string   "foreign_key"
  end

  create_table "sn_correspondence_types", :force => true do |t|
    t.string  "name"
    t.integer "overdue_lifespan"
    t.integer "expiry_lifespan"
    t.string  "actions_now_task"
    t.string  "actions_overdue_task"
    t.string  "actions_followup_task"
    t.text    "redirect_params"
    t.string  "redirect_target_id_type"
  end

# Could not dump table "sn_correspondences" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000075fc6f0>

# Could not dump table "sn_custom_attributes" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000075f1750>

# Could not dump table "sn_custom_values" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000075e9af0>

  create_table "sn_delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "sn_dorms" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000075d23c8>

  create_table "sn_email_templates", :force => true do |t|
    t.integer  "correspondence_type_id"
    t.string   "outcome_type"
    t.string   "subject",                :null => false
    t.string   "from",                   :null => false
    t.string   "bcc"
    t.string   "cc"
    t.text     "body",                   :null => false
    t.text     "template"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sn_emails", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.text     "people_ids"
    t.text     "missing_address_ids"
    t.integer  "search_id"
    t.integer  "sender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sn_free_times", :force => true do |t|
    t.integer  "start_time"
    t.integer  "end_time"
    t.integer  "day_of_week"
    t.integer  "timetable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "css_class"
    t.decimal  "weight",       :precision => 4, :scale => 2
  end

# Could not dump table "sn_group_involvements" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000075a03a0>

  create_table "sn_group_types", :force => true do |t|
    t.integer  "ministry_id"
    t.string   "group_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mentor_priority"
    t.boolean  "public"
    t.integer  "unsuitability_leader"
    t.integer  "unsuitability_coleader"
    t.integer  "unsuitability_participant"
    t.string   "collection_group_name",     :default => "{{campus}} interested in a {{group_type}}"
    t.boolean  "has_collection_groups",     :default => false
  end

# Could not dump table "sn_groups" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000757a3a8>

  create_table "sn_imports", :force => true do |t|
    t.integer  "person_id"
    t.integer  "parent_id"
    t.integer  "size"
    t.integer  "height"
    t.integer  "width"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sn_involvement_histories", :force => true do |t|
    t.string   "type"
    t.integer  "person_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "campus_id"
    t.integer  "school_year_id"
    t.integer  "ministry_id"
    t.integer  "ministry_role_id"
    t.integer  "campus_involvement_id"
    t.integer  "ministry_involvement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "sn_ministries" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000075398a8>

# Could not dump table "sn_ministry_campuses" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007530d20>

# Could not dump table "sn_ministry_involvements" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000751fef8>

  create_table "sn_ministry_role_permissions", :force => true do |t|
    t.integer "permission_id"
    t.integer "ministry_role_id"
    t.string  "created_at"
  end

# Could not dump table "sn_ministry_roles" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000750b908>

  create_table "sn_news", :force => true do |t|
    t.string   "title"
    t.text     "message"
    t.integer  "group_id"
    t.integer  "ministry_id"
    t.integer  "person_id"
    t.boolean  "sticky"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "staff",       :default => false
    t.boolean  "students",    :default => false
    t.boolean  "featured",    :default => false
  end

  create_table "sn_news_comments", :force => true do |t|
    t.integer  "news_id"
    t.integer  "person_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sn_permissions", :force => true do |t|
    t.string "description"
    t.string "controller"
    t.string "action"
  end

# Could not dump table "sn_person_news" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000074e1040>

  create_table "sn_searches", :force => true do |t|
    t.integer  "person_id"
    t.text     "options"
    t.text     "query"
    t.text     "tables"
    t.boolean  "saved"
    t.string   "name"
    t.string   "order"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "sn_semesters" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000074c8b30>

# Could not dump table "sn_sessions" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000074be1d0>

# Could not dump table "sn_timetables" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000074b67a0>

# Could not dump table "sn_training_answers" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000074ab198>

# Could not dump table "sn_training_categories" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000074a0158>

  create_table "sn_training_question_activations", :force => true do |t|
    t.integer  "ministry_id"
    t.integer  "training_question_id"
    t.boolean  "mandate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "sn_training_questions" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000748d648>

# Could not dump table "sn_user_codes" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000074859c0>

  create_table "sn_user_group_permissions", :force => true do |t|
    t.integer "permission_id"
    t.integer "user_group_id"
    t.string  "created_at"
  end

  create_table "sn_user_groups", :force => true do |t|
    t.string  "name"
    t.date    "created_at"
    t.integer "ministry_id"
  end

  create_table "sn_user_memberships", :force => true do |t|
    t.integer "user_id"
    t.integer "user_group_id"
    t.date    "created_at"
  end

# Could not dump table "sn_view_columns" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000074671a0>

# Could not dump table "sn_views" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000745b9b8>

  create_table "sn_years", :force => true do |t|
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "sp_answer_sheet_question_sheets" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000744d0e8>

  create_table "sp_answer_sheets", :force => true do |t|
    t.integer  "question_sheet_id", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "completed_at"
  end

# Could not dump table "sp_answers" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007436a50>

  create_table "sp_application_moves", :force => true do |t|
    t.integer  "application_id"
    t.integer  "old_project_id"
    t.integer  "new_project_id"
    t.integer  "moved_by_person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "sp_applications" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000740cac0>

  create_table "sp_conditions", :force => true do |t|
    t.integer "question_sheet_id", :null => false
    t.integer "trigger_id",        :null => false
    t.string  "expression",        :null => false
    t.integer "toggle_page_id",    :null => false
    t.integer "toggle_id"
  end

# Could not dump table "sp_donations" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000073ecfb8>

# Could not dump table "sp_elements" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000073cc740>

# Could not dump table "sp_email_templates" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000073c05a8>

  create_table "sp_evaluations", :force => true do |t|
    t.integer "application_id",                        :null => false
    t.integer "spiritual_maturity", :default => 0
    t.integer "teachability",       :default => 0
    t.integer "leadership",         :default => 0
    t.integer "stability",          :default => 0
    t.integer "good_evangelism",    :default => 0
    t.integer "reason",             :default => 0
    t.integer "social_maturity",    :default => 0
    t.integer "ccc_involvement",    :default => 0
    t.boolean "charismatic",        :default => false
    t.boolean "morals",             :default => false
    t.boolean "drugs",              :default => false
    t.boolean "bad_evangelism",     :default => false
    t.boolean "authority",          :default => false
    t.boolean "eating",             :default => false
    t.text    "comments"
  end

  create_table "sp_gospel_in_actions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sp_ministry_focuses", :force => true do |t|
    t.string "name"
  end

  create_table "sp_ministry_focuses_projects", :id => false, :force => true do |t|
    t.integer "sp_project_id",        :default => 0, :null => false
    t.integer "sp_ministry_focus_id", :default => 0, :null => false
  end

# Could not dump table "sp_page_elements" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000738f8b8>

# Could not dump table "sp_pages" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007383ec8>

  create_table "sp_payments", :force => true do |t|
    t.integer  "application_id"
    t.string   "payment_type"
    t.string   "amount"
    t.string   "payment_account_no"
    t.datetime "created_at"
    t.string   "auth_code"
    t.string   "status"
    t.datetime "updated_at"
  end

# Could not dump table "sp_project_gospel_in_actions" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000073707b0>

# Could not dump table "sp_project_versions" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000073141e0>

# Could not dump table "sp_projects" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000072a1c58>

  create_table "sp_question_options", :force => true do |t|
    t.integer  "question_id"
    t.string   "option",      :limit => 50
    t.string   "value",       :limit => 50
    t.integer  "position"
    t.datetime "created_at"
  end

  create_table "sp_question_sheets", :force => true do |t|
    t.string  "label",    :limit => 1000,                    :null => false
    t.boolean "archived",                 :default => false
  end

  create_table "sp_questionnaire_pages", :force => true do |t|
    t.integer  "questionnaire_id"
    t.integer  "page_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "sp_references" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007272278>

  create_table "sp_roles", :force => true do |t|
    t.string "role",       :limit => 50
    t.string "user_class"
  end

# Could not dump table "sp_staff" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000072629e0>

  create_table "sp_stats", :force => true do |t|
    t.integer  "project_id"
    t.integer  "spiritual_conversations_initiated"
    t.integer  "gospel_shared"
    t.integer  "received_christ"
    t.integer  "holy_spirit_presentations"
    t.integer  "holy_spirit_filled"
    t.integer  "other_exposures"
    t.integer  "involved_new_believers"
    t.integer  "students_involved"
    t.integer  "spiritual_multipliers"
    t.string   "type",                              :limit => 50
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "gospel_shared_personal"
    t.integer  "gospel_shared_group"
    t.integer  "gospel_shared_media"
    t.integer  "pioneer_campuses"
    t.integer  "key_contact_campuses"
    t.integer  "launched_campuses"
    t.integer  "movements_launched"
  end

# Could not dump table "sp_student_quotes" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007239ec8>

# Could not dump table "sp_users" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000722e528>

# Could not dump table "staffsite_staffsitepref" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000007225b58>

# Could not dump table "staffsite_staffsiteprofile" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000072147b8>

  create_table "states", :force => true do |t|
    t.string "state", :limit => 100
    t.string "code",  :limit => 10
  end

  create_table "summer_placement_preferences", :force => true do |t|
    t.integer  "person_id"
    t.datetime "submitted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "teams" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000767ed30>

# Could not dump table "versions" because of following NoMethodError
#   undefined method `type' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000792b3a8>

end
