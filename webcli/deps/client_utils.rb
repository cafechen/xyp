require File.dirname(__FILE__) + '/ws_adapter'
require File.dirname(__FILE__) +'/locale'
require File.dirname(__FILE__) +'/resource_bundle'
require 'uri'
require 'time'

##
# Utility class used to organize and format raw data recieved from Web Service
# through ws_adapter
class Client_Utils

  @@bundle_ext_name = ".properties"
  @@file_name = 'message'#'title'
  SEPERATOR = " | "      # between columns in each row
  LINE_TICK = "-"        # forms the line used in seperation i.e. ------------

  # define format functions for each column that should be formatted prior to
  # output. For example: the method format_time() formats the time columns
  FORMATTERS = {
    "create_time" => :format_time,
    "create_date" => :format_time,
    "start_time" => :format_time
  }
  
  GB18030_CONVERT=["tag","desc"]

  ###############################################################
  # print_table
  #
  # outputs a formatted table
  #
  # params: table - an array of hashmaps
  #                 -each entry in array is a row
  #                 -each row is a hashmap of col to value
  #         order - an array of fields to get sizes for
  #    only_order - true if order is the only fields to show
  ###############################################################
  def Client_Utils.print_table(input_table, order = nil, only_order = false)
    #be able to handle the error messages among the table
    #the data in table will be devided into two parts
    #one is error(err) part
    #another one is data part which contains the right data
    out_string = "" # build output as a string
    err_table = []
    table = []
    #check empty
    if input_table.nil? or input_table.empty?
      self.print_msg("inputDataEmpty")
      return 1
    end
    #check if it is array
    if !input_table.kind_of?Array
      self.print_msg("dataFormatWrong")
      return 2
    end

    input_table.each do |item|
      if item["error"] or item["err"]
        err_table << item
      else
        table << item
      end
    end

    if err_table.size > 0
      err_table.each do |item|
        print_reason(item)
      end
      return_code = 3
    end

    #out_string += "\n"
    if table != nil and !table.empty? and table.size > 0
      #order = get_order(table, order, only_order)
      order_new = get_new_order(order)
      sizes = get_column_sizes(table, order_new)

      #print header, and sum table width as we go
      table_width = 0
      order_new.each do |item|
        name = clean_column_name(item["name"])
        out_string += name.center(sizes[item["col"]])
        out_string += SEPERATOR

        # keep running sum of total table width for printing later
        table_width += sizes[item["col"]] + SEPERATOR.length
      end

      # remove trailing SEPERATOR
      table_width -= SEPERATOR.length
      out_string.chomp!(SEPERATOR)
      puts out_string
      out_string = ""
      #out_string += "\n"

      # print out horizonal line of -'s
      out_string += LINE_TICK * table_width
      puts out_string
      out_string = ""
      #out_string += "\n"

      # print each row

      table.each do |row|
        order_new.each do |item|
          formatted_entry = apply_format(item["col"], row[item["col"]])
          #formatted_entry = apply_format(key, row[key])
          out_string += formatted_entry.ljust(sizes[item["col"]])
          out_string += SEPERATOR
        end

        # remove trailing SEPERATOR and add newline to end of row
        out_string.chomp!(SEPERATOR)
        puts out_string
        out_string = ""
        #out_string += "\n"
      end
      return_code = 0
    end
    return(return_code)
    #puts out_string
  end

  ###############################################################
  # get_message
  #
  # get the message string which is used in cli shell script
  #  params:  key -- the message key which is in property file
  #           value -- the value which is required in  message
  #
  ###############################################################

  def self.get_message(key,*value)
    @message = self.load_properties if @message.nil?
    return @message.getString(key,*value)
  end

  ###############################################################
  # print_msg
  #
  # print the validation message
  #
  # params:   key -- string which consists with the key in validation_message.properties
  #           value -- string the value which will be printed
  #
  ###############################################################
  def Client_Utils.print_msg(key,*value)
    @message = self.load_properties if @message.nil?
    capital = "\n"
    key = key.gsub("-","_")
    if key.include?("error")
      capital = @message.getString("error",*value) + ":\x20"
    end
    msg = capital
    msg << @message.getString(key,*value)
    msg << "\n"
    puts msg
  end

  ###############################################################
  # print_reason
  #
  # print the error message from  web service
  #
  # params:    error_hash -- Hash, resp.first
  #
  ###############################################################
  def self.print_reason(error_hash)
    @message = self.load_properties if @message.nil?
    @error_msg = self.load_properties("error") if @error_msg.nil?
    if !error_hash["error"].nil?
      error = error_hash["error"]
    else
      error = error_hash["err"]
    end
    error_code = error_hash["error_code"]
    error_params = error_hash["error_parameters"]
    if !error.nil?
      reason = @message.getString("reason")+":\x20"
      out_string = @error_msg.getString(error_code,*error_params)
      if out_string.nil? || out_string.empty? || error_code.eql?('ErrorMessage')
        out_string = error
      end
      # support GB18030
      Client_Utils.decode_output(out_string)

      reason << out_string + "\n"
      puts reason
    end
  end

  ###############################################################
  # generate_usage
  #
  # generate usage information based on the command full description
  #
  #command_desc={"cmd"=>"describe-group",
  #             "opts"=> { "group_ids"=>["g",2,""]}
  #}
  # params: command_desc -- including the command name and the options
  #            {"cmd"=>"allocate-address"
  #             "opts"=> { "group_id"=>["g",2,""]} # 1 indicates required,2 indicates optional
  #                      "description"=>["d",1,"description_group"]}
  #               if there is a rename of option name, please set it in the third
  # return: String --- the usage output
  #     USAGE="USAGE: ws-register-image [OPTIONS...]\n"+
  #       "-i, --image  image id\n"+
  #       "-t, --type,  type of image, image|kernel|ramdisk\n"+
  #       "-a, --arch,   image arch, i386|x86_64\n"
  ###############################################################

  def self.generate_usage(command_desc)
    @message = self.load_properties if @message.nil?
    usage = ""
    usage << @message.getString("usage")
    usage << ":\x20" +"ws-" +command_desc["cmd"] + "\x20"
    req_help=""
    opts_help=""
    note_help="\x20"
    opts = command_desc["opts"]
    if !opts.nil?
      opts.each do |key,value|
        help = @message.getString(key)
        if !value[2].empty?
          help=@message.getString(value[2])
        end
        if !value[3].nil?
          note_help << @message.getString(value[3])+"\n"
        end

        if !value[0].empty?
          if value[1].eql?(1)  # required arguement
            req_help << "-"+value[0]+"\x20"+"<"+help+">"+"\x20"
          elsif value[1].eql?(2) # option argument
            opts_help << "[-"+value[0]+"\x20"+"<"+help+">"+"\x20]"
          elsif value[1].eql?(0)
            opts_help << "[-"+value[0]+"]"
          end
        else
          if value[1].eql?(1)
            req_help << "<"+help+">"+"\x20"
          elsif value[1].eql?(2)
            req_help << "["+help+"]"+"\x20"
          end
        end

        #usage << "-"+key+",\x20"+"--"+value[0]+"\t"+help+"\n"
      end
    end
    opts_help << "\n"

    usage << req_help + opts_help

    usage << note_help + "\n"

    return usage
  end

  ###############################################################
  # get_column_sizes
  #
  # gets the smallest size for each column
  # such that each field still fits
  #
  # params: table - an array of hashmaps
  #                 -each entry in array is a row
  #                 -each row is a hashmap of col to value
  #         order - an array of fields to get sizes for
  ###############################################################
  def Client_Utils.get_column_sizes(table, order)
    #determine column sizes
    sizes = Hash.new

    #initialize sizes to length of each column name
    order.each do |item|
      clean = clean_column_name(item["name"])
      sizes[item["col"]] = clean.length
    end

    # check to see if there's a longer field for any column in the table
    # if so, update the sizes hash to the longer field's length
    table.each do |row|
      row.each do |col, value|
        formatted = apply_format(col, value)
        if sizes[col] == nil or sizes[col] < formatted.length
          sizes[col] = formatted.length
        end
      end
    end

    return sizes
  end

  ###############################################################
  # clean_column_name
  #
  # cleans column names up from the way the webservice responds to the way
  # they are dispayed to the user.
  # COLNAME_REPLACEMENTS is defined in config.rb
  #
  # params: the column name to clean
  # output: returns the clean column
  ###############################################################
  def Client_Utils.clean_column_name(name)

    clean = name.to_s
    COLNAME_REPLACEMENTS.each do |key, value|
      clean.sub!(key, value)
    end

    return clean
  end

  ###############################################################
  # apply_format
  #
  # applies any format methods for a particular column
  #
  # params:   col - the column name
  #           str - the str that exists in the column
  #
  # output:   The formatted string if a formatter exists for
  # that column, otherwise just return the original str
  ###############################################################
  def Client_Utils.apply_format(col, str)
    if FORMATTERS[col] != nil
      response = Client_Utils.send(FORMATTERS[col], str)
      return response.to_s
    else # no format for this str
      # make the specific key-value support GB18030
      if Client_Utils.is_converted(col) && str.is_a?(String)
        str = Client_Utils.decode_output(str)
      end
      if str.is_a?(Hash)
        response = ""
        str.each do |key, value|
          response = response + "#{key}=#{value} "
        end
        return response
      else
        if str.is_a?(Array)
          return str.join(", ")
        else
          return str.to_s
        end
      end
    end
  end

  #################
  # formatters
  #################

  ###############################################################
  # format_time
  #
  # formats time columns
  #
  # formats the time to a more human readable format
  ###############################################################
  def Client_Utils.format_time(str)
    begin
      time_reg = /(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})/
      if str.to_s.match(time_reg)
        t = Time.iso8601(str)
        return t.localtime.to_s
      else
        return str.to_s
      end
    rescue # if time can't parse just return original str
      return str.to_s
    end

  end

  ###############################################################
  # get_locale
  # get the locale based on the environment variable "LANG"
  #
  ###############################################################
  def self.get_locale()
    lang = %x[echo $LANG]
    if lang.nil? or lang == ''
      return Locale.new()
    else
      locale=lang.split(".")[0]
      return Locale.new(locale.split("_")[0],locale.split("_")[1])
    end
  end

  ###############################################################
  # load_properties
  #
  # load property files
  #
  # params: filename -- the file name which excludes the extent name
  #
  ###############################################################
  def self.load_properties(filename=nil)
    if filename.nil?
      filename=@@file_name
    end
    locale = self.get_locale()
    message = File.join(File.dirname(__FILE__),"/../resources/",filename)
    bundle = ResourceBundle.getBundle(message, locale)
    return bundle
  end

  def Client_Utils.get_new_order(order)
    @message=Client_Utils.load_properties if @message.nil?
    order_new = []
    if order == nil or order.empty?
      self.print_msg("notClearTableOrder")
      #puts "ERROR: Didn't clear table order"
      exit(1)
    else
      order.each do |item|
        item_new = {}
        item_new["col"] = item["col"]
        item_new["name"] = @message.getString(item["name"])
        order_new<<item_new
      end
    end
    return order_new
  end

  ###############################################################
  # is_converted
  #
  # Judge whether the column should be decoded to support GB18030
  #
  # the should-be columns are contained in GB18030_CONVERT
  ###############################################################
  def Client_Utils.is_converted(key)
    if key != nil
      GB18030_CONVERT.each do |item|
        if key.include?(item)
          return true
        end
      end
    end
    return false
  end

  ###############################################################
  # decode_output
  #
  # decode the value which is encoded by URI.encode()
  #
  # value: String
  ###############################################################
  def Client_Utils.decode_output(value)
    if value != nil && value.kind_of?(String)
      return URI.decode(value)
    else
      return value
    end
  end

  ###############################################################
  # encode_output
  #
  # encode the value which should support GB18030
  #
  # value : String
  ###############################################################
  def Client_Utils.encode_input(value)
    if value != nil && value.kind_of?(String)
      return URI.encode(value)
    else
      return value
    end
  end

  ###############################################################
  # get_order
  #
  # fills out the order array from the parameters passed in to the class.
  # basically just unions the list of fields in order array with the list of
  # fields that show up in the table. this way all fields in the table are
  # represented, but the order fields will be displayed first
  #
  # params: table - an array of hashmaps
  #                 -each entry in array is a row
  #                 -each row is a hashmap of col to value
  #         order - an array of fields to get sizes for
  #    only_order - true if order is the only fields to show
  ###############################################################
  def Client_Utils.get_order(table, order = nil, only_order = false)
    # fill with other values from table if required
    if table != nil
      if !only_order
        if order == nil then
          order = table[0].keys
        else
          order = order | table[0].keys
        end
      end
    end

    return order
  end

  # Get values for key from a table
  def Client_Utils.get_values(table, key)
    if table.nil? or !table.is_a?(Array)
      return nil
    end

    result = Array.new()
    table.each do | row |
      result << row[key] if row[key] != nil
    end

    return result.uniq
  end

  #################################
  def Client_Utils.load_property(file_path=nil)
    if file_path!=nil and @prop.nil?
      @prop = Property.new(file_path)
    else
      lang = %x[echo $LANG]
      if lang.nil? or lang == ''
        locale = ''
      else
        locale = lang.split(".")[0]
      end
      file_path = File.join(File.dirname(__FILE__),"#{@@file_name}_#{locale}#{@@bundle_ext_name}")
      unless FileTest.exist? file_path then
        # If property file of the locale is not exit, then use default
        file_path = File.join(File.dirname(__FILE__),"#{@@file_name}#{@@bundle_ext_name}")
      end
      unless FileTest.exist? file_path then
        raise "PropertyFileNotFound"
        #raise {'error_code'=>"PropertyFileNotFound",'error_parameters'=>[],'error'=>"The property file #{file_path} not found!"}.to_s
      end
      @prop = Property.new(file_path)
    end
  end

end

