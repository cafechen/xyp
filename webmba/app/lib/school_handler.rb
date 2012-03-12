module SchoolHandler
  
  def do_create_school(req)
    resp = {}
    @school = School.new()
    @school.school_name = req['schoolName']
    if @school.save
      resp = [@school]
    else
      error_msg = ""
      @school.errors.full_messages.each do |msg|
        error_msg = msg
      end
      resp = [{"error" => error_msg}]
    end
    return resp
  end
  
  def do_delete_school(req)
    @school = School.find(req['schoolId'].to_i)
    if @school.destroy
      resp = [{"result"=>"deleted"}]
    else
      error_msg = ""
      @school.errors.full_messages.each do |msg|
        error_msg = msg
      end
      resp = [{"error"=> error_msg}]
    end
    return resp
  end
  
  def do_describe_schools(req)
    @schools = School.all
    resp = []
    @schools.each do |school|
      resp << {
        "schoolId" => school.id,
        "schoolName" => school.school_name
      }    
    end
    return resp
  end
 
end
