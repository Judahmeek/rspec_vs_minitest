require 'rails_helper'

RSpec.describe "User Signup", type: :request do

	before(:each) { ActionMailer::Base.deliveries.clear }

	it "invalid signup information" do
		get signup_path
		expect { post users_path, user:  { name: 	"",
																			email: 	"user@invalid",
																			password: 							"foo",
																			password_confirmation: 	"bar" } }.to_not change { User.count }
		expect(response).to render_template( 'users/new' )
		expect(response.body).to include('id="error_explanation"')
		expect(response.body).to include('class="field_with_errors"')
	end

	it "valid signup information with account activation" do
		get signup_path
		expect { post users_path, user:  { name:  "Example User",
																email: "user@example.com",
																password: 							"password",
																password_confirmation: 	"password" } }.to change { User.count }.by(1)
		expect( ActionMailer::Base.deliveries.size ).to eql(1)
		user = assigns(:user)
		expect( user.activated? ).to be_falsy
		# Try to log in before activation
		log_in_as(user)
		expect( is_logged_in? ).to be_falsy
		# Invalid activation token
		get edit_account_activation_path("invalid token")
		expect( is_logged_in? ).to be_falsy
		# Valid activation token
		get edit_account_activation_path(user.activation_token, email: user.email)
		expect( user.reload.activated? ).to be_truthy
		follow_redirect!
		expect(response).to render_template( 'users/show' )
		expect( is_logged_in? ).to be_truthy
	end

end
