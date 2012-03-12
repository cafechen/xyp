require File.expand_path('../../lib/orgtype_handler', __FILE__)
require File.expand_path('../../lib/user_handler', __FILE__)
require File.expand_path('../../lib/role_handler', __FILE__)
require File.expand_path('../../lib/org_handler', __FILE__)
require File.expand_path('../../lib/eventtype_handler', __FILE__)
require File.expand_path('../../lib/school_handler', __FILE__)
require File.expand_path('../../lib/auth_handler', __FILE__)
require File.expand_path('../../lib/event_handler', __FILE__)

class WebController < ApplicationController
  
  include UserHandler
  include OrgTypeHandler
  include EventTypeHandler
  include EventHandler
  include RoleHandler
  include OrgHandler
  include AuthHandler
  include SchoolHandler

  def index
    @events = do_describe_events(nil)
    @orgs = do_describe_orgs(nil)
  end
  
  def home
    require_login
    req = {
      "email" => cookies[:email],
      "getEvents" => "true"
    }
    @user = do_describe_user(req)[0]
  end
  
  def login
    
  end
  
  def create_org
    @org = Org.new
  end
  
  def logout
    cookies.delete :userid
    cookies.delete :username
    cookies.delete :email
    redirect_to :controller => "web",:action => "home"
  end
  
  def register
    
  end
  
  def ejoin
    require_login
    req = {
      "eventId" => params['eventId'],
      "email" => cookies[:email]
    }
    do_join_event(req)
    redirect_to :controller => "web",:action => "home"
  end

  def efollow
    require_login    
    req = {
      "eventId" => params['eventId'],
      "email" => cookies[:email]
    }
    do_follow_event(req)
    redirect_to :controller => "web",:action => "home"
  end
  
  def ojoin
    require_login
    req = {
      "orgId" => params['orgId'],
      "email" => cookies[:email]
    }
    do_join_org(req)
    redirect_to :controller => "web",:action => "home"
  end
  
  def ofollow
    require_login    
    req = {
      "orgId" => params['orgId'],
      "email" => cookies[:email]
    }
    do_follow_org(req)
    redirect_to :controller => "web",:action => "home"  
  end 
  
  def submit
    
    if params['cmd'].nil? 
      redirect_to :controller => "web",:action => "home"
    end
    
    begin
      
      method = "post_" + params['cmd']            
      self.send(method, params)
      
    rescue NoMethodError => e
      @@logger.error(e)
      redirect_to :controller => "web",:action => "home"
    rescue => ex
      @@logger.error(ex)
      redirect_to :controller => "web",:action => "home"
    end
    
  end   
  
  def post_login(params)
    email = params[:user][:email]
    pwd = Digest::MD5.hexdigest(params[:user][:password])
    
    @user = User.find(:all,:conditions =>['email = ? and password = ?',email,pwd])
    
    unless @user.empty?
      cookies[:userid] = @user[0].id
      cookies[:username] = @user[0].name
      cookies[:email] = @user[0].email
      flash[:notice] = '登陆成功.'
      redirect_to :controller => "web",:action => "home"  
    else
      flash[:notice] = '登陆失败.'
      redirect_to :controller => "web",:action => "login"
    end
  end
  
  def require_login
    unless logged_in?
      flash[:error] = "请先登录"
      redirect_to :controller => "web",:action => "login"
    end
  end
  
  def logged_in?
    if cookies[:userid].nil?
      return false
    end
    return true
  end
    
end
