module RoleHandler
  
  def do_create_role(req)
    resp = {}
    @role = Role.new()
    @role.name = req['name']
    @role.role_type = req['role_type'].to_i
    if @role.save
      resp = [@role]
    else
      error_msg = ""
      @role.errors.full_messages.each do |msg|
        error_msg = msg
      end
      resp = [{"error" => error_msg}]
    end
    return resp
  end
  
  def do_delete_role(req)
    @role = Role.find(req['roleId'].to_i)
    if @role.destroy
      resp = [{"result"=>"deleted"}]
    else
      error_msg = ""
      @role.errors.full_messages.each do |msg|
        error_msg = msg
      end
      resp = [{"error"=> error_msg}]
    end
    return resp
  end
  
  def do_describe_roles(req)
    Role.all
  end
end