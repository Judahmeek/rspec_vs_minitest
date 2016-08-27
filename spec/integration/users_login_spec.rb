require 'rails_helper'

RSpec.describe "User Login", type: :request do
  fixtures :users

  let(:let_user) { users(:michael) }

  it "login with invalid information" do
    get login_path
    expect(response).to render_template( 'sessions/new' )
    post login_path, session: { email: "", password: "" }
    expect(response).to render_template( 'sessions/new' )
    expect( flash.empty? ).to be_falsy
    get root_path
    expect( flash.empty? ).to be_truthy
  end
  
  it "login with valid information" do
    get login_path
    post login_path, session: { email: let_user.email, password: 'password' }
    expect( is_logged_in? ).to be_truthy
    expect(response).to redirect_to( let_user )
    follow_redirect!
    expect(response).to render_template( 'users/show' )
		expect(response.body).to_not include("href=\"#{ login_path }\"")
		expect(response.body).to include("href=\"#{ logout_path }\"")
		expect(response.body).to include("href=\"#{ user_path(let_user) }\"")
    delete logout_path
    expect( is_logged_in? ).to be_falsy
    expect(response).to redirect_to( root_url )
    # Simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
		expect(response.body).to include("href=\"#{ login_path }\"")
		expect(response.body).to_not include("href=\"#{ logout_path }\"")
		expect(response.body).to_not include("href=\"#{ user_path(let_user) }\"")
  end

  it "login with remembering" do
    log_in_as(let_user, remember_me: '1')
    expect( let_user.id ).to eql( assigns(:user).id )
  end

  it "login without remembering" do
    log_in_as(let_user, remember_me: '0')
    expect( cookies['remember_token'] ).to be_nil
  end
  
end
