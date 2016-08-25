require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  
  def log_in_as(user, options = {})
  	password		= options[:password]		|| 'password'
  	remember_me = options[:remember_me]	|| '1'
  	if defined?(post_via_redirect)
  		post login_path, session: { email:      user.email,
  									              password:   password,
  									              remember_me: remember_me }
		else
			 session[:user_id] = user.id
    end
  end
  
  describe "Unauthenticated Create Requests" do
    it " should not fulfill unauthenticated create requests" do
      expect{ post :create, micropost: { content: "Lorem ipsum" } }.to_not change { Micropost.count }
    end
    
    it "should redirect unauthenticated create requests to the login page" do
      expect( post :create, micropost: { content: "Lorem ipsum" } ).to redirect_to(login_url)
    end
  end
  
  describe "Unauthenticated Create Requests" do
    around do |spec|
      spec_user = User.create(name: "example",
                  email: "example@example.com",
                  password_digest: User.digest('password'),
                  admin: true,
                  activated: true,
                  activated_at: Time.zone.now)
      @example_id = Micropost.create(content: "wat", created_at: 10.minutes.ago, user: spec_user)
      spec.run
      spec_user.destroy
      @example_id.destroy
    end
    
    it "should not fulfill unauthenticated delete requests" do
      expect{ delete :destroy, id: @example_id }.to_not change { Micropost.count }
    end
    
    it "should redirect unauthenticated delete requests to the login page" do
      expect( delete :destroy, id: @example_id ).to redirect_to(login_url)
    end
  end
  
  describe "Unauthorized Delete Requests" do
    
    around do |spec|
      @spec_user = User.create( name: "example",
                                email: "example@example.com",
                                password_digest: User.digest('password'),
                                admin: false,
                                activated: true,
                                activated_at: Time.zone.now)
      other_user = User.create( name: "other",
                                email: "other@example.com",
                                password_digest: User.digest('password'),
                                admin: false,
                                activated: true,
                                activated_at: Time.zone.now)
      @example_id = Micropost.create(content: "wat", created_at: 10.minutes.ago, user: other_user)
      spec.run
      @spec_user.destroy
      other_user.destroy
      @example_id.destroy
    end
    
    it "should not fulfill unauthorized delete requests" do
      log_in_as(@spec_user)
      expect{ delete :destroy, id: @example_id }.to_not change { Micropost.count }
    end
    
    it "should redirect unauthorized delete requests to the home page" do
      log_in_as(@spec_user)
      expect( delete :destroy, id: @example_id ).to redirect_to(root_url)
    end
  end
end