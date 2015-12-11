require 'rails_helper'
 
describe StaticPagesController do

  pages = [:home, :about, :help, :contact]
  
  pages.each do |page|

    describe "GET #{page}" do
      it "gets the #{page} page view" do
        get page
        expect(response).to have_http_status(:success)
      end
   
      it "gets the correct view template" do
        get page
        expect(response).to render_template("static_pages/#{page}")
      end

      # it "Renders the correct title" do
      #   get page
      #   expect(response).to have_title("#{page.capitalize} | Ruby on Rails Tutorial Sample App")
      # end
    end
  end

end