require 'rails_helper'

RSpec.describe UsersController, type: :controller do
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
  
  around do |spec|
    @spec_user = User.create( name: "example",
                              email: "example@example.com",
                              password_digest: User.digest('password'),
                              admin: true,
                              activated: true,
                              activated_at: Time.zone.now)
    spec.run
    @spec_user.destroy
  end
  
  it "should let users log in" do
    log_in_as(@spec_user)
    expect(subject.current_user).to eq(@spec_user)
  end
end