module OrgHandler
  
  def do_create_org(req)
    
    resp = {}
    
    @hasOrg = Org.find_by_name(req['name'])

    unless @hasOrg.nil?
      return [{"error" => "This organization have been created!"}]
    end
    
    @orgType = OrgType.find(req['org_type_id'])
    
    if @orgType.nil?
      return [{"error" => "This organization type is not exist!"}]
    end
    
    @user = User.find_by_email(req['email'])
    
    if @user.nil?
      return [{"error" => "The user #{email} is not exist!"}]
    end
    
    if @user.school_id.nil?
      return [{"error" => "The user #{email}'s school is incomplete"}]
    end
    
    @org = Org.new()
    @org.name = req['name']
    @org.org_type_id = req['org_type_id'].to_i
    @org.org_type_name = @orgType.name
    @org.school_id = @user.school_id
    @org.school_name = @user.school
    @org.chairman = @user.name
    @org.events = 0
    @org.followed = 0
    @org.joined = 0

    if @org.save
    else
      error_msg = ""
      @org.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error" => error_msg}]
    end
    
    @userOrg = UserOrg.new()
    @userOrg.user_id = @user.id
    @userOrg.org_id = @org.id
    @userOrg.role_id = ADMIN_ROLE

    if @userOrg.save
      resp = [@org]
    else
      error_msg = ""
      @org.destroy
      @userOrg.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error" => error_msg}]
    end
    
    return resp
  end
  
  def do_describe_orgs(req)
    @orgs = Org.all
  end
  
  def do_follow_org(req)
    
    @user = User.find_by_email(req['email'])
    @org = Org.find(req['orgId'])
    
    if @org.nil?
      return [{"error"=>"The Org is not exist!"}]
    end
    
    @userOrg = UserOrg.new
    
    @ur = UserOrg.find_by_user_id_and_org_id(@user.id, @org.id)
    
    if @ur.nil?
      @userOrg.user_id = @user.id
      @userOrg.org_id = @org.id
      @userOrg.role_id = FANS_ROLE
    elsif @ur.role_id == FANS_ROLE
      return [{"result"=>"0"}]
    elsif @ur.role_id == MEMBER_ROLE
      return [{"result"=>"0"}]
    elsif @ur.role_id == ADMIN_ROLE
      return [{"result"=>"0"}]
    end

    if @userOrg.save
      @org.followed = @org.followed + 1;
      @org.save
      return [{"result"=>"0"}]
    else
      error_msg = ""
      @userOrg.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error" => error_msg}]
    end
  end

  def do_join_org(req)
    
    @user = User.find_by_email(req['email'])
    @org = Org.find(req['orgId'])
    
    if @org.nil?
      return [{"error"=>"The Org is not exist!"}]
    end
    
    @userOrg = UserOrg.new
    
    @ur = UserOrg.find_by_user_id_and_org_id(@user.id, @org.id)
    
    if @ur.nil?
      @userOrg.user_id = @user.id
      @userOrg.org_id = @org.id
      @userOrg.role_id = MEMBER_ROLE
    elsif @ur.role_id == FANS_ROLE
      @ur.role_id = MEMBER_ROLE            
      if @ur.save
        @org.joined = @org.joined + 1;
        @org.followed = @org.followed - 1;
        @org.save
        return [{"result"=>"0"}]
      else
        error_msg = ""
        @ur.errors.full_messages.each do |msg|
          error_msg = msg
        end
        return [{"error" => error_msg}]
      end
      
    elsif @ur.role_id == MEMBER_ROLE
      return [{"result"=>"0"}]
    elsif @ur.role_id == ADMIN_ROLE
      return [{"result"=>"0"}]
    end

    if @userOrg.save
      @org.joined = @org.joined + 1;
      @org.save
      return [{"result"=>"0"}]
    else
      error_msg = ""
      @userOrg.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error" => error_msg}]
    end
  end
  
  def do_exit_org(req)
    
    @user = User.find_by_email(req['email'])
    @org = Org.find(req['orgId'])
    
    if @org.nil?
      return [{"error"=>"The Org is not exist!"}]
    end
    
    @userOrg = UserOrg.new
    
    @ur = UserOrg.find_by_user_id_and_org_id_and_role_id(@user.id, @org.id,MEMBER_ROLE)
    
    if @ur.nil?
      return [{"error"=>"You don't join this organization!"}]
    elsif @ur.destroy
      @org.joined = @org.joined - 1;
      @org.save
      return [{"result"=>"0"}]
    else
      error_msg = ""
      @ur.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error" => error_msg}]
    end

  end
  
  def do_unfollow_org(req)
    
    @user = User.find_by_email(req['email'])
    @org = Org.find(req['orgId'])
    
    if @org.nil?
      return [{"error"=>"The Org is not exist!"}]
    end
    
    @userOrg = UserOrg.new
    
    @ur = UserOrg.find_by_user_id_and_org_id_and_role_id(@user.id, @org.id,FANS_ROLE)
    
    if @ur.nil?
      return [{"error"=>"You don't follow this organization!"}]
    elsif @ur.destroy
      @org.followed = @org.followed - 1;
      @org.save
      return [{"result"=>"0"}]
    else
      error_msg = ""
      @ur.errors.full_messages.each do |msg|
        error_msg = msg
      end
      return [{"error" => error_msg}]
    end

  end
  
end