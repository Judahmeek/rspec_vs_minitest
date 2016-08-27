require 'rails_helper'

RSpec.describe "Site Layout", type: :request do
  fixtures :users

	let(:let_user) {users(:michael)} #this spec really should be a view spec, not a request spec

  it "layout links - not logged in" do
    get root_path
    assert_template 'static_pages/home'
    expect( response.body ).to match(/[href="#{root_path}"]{2}/)
		[help_path, login_path, about_path, contact_path].each do |path|
		  expect(response.body).to include("href=\"#{path}\"")
		end
  end

  it "layout links - logged in" do
  	log_in_as(let_user)
    get root_path
    assert_template 'static_pages/home'
    expect( response.body ).to match(/[href="#{root_path}"]{2}/)
    expect( response.body ).to include("href=\"#{help_path}\"")
    # Logged in specific links
		[users_path, user_path(let_user), edit_user_path(let_user), logout_path, about_path, contact_path].each do |path|
		  expect(response.body).to include("href=\"#{path}\"")
		end
  end

end