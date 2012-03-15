module UserHandler
  
  def do_describe_users(req)
    if req['email'].nil? or req['email'].empty?
      @users = User.all
    else
      @users = User.all
    end
    return @users
  end

  def do_describe_user_by_mobile(req)

    if req['mobile'].nil? or req['mobile'].empty?
			return [{"error"=>"You don't provide mobile parameter!"}]	
    end

		@user = KnownUser.find_by_mobile(req['mobile'])
    if @user.nil?
			return [{"error"=>"The user is not in known users"}]
		end

    return [@user]
  end
  
  def do_describe_user(req)
    
    @user = User.find_by_email(req['email'])
        
    resp = @user.serializable_hash
    
    if req['getEvents'] != nil and req['getEvents'] == "true"
      unless @user.nil?
        @follows = Event.find_by_sql("select events.* from events left join user_events on events.id = user_events.id where user_events.user_id = #{@user.id} and user_events.status = #{FOLLOW_EVENT}")
        @joins = Event.find_by_sql("select events.* from events left join user_events on events.id = user_events.id where user_events.user_id = #{@user.id} and user_events.status = #{JOIN_EVENT}")  
        resp['follow_events'] = @follows
        resp['join_events'] = @joins
      end
    end

    return [resp]
  end
  
  def do_create_users(req)
    
    resp = []
    
    req['users'].each do |user|
      ret = do_create_user(user)
      resp.push(ret)
    end
    
    return resp
    
  end
  
  def do_create_user(user)
    resp = {}
    @user = User.new()
    @user.email = user['email']
    @user.password = user['password']
    @user.name = user['name']
    @user.mobile = user['mobile']
    if @user.save
      resp = @user
    else
      error_msg = ""
      @user.errors.full_messages.each do |msg|
        error_msg = msg
      end
      resp = {"error" => error_msg}
    end
    return resp
  end
  
  def do_register_user(user)
    resp = {}
    
    @user = User.new()
    @user.email = user['email']
    @user.password = user['password']
    @user.name = user['name']
    @user.mobile = user['mobile'] unless user['mobile'].nil?
    @user.workstate = user['workstate'] unless user['workstate'].nil?
    @user.school = user['school'] unless user['school'].nil?
    @user.company = user['company'] unless user['company'].nil?
    @user.title = user['title'] unless user['title'].nil?
    @user.intro = user['intro'] unless user['intro'].nil?
    
    unless @user.school.nil? or @user.school.empty?
      @school = School.find_by_name(@user.school)
      if @user.school.nil? == false and @school.nil?
        @school = School.new
        @school.name = @user.school
        unless @school.save
          error_msg = ""
          @school.errors.full_messages.each do |msg|
            error_msg = msg
          end
          resp = [{"error" => error_msg}]
        end
      end
      @user.school_id = @school.id ;
    end
    
    unless @user.company.nil? or @user.company.empty?
      @company = Company.find_by_name(@user.company) unless @user.company.nil?
      if @user.company.nil? == false and @company.nil?
        @company = Company.new
        @company.name = @user.company
        unless @company.save
          error_msg = ""
          @company.errors.full_messages.each do |msg|
            error_msg = msg
          end
          resp = [{"error" => error_msg}]
        end
      end
      @user.company_id = @company.id
    end

    unless @user.title.nil? or @user.title.empty?
      @title = Title.find_by_name(@user.title) unless @user.title.nil?
      if @user.title.nil? == false and @title.nil?
        @title = Title.new
        @title.name = @user.title
        unless @title.save
          error_msg = ""
          @title.errors.full_messages.each do |msg|
            error_msg = msg
          end
          resp = [{"error" => error_msg}]
        end
      end
      @user.title_id = @title.id
    end

    if @user.save
       return [@user]
    else
      error_msg = ""
      @user.errors.full_messages.each do |msg|
        error_msg = msg
      end
      resp = [{"error" => error_msg}]
    end
    return resp
  end
  
  def do_delete_users(req)

    resp = []
    
    req['email'].each do |email|
      ret = do_delete_user(email)
      resp.push(ret)
    end
    
    return resp
    
  end
  
  def do_delete_user(email)
    @user = User.find_by_email(email)
    if @user.destroy
      resp = {"result"=>"deleted"}
    else
      error_msg = ""
      @user.errors.full_messages.each do |msg|
        error_msg = msg
      end
      resp = {"error" => error_msg}
    end
    return resp
  end

end
