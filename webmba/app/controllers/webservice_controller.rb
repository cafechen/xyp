require File.expand_path('../../lib/orgtype_handler', __FILE__)
require File.expand_path('../../lib/user_handler', __FILE__)
require File.expand_path('../../lib/role_handler', __FILE__)
require File.expand_path('../../lib/org_handler', __FILE__)
require File.expand_path('../../lib/eventtype_handler', __FILE__)
require File.expand_path('../../lib/school_handler', __FILE__)
require File.expand_path('../../lib/auth_handler', __FILE__)
require File.expand_path('../../lib/event_handler', __FILE__)

class WebserviceController < ApplicationController
  
  include UserHandler
  include OrgTypeHandler
  include EventTypeHandler
  include EventHandler
  include RoleHandler
  include OrgHandler
  include AuthHandler
  include SchoolHandler
  
  def query
        
    req = nil
    msg = nil
    msg = request.body.string
    
    @@logger.debug "request: #{msg.inspect}"
    
    begin
      req = JSON.parse msg
    rescue
      return response_error(400,"Unrecognized JSON.generate format")
    end
    
    ws_email = req["email"]
    ws_password = req["password"]
    
    cmd = req["cmd"]
    
    begin
      
      method = "do_" + cmd
      
      unless isUserHasPrivilege(ws_email,ws_password,method)
        return response_error(403,"You don't have privilege to invoke this command: #{method}")
      end
      
      response= self.send(method, req)
      
      @@logger.debug "response: #{response.inspect}"
      
      if response.kind_of?(Hash) and response.first!=nil and response.first["error"] != nil
        return response_error(400, response.first)
      end
      if response.kind_of?(Array) and !response.nil? and response.size==1 and response.first["error"]
        return response_error(400, response.first)
      end

      begin
        render :json => response, :status => :ok
      rescue Exception=> e
        @@logger.error(e)
        return response_error(400, response.first)
      end
      
    rescue NoMethodError => e
      @@logger.error(e)
      return response_error(400, "No such method in Web Service : #{e.inspect}")
    rescue => ex
      @@logger.error(ex)
      return response_error(500, "Internal Error : #{ex.inspect}")
    end
    
  end
  
  def response_error(http_status_code, message)
    if message.class == String
      message = [{KEY_ERROR_CODE=>"ErrorMessage",KEY_ERROR => message,KEY_ERROR_PARAMETER => message}]
    elsif message.class == Hash
      message[KEY_ERROR_CODE] = "ErrorMessage" if message[KEY_ERROR_CODE].nil?
      message = [message]
    end
    @@logger.error("response_error :: #{message.inspect}")
    respond_to do |format|
      format.json { render :json => message, :status => 400 }
    end
  end
  
end
