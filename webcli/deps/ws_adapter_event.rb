
module Event
  ###########################################################
  ## Event functions
  ###########################################################
  
  def create_eventtype(name)
    
    data = {
      "cmd" => "create_eventtype",
      "name" => name
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def delete_eventtype(event_type_id)
    
    data = {
      "cmd" => "delete_eventtype",
      "eventTypeId" => event_type_id
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def describe_eventtypes()
    data = {
      "cmd" => "describe_eventtypes"
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def create_event(data)
    data["cmd"] = "create_event"
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def delete_event(event_id)
    
    data = {
      "cmd" => "delete_event",
      "eventId" => event_id
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def describe_events(filter=nil)
    data = {
      "cmd" => "describe_events",
      "filter" => filter
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def join_event(event_id)
    
    data = {
      "cmd" => "join_event",
      "eventId" => event_id
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def follow_event(event_id)
    
    data = {
      "cmd" => "follow_event",
      "eventId" => event_id
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end

  def exit_event(event_id)
  
    data = {
      "cmd" => "exit_event",
      "eventId" => event_id
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  def unfollow_event(event_id)
  
    data = {
      "cmd" => "unfollow_event",
      "eventId" => event_id
    }
    
    send_data(data)
  rescue
    process_exception($!)
  end
  
  ###########################################################
  ## End of Event functions
  ###########################################################

end