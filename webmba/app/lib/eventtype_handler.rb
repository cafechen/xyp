module EventTypeHandler
  
  def do_create_eventtype(req)
    resp = {}
    @eventType = EventType.new()
    @eventType.name = req['name']
    if @eventType.save
      resp = [@eventType]
    else
      error_msg = ""
      @eventType.errors.full_messages.each do |msg|
        error_msg = msg
      end
      resp = [{"error" => error_msg}]
    end
    return resp
  end
  
  def do_delete_eventtype(req)
    @eventType = EventType.find(req['eventTypeId'].to_i)
    if @eventType.destroy
      resp = [{"result"=>"deleted"}]
    else
      error_msg = ""
      @eventType.errors.full_messages.each do |msg|
        error_msg = msg
      end
      resp = [{"error"=> error_msg}]
    end
    return resp
  end
  
  def do_describe_eventtypes(req)
    EventType.all
  end
  
end