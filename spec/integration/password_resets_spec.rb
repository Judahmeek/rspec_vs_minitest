require 'rails_helper'

RSpec.describe "Password Resets", type: :request do
  fixtures :users

  let(:let_user) {users(:michael)}
  
  before(:each) {ActionMailer::Base.deliveries.clear}

	it "password resets" do
		get new_password_reset_path
		expect(response).to render_template(:new)
		# Invalid email
		post password_resets_path, password_reset: { email: "" }
		expect( flash.empty? ).to be_falsy
		expect(response).to render_template(:new)
		# Valid email
		post password_resets_path, password_reset: { email: let_user.email }
		expect( let_user.reset_digest ).to_not eql(let_user.reload.reset_digest)
		expect( ActionMailer::Base.deliveries.size ).to eql(1)
		expect( flash.empty? ).to be_falsy
		expect(response).to redirect_to( root_url )
		# Password reset form
		user = assigns(:user)
		# Wrong email
		get edit_password_reset_path(user.reset_token, email: "")
		expect(response).to redirect_to( root_url )
		# Inactive user
		user.toggle!(:activated)
		get edit_password_reset_path(user.reset_token, email: user.email)
		expect(response).to redirect_to( root_url )
		user.toggle!(:activated)
		# Right email, wrong token
		get edit_password_reset_path('wrong token', email: user.email)
		expect(response).to redirect_to( root_url )
		# Right email, right token
		get edit_password_reset_path(user.reset_token, email: user.email)
		expect(response).to render_template(:edit)
		expect(response.body).to match('<input type="hidden" name="email" id="email" value="' + user.email + '" />')
		# Invalid password & confirmation
		patch password_reset_path(user.reset_token),
					email: user.email,
					user: { password:								"foobar",
									password_confirmation:	"barquux" }
		expect(response.body).to include('id="error_explanation"')
		# Empty password
		patch password_reset_path(user.reset_token),
					email: user.email,
					user: { password:								"",
									password_confirmation:  "" }
		expect(response.body).to include('id="error_explanation"')
		# Valid password & confirmation
		patch password_reset_path(user.reset_token),
					email: user.email,
					user: { password:								"foobaz",
									password_confirmation:  "foobaz" }
		expect( is_logged_in? ).to be_truthy
		expect( flash.empty? ).to be_falsy
		expect(response).to redirect_to( user )
	end

	it "expired token" do
		get new_password_reset_path
		post password_resets_path, password_reset: { email: let_user.email }

		user = assigns(:user)
		user.update_attribute(:reset_sent_at, 3.hours.ago)
		patch password_reset_path(user.reset_token),
					email: user.email,
					user: { password:								"foobar",
									password_confirmation:	"foobar" }
		expect( response ).to have_http_status(:redirect)
		follow_redirect!
		expect( response.body ).to match(/expired/i)
	end

end