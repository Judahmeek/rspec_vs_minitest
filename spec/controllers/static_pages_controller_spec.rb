require 'rails_helper'
 
describe StaticPagesController do
  describe "GET home" do
    it "gets the homepage view" do
      get "home"
      expect(response.status).to be 200
    end
 
    it "gets the correct view template" do
      get "home"
      expect(response).to render_template("static_pages/home")
    end
  end
end