require 'digest/sha1'

module User
  ###########################################################
  ## User functions
  ###########################################################
  
  def describe_users(email=nil)
    data = {
      "cmd" => "describe_users",
      "email" => email
    }
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def describe_user_by_mobile(mobile)
    data = {
      "cmd" => "describe_user_by_mobile",
      "mobile" => mobile
    }
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def describe_user(email,getEvents=nil)
    data = {
      "cmd" => "describe_user",
      "email" => email,
      "getEvents" => getEvents
    }
    send_data(data)
  rescue
    process_exception($!)
  end


  def register_user(data)
   
    data["password"] = Digest::MD5.hexdigest(data['password'])
    data['cmd'] = "register_user"
        
    send_data(data)
  end
  
  def create_user(email,password,name,mobile=nil)
    
    user_hash = Hash.new()
    user_hash["email"] = email
    user_hash["password"] = password
    user_hash["name"] = name
    user_hash["mobile"] = mobile if !mobile.nil?
    
    puts user_hash.inspect
    
    data = {
      "cmd" => "create_users",
      "users" => [user_hash]
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def delete_user(email)
    data = {
      "cmd" => "delete_users",
      "email" => [email]
    }
    send_data(data)
  rescue
    process_exception($!)
  end
  
  ###########################################################
  ## End of User functions
  ###########################################################

end
