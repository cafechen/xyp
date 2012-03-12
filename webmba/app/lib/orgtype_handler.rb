module OrgTypeHandler
  
  def do_create_orgtype(req)
    resp = {}
    @orgType = OrgType.new()
    @orgType.name = req['name']
    if @orgType.save
      resp = [@orgType]
    else
      error_msg = ""
      @orgType.errors.full_messages.each do |msg|
        error_msg = msg
      end
      resp = [{"error" => error_msg}]
    end
    return resp
  end
  
  def do_delete_orgtype(req)
    @OrgType = OrgType.find(req['orgTypeId'].to_i)
    if @OrgType.destroy
      resp = [{"result"=>"deleted"}]
    else
      error_msg = ""
      @orgType.errors.full_messages.each do |msg|
        error_msg = msg
      end
      resp = [{"error"=> error_msg}]
    end
    return resp
  end
  
  def do_describe_orgtypes(req)
    OrgType.all
  end
  
end