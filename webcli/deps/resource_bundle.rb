
require File.dirname(__FILE__) + '/locale'
require File.dirname(__FILE__) + '/property'
require 'cgi'
require 'iconv'

class ResourceBundle
  @@bundle_ext_name = ".properties"
  
  attr_reader :bundle_name,:locale,:bundle_file,:prop
  # [bundle_name] bundle's name, for example: messages.
  # [locale] The locale provide the language and country.
  def initialize(bundle_name, locale)
    @locale = locale
    @bundle_name = bundle_name
    @bundle_file = @bundle_name
    
    unless locale.nil? || locale.language.nil? || locale.country.nil?
      # java message bundle convention
      @bundle_file = "#{@bundle_name}_#{@locale.language}_#{@locale.country}"
    end    
    @bundle_file = @bundle_file + @@bundle_ext_name
    
    unless FileTest.exist? @bundle_file then
      # some property file name only contain the language not country 
      @bundle_file = "#{@bundle_name}_#{@locale.language}"
      @bundle_file = @bundle_file + @@bundle_ext_name
      unless FileTest.exist? @bundle_file then
        # If property file of the locale is not exit, then use default
        @bundle_file = @bundle_name + @@bundle_ext_name
        unless FileTest.exist? @bundle_file
          raise "No property file for #{@bundle_name}"
        end        
      end
      
    end
    
    @prop = Property.new(bundle_file)
  end
  
  # Class method for create an object of ResourceBundle
  def self.getBundle(bundle_name, locale)
    return ResourceBundle.new(bundle_name, locale)
  end
  
  # Get value by key
  def getString(key, *values)
    fmt = prop.getValue(key) rescue ""
    if fmt.nil? or fmt.empty? 
      return key
    end
    # str = sprintf(fmt, *values) rescue fmt    
    str = fmt
    i = 1
    parameters = *values
    parameters = [parameters] if parameters.class != Array
    parameters.each do |parameter|
      str = str.gsub(/%#{i}s/,parameter.to_s)
      i+=1
    end
    # delete the %1s,%2s, when the parameter is nil
    str = str.gsub(/%\ds/, "")
    # decoding from utf-8 java to utf-8 ruby
    str = utf8fj_to_utf8fr(str) 
    return str
  end
  
  def getValue(key)
    return prop.getValue(key)
  end
  
  def getKeys
    return prop.keys
  end
  
  # This function is to decode the utf-8 string which is encoded in java 
  #  and return them as utf-8 encoding in ruby
  # parse the utf-8 encoding string to ruby readable string
  # parameters:   str = \u76ee\u6807
  # returns :     目标
  #
  def utf8fj_to_utf8fr(str)    
    # replace \u by %u  
    result = ""
    if !str.nil?
      str = str.gsub(/\\u/,"%u$$$")# use "$$$" to indicate that this is a utf-8 encoding character
      tokens = str.split("%u")
      # remove the first one if the first token is empty
      first_is = false # it would indicate whether the first character is utf-8 or not
       (tokens.shift;first_is=true) if tokens.first.empty?
      
      
      tokens.each do |token|       
        # match whether it is really a utf-8 string      
        if !token.match(/[$]{3}[A-Fa-f0-9]{4}.*/).nil?        
          token = token.sub("$$$","") # use "$$$" to indicate that this is a utf-8 encoding character
          p=token 
          original4=p[0,4] 
          changed=token[0,4] 
          changed.insert(0,'%') 
          changed.insert(3,'%')       
          changed=CGI.unescape(changed) 
          changed=Iconv.conv("UTF-8","unicodebig",changed)        
          token.sub!(original4,changed) 
          result+=token   
        else # it is not the utf-8 string     
          if first_is == false # the first token 
            result += token
          else # if not, we need to return the string back, like \u34 should display \u34
            result += "\\u"+token
          end
        end # if !token          
      end # tokens.each       
    end # if !str.nil?
    
    return result  
  end  
  
end