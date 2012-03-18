module EventHandler
  
  def do_create_event(req)
    
    #Check if the user is a org admin
    
    @user = User.find_by_email(req['email'])
    
    if @user.nil?
      return {"error"=>"User is not exist!"}
    end
    
    @userOrg = UserOrg.find_by_user_id_and_org_id(@user['id'],req['org'])
    
    if @userOrg.nil? 
      return {"error"=>"Org is not exist!"}
    end
    
    unless @userOrg.role_id == ADMIN_ROLE 
      return {"error"=>"You are not admin in this organization!"}
    end
    
    @org = Org.find(req['org'])

    @event = Event.new
    @event.title = req['title']
    @event.place = req['place']
    @event.speaker = req['speaker']
    @event.speakerInfo = req['speakerInfo']
    @event.sponsor = req['sponsor']
    @event.undertaker = req['undertaker']
    @event.cooperater = req['cooperater']
    @event.seat = req['seat']
    @event.brief = req['brief']
    @event.toward = req['toward']
    @event.others = req['others']
    @event.beginTime = req['beginTime']
    @event.endTime = req['endTime']
    @event.school_id = @user.school_id
    @event.school_name = @user.school
    @event.org_id = @org.id
    @event.org_name = @org.name
    @event.status = 0
    @event.email = @user.email
    
    if @event.save
      return [@event]
    else
      error_msg = ""
      @event.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error" => error_msg}]
    end
    
  end
  
  def do_modify_event(req)
    
    #Check if the user is a org admin
    
    @user = User.find_by_email(req['email'])
    
    if @user.nil?
      return {"error"=>"User is not exist!"}
    end
    
    @event = Event.find(req['eventId'])
    
    if @event.nil? 
      return {"error"=>"Event is not exist!"}
    end

    @event.title = req['title']
    @event.place = req['place']
    @event.speaker = req['speaker']
    @event.speakerInfo = req['speakerInfo']
    @event.sponsor = req['sponsor']
    @event.undertaker = req['undertaker']
    @event.cooperater = req['cooperater']
    @event.seat = req['seat']
    @event.brief = req['brief']
    @event.toward = req['toward']
    @event.others = req['others']
    @event.beginTime = req['beginTime']
    @event.endTime = req['endTime']
    @event.status = 0
    
    puts @event.inspect
    
    if @event.save
      return [@event]
    else
      error_msg = ""
      @event.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error" => error_msg}]
    end
    
  end
  
  def do_delete_event(req)
    @event = Event.find(req['eventId'].to_i)
    if @event.destroy
      return [{"result"=>"deleted"}]
    else
      error_msg = ""
      @event.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error"=> error_msg}]
    end
  end
  
  def do_describe_events(req)
    if !req.nil? and !req['filter'].nil? and !req['filter'].empty? and req['filter'] != ""
      return Event.find(:all, :conditions => "title like '%#{req['filter']}%'")
    end
    if !req.nil? and !req['owner'].nil? and !req['owner'].empty? and req['owner'] != ""
      return Event.where(:email => req['owner']);
    end
    Event.all
  end
  
  def do_delete_event(req)
    @event = Event.find(req['eventId'].to_i)
    if @event.destroy
      return [{"result"=>"deleted"}]
    else
      error_msg = ""
      @event.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error"=> error_msg}]
    end
  end

  def do_follow_event(req)
    
    @user = User.find_by_email(req['email'])
    @event = Event.find(req['eventId'].to_i)

    if @event.nil?
      return [{"error"=>"The Event is not exist!"}]
    end
    
    @userEvent = UserEvent.new
    
    @ue = UserEvent.find_by_user_id_and_event_id(@user.id, @event.id)
    
    if @ue.nil?
      @userEvent.user_id = @user.id
      @userEvent.event_id = @event.id
      @userEvent.status = FOLLOW_EVENT
    elsif @ue.status == FOLLOW_EVENT
      return ["result"=>"0"]
    elsif @ue.status == JOIN_EVENT
      return ["result"=>"0"]
    end
    
    if @userEvent.save
      return ["result"=>"0"]
    else
      error_msg = ""
      @userEvent.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error" => error_msg}]
    end
  end

  def do_join_event(req)
    
    @user = User.find_by_email(req['email'])
    @event = Event.find(req['eventId'].to_i)
    
    if @user.nil?
      return [{"error"=>"The User is not exist!"}]
    end
    
    if @event.nil?
      return [{"error"=>"The Event is not exist!"}]
    end
    
    @userEvent = UserEvent.new
    
    @ue = UserEvent.find_by_user_id_and_event_id(@user.id, @event.id)
    
    if @ue.nil?
      @userEvent.user_id = @user.id
      @userEvent.event_id = @event.id
      @userEvent.status = JOIN_EVENT
    elsif @ue.status == FOLLOW_EVENT
      @ue.status = JOIN_EVENT
      if @ue.save
       return ["result"=>"0"]
      else
        error_msg = ""
        @ue.errors.full_messages.each do |msg|
          error_msg = msg
        end
        return [{"error" => error_msg}]
      end
    elsif @ue.status == JOIN_EVENT
      return ["result"=>"0"]
    end
    
    if @userEvent.save
      return ["result"=>"0"]
    else
      error_msg = ""
      @userEvent.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error" => error_msg}]
    end
  end

  def do_exit_event(req)
    
    @user = User.find_by_email(req['email'])
    @event = Event.find(req['eventId'].to_i)

    if @event.nil?
      return [{"error"=>"The Event is not exist!"}]
    end
    
    @ue = UserEvent.find_by_user_id_and_event_id_and_status(@user.id, @event.id, JOIN_EVENT)
    
    if @ue.nil?
      return [{"error"=>"You don't join this event!"}]  
    elsif @ue.destroy
      return ["result"=>"0"]
    else
      error_msg = ""
      @ue.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error" => error_msg}]
    end
  end
  
  def do_unfollow_event(req)
    
    @user = User.find_by_email(req['email'])
    @event = Event.find(req['eventId'].to_i)
    
    if @event.nil?
      return [{"error"=>"The Event is not exist!"}]
    end
    
    @ue = UserEvent.find_by_user_id_and_event_id_and_status(@user.id, @event.id, FOLLOW_EVENT)
    
    if @ue.nil?
      return [{"error"=>"You don't follow this event!"}]  
    elsif @ue.destroy
      return ["result"=>"0"]
    else
      error_msg = ""
      @ue.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error" => error_msg}]
    end
  end

end