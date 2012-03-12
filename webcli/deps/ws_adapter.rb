require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'pp'
require 'pathname'
require File.join(File.dirname(__FILE__),"ws_adapter_user")
require File.join(File.dirname(__FILE__),"ws_adapter_event")
require File.join(File.dirname(__FILE__),"ws_adapter_org")
require File.join(File.dirname(__FILE__),"ws_adapter_role")
require File.join(File.dirname(__FILE__),"ws_adapter_school")

REAL_PATH = Pathname.new(File.dirname(__FILE__)).realpath

class WSAdapter
  
  include User
  include Event
  include Org
  include Role
  include School

  @logger
  @http
  @host
  @port
  @path
  
  def initialize(conf=nil, terminate_on_exception = true, logger = nil)

    if logger == nil
      @logger = Logger.new(WS_LOG_FILE)
      @logger.level = WS_LOG_LEVEL
    end

    if conf.nil?
      @service = ENV["WS_ENDPOINT"]
      @timeout = ENV["WS_TIMEOUT"]
      @email = ENV["WS_EMAIL"]
      @password = ENV["WS_PASSWORD"]
      
    else
      @service = conf["WS_ENDPOINT"]
      @timeout = conf["WS_TIMEOUT"]
      @email = conf["WS_EMAIL"]
      @password = conf["WS_PASSWORD"]
    end

    uri = URI.parse(@service)
    @http = Net::HTTP.new(uri.host, uri.port)
    @path = uri.path
    @host = uri.host
    @port = uri.port

    @terminate_on_exception = terminate_on_exception
  end

  def set_service(endpoint)
    @service = endpoint
  end

  def set_timeout(timeout)
    @timeout = timeout
  end

  def send_data(data)

    headers = {'Content-Type' => "application/json"}
    
    if data["timeout"].nil? or data["timeout"].empty?
      data["timeout"] = @timeout
    end
    
    data['email'] = @email if data['email'].nil?
    data['password'] = @password if data['password'].nil?
    
    raw_data = JSON.generate(data)
    puts "sending data #{raw_data}"
    
    resp, resp_data_raw = @http.post(@path, raw_data, headers)
    puts "response data: #{resp_data_raw}"
    
    return_code = resp.code
    
    case return_code
    when "200"   # status : OK
      begin
        resp_data = JSON.parse(resp_data_raw)
      rescue
        if resp_data_raw == nil or resp_data_raw.empty?
          resp_data = [{"error"=>"(#{return_code}):Unable to get completed web service response, maybe caused by timed-out."}]
        else
          resp_data = [{"error"=>"(#{return_code}):Unable to parse web service response."}]
        end
      end
    when "400"   # Other Error
      resp_data = JSON.parse(resp_data_raw) rescue [{"error"=>"(#{return_code}):Unable to parse web service response."}]
    when "401"   # Unauthorized
      resp_data = [{"error" => "(#{return_code})Authentication credentials are missing or invalid."}]
    when "403"   # User No Privilege
      resp_data = [{"error" => "(#{return_code})User has no privilege for this request."}]
    when "404"   # URI Not Found
      resp_data = [{"error" => "(#{return_code})Web Service URI Not Found."}]
    when "500"   # Internal Error
      resp_data = JSON.parse(resp_data_raw) rescue [{"error"=>"(#{return_code}):Unable to parse web service response."}]
    end
    
    return resp_data
  end

  def process_exception(e)
    if e.kind_of?(Timeout::Error)
      Client_Utils.print_msg("requestTimeout")
      $stdout.flush
      throw_exception_or_exit(2)

    elsif e.kind_of?(Errno::ECONNREFUSED)
      Client_Utils.print_msg("connectFailed",@service)
      $stdout.flush
      throw_exception_or_exit(1)

    else
      Client_Utils.print_msg("requestFailed",e)
      $stdout.flush
      throw_exception_or_exit(999)
    end
  end

  def throw_exception_or_exit(code)
    if ENV['WS_EXIT_ON_EXCEPTION'] == true
      throw :catch_exception
    else
      exit(code)
    end
  end

end
