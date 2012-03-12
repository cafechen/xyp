
module School
  ###########################################################
  ## School functions
  ###########################################################
  
  def create_school(name)
    
    data = {
      "cmd" => "create_school",
      "schoolName" => name
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def delete_school(school_id)
    
    data = {
      "cmd" => "delete_school",
      "schoolId" => school_id
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def describe_schools()
    data = {
      "cmd" => "describe_schools"
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  ###########################################################
  ## School functions
  ###########################################################

end