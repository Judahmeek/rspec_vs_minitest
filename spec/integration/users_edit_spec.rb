require 'rails_helper'

RSpec.describe "Users Edit", type: :request do
	fixtures :users

	let(:let_user) {users(:michael)}

	it "unsuccessful edit" do
		log_in_as(let_user)
		get edit_user_path(let_user)
		expect(response).to render_template( :edit )
		patch user_path(let_user), user: {name:  "",
																			email: "foo@invalid",
																			password: 			   "foo",
																			password_confirmation: "bar" }
		expect(response).to render_template( :edit )
	end

	it "successful edit" do
		log_in_as(let_user)
		get edit_user_path(let_user)
		expect(response).to render_template( :edit )
		name  = "Foo Bar"
		email = "foo@bar.com"
		patch user_path(let_user), user: {name:  name,
																			email: email,
																			password: 			   "",
																			password_confirmation: "" }
		expect( flash.empty? ).to be_falsy
		expect(response).to redirect_to( let_user )
		let_user.reload
		expect( name ).to eql(	let_user.name )
		expect( email).to eql( let_user.email )
	end

	it "successful edit with friendly forwarding" do
		get edit_user_path(let_user)
		expect( session[:forwarding_url] ).to eql( edit_user_url(let_user) )
		log_in_as(let_user)
		expect( session[:forwarding_url] ).to be_nil
		expect(response).to redirect_to( edit_user_path(let_user) )
		name = "Foo Bar"
		email = "foo@bar.com"
		patch user_path(let_user), user: { name:  name,
																		email: email,
																		password:              "",
																		password_confirmation: "" }
		expect( flash.empty? ).to be_falsy
		expect(response).to redirect_to( let_user )
		let_user.reload
		expect( name ).to eql(	let_user.name )
		expect( email).to eql( let_user.email )
	end

end