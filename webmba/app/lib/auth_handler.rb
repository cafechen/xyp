# aggregates all of the privileges
module AuthHandler

  def isUserHasPrivilege(email, password, cmd)
    result = false
    if get_passer_privilege_ids.include? cmd
      return true
    else
      if email == ADMIN_USER
        @user = User.find_by_email(email)
        if !@user.nil? and @user.password == password and get_admin_privilege_ids.include? cmd
          result = true
        end
      else 
        @user = User.find_by_email(email)
        if !@user.nil? and @user.password == password and get_user_privilege_ids.include? cmd
          result = true
        end
      end
    end
    return result
  end

  def get_passer_privilege_ids()
    result = [
      "do_register_user",
      "do_describe_events",
      "do_describe_schools",
      "do_describe_user_by_mobile",
      "do_describe_user"
    ]
  end

  def get_user_privilege_ids()
    result = [
      "do_describe_users",
      "do_describe_roles",
      "do_describe_orgtypes",
      "do_create_org",
      "do_describe_orgs",
      "do_follow_event",
      "do_join_event",
      "do_follow_org",
      "do_join_org",
      "do_create_event",
      "do_describe_events",
      "do_describe_schools",
      "do_describe_user_by_mobile",
      "do_exit_event",
      "do_unfollow_event",
      "do_exit_org",
      "do_unfollow_org",
      "do_create_event",
      "do_describe_user"
    ]
  end

  def get_admin_privilege_ids()
    result = [
      "do_describe_users",
      "do_create_users",
      "do_delete_users",
      "do_describe_orgtypes",
      "do_create_orgtype",
      "do_delete_orgtype",
      "do_describe_roles",
      "do_create_role",
      "do_delete_role",
      "do_create_org",
      "do_describe_orgs",
      "do_create_eventtype",
      "do_delete_eventtype",
      "do_describe_eventtypes",
      "do_create_school",
      "do_delete_school",
      "do_describe_schools",
      "do_create_event",
      "do_delete_event",
      "do_describe_events",
      "do_follow_event",
      "do_join_event",
      "do_follow_org",
      "do_join_org",
      "do_describe_user_by_mobile",
      "do_exit_event",
      "do_unfollow_event",
      "do_exit_org",
      "do_unfollow_org",
      "do_describe_user"

    ]
  end
  
end
