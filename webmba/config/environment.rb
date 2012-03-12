# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Webmba::Application.initialize!

@@logger = Logger.new("/tmp/webapp.log")

ADMIN_USER = 'chenjian945@gmail.com'

ADMIN_ROLE=1
MEMBER_ROLE=2
FANS_ROLE=3

SYS_ROLE=1
USER_ROLE=2

FOLLOW_EVENT=1
JOIN_EVENT=2

MBA_READING = 0
MBA_READ = 1
BACHELOR = 2
MASTER = 3
DOCTOR = 4
ELITE = 5
STARTUP = 6

KEY_ERROR_CODE = 'error_code'
KEY_ERROR='error'
KEY_ERROR_PARAMETER='error_parameters'