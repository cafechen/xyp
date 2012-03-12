class EncryptionWrapper

  def before_save(record)
    record.password = Digest::MD5.hexdigest(record.password)
  end
  
end

class User < ActiveRecord::Base
  
  #before_save EncryptionWrapper.new
  
  validates :email, :presence => true, :uniqueness => true
  validates :password, :presence => true

end
