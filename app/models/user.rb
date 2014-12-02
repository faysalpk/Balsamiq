class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, #:rpx_connectable
         :omniauthable, :omniauth_providers => [:facebook, :twitter, :google_oauth2]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :lastname, :provider, :uid
  # attr_accessible :title, :body

  attr_accessible :avatar
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "50x60>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def self.from_omniauth(auth)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    unless user.present?
      email = auth.info.first_name + "@facebook.com"
      user = User.new(:email=>email, :name=>auth.info.name, provider: auth.provider,  uid: auth.uid)
      user.password = user.password_confirmation = "12345678"
      user.save
      return user
    end
      user
   
    return user
    
  end



  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end


  
end

