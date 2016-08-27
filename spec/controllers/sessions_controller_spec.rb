require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
	it "should respond to /get  with a 200 status code" do
		get :new
		expect(response).to have_http_status(200)
  end
end