
module Role
  ###########################################################
  ## Role functions
  ###########################################################
  
  def describe_roles()
    data = {
      "cmd" => "describe_roles"
    }
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def create_role(name,type)
    
    data = {
      "cmd" => "create_role",
      "name" => name,
      "role_type" => type
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def delete_role(roleId)
    data = {
      "cmd" => "delete_role",
      "roleId" => roleId
    }
    send_data(data)
  rescue
    process_exception($!)
  end
  
  ###########################################################
  ## End of Role functions
  ###########################################################

end