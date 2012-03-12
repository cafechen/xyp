class Property
  #attr_reader :filename,:values
  
  # Analysis and load the java properties files
  # [file_name] the file name of property.
  def initialize(file_name)
    #it is a hash table used to store the values.
    @values = {}
    i_file = File.new(file_name, "r")
    i_file.each_line do |line|
      param = line.split("=")
      if param.size >= 2
        key = param[0].gsub(/[\r\n\t]/,'')
        value = param[1].gsub(/[\r\n\t]/,'')
        key = key.strip
        value = value.strip
        @values["#{key}"] = value
      end
    end
    i_file.close
  end
  
  # get value by key
  # [key] the key of value
  def getValue(key)
    return @values[key]
  end
  
  # get all message keys
  def keys
    @values.keys
  end
end