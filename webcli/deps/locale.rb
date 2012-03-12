class Locale
  attr_reader :language,:country
  
  #[language] specify a language code
  #[country] specify a country code
  def initialize(language=nil,country=nil)
    @language = language
    @country = country
  end 
end
