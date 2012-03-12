require 'logger'
require File.dirname(__FILE__) + '/deps/client_utils'

if ENV["WS_ENDPOINT"].nil? or ENV["WS_ENDPOINT"].empty?
  Client_Utils.print_msg("prerequisiteWarning")
  exit
end

# where should the AWS client log output to?
WS_LOG_FILE = STDOUT # or could be a string i.e. "logfile.log"

# Log types are FATAL, ERROR, WARN, INFO, DEBUG
WS_LOG_LEVEL = Logger::WARN

WS_USER_DISPLAY = [
  {"col"=>"email","name" => "Email"},
  {"col"=>"name","name" => "Name"},
  {"col"=>"mobile","name" => "Mobile"},
  {"col"=>"email","name" => "Email"},
  {"col"=>"workstate","name" => "WorkState"},
  {"col"=>"school","name" => "School"},
  {"col"=>"company","name" => "Company"},
  {"col"=>"title","name" => "Title"},
  {"col"=>"intro","name" => "Intro"}
]

WS_ORGTYPE_DISPLAY = [
  {"col"=>"id","name" => "ID"},
  {"col"=>"name","name" => "Name"}
]

WS_ROLE_DISPLAY = [
  {"col"=>"id","name" => "ID"},
  {"col"=>"name","name" => "Name"},
  {"col"=>"role_type","name" => "Type"}
]

WS_ORG_DISPLAY = [
  {"col"=>"id","name" => "ID"},
  {"col"=>"name","name" => "Name"},
  {"col"=>"org_type_name","name" => "OrgType"},
  {"col"=>"chairman","name" => "Creater"},
  {"col"=>"school_name","name" => "School"},
  {"col"=>"joined","name" => "Joined"},
  {"col"=>"followed","name" => "Followed"},
  {"col"=>"events","name" => "Events"}

]

WS_EVENTTYPE_DISPLAY = [
  {"col"=>"id","name" => "ID"},
  {"col"=>"name","name" => "Name"}
]

WS_SCHOOL_DISPLAY = [
  {"col"=>"schoolId","name" => "SchoolId"},
  {"col"=>"schoolName","name" => "SchoolName"}
]

WS_EVENT_DISPLAY = [
  {"col"=>"id","name" => "ID"},
  {"col"=>"title","name" => "Title"},
  {"col"=>"place","name" => "Place"},
  {"col"=>"speaker","name" => "Speaker"},
  {"col"=>"speakerInfo","name" => "SpeakerInfo"},
  {"col"=>"school_name","name" => "School"},
  {"col"=>"toward","name" => "Toward"},
  {"col"=>"sponsor","name" => "Sponsor"},
  {"col"=>"cooperater","name" => "Cooperater"},
  {"col"=>"undertaker","name" => "Undertaker"},
  {"col"=>"org_name","name" => "Club"},
  {"col"=>"brief","name" => "Brief"},
  {"col"=>"beginTime","name" => "BeginTime"},
  {"col"=>"endTime","name" => "EndTime"},
  {"col"=>"status","name" => "Status"},
  {"col"=>"seat","name" => "Seat"},
  {"col"=>"others","name" => "Others"}
]

COLNAME_REPLACEMENTS = {
}
