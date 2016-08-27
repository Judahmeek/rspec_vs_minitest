require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
	fixtures :users, :relationships
	
	describe "Unauthenticated Create Requests" do

		it " should not fulfill unauthenticated create requests" do
			expect{ post :create, id: users(:michael) }.to_not change { Micropost.count }
		end
		
		it "should redirect unauthenticated create requests to the login page" do
			expect( post :create, id: users(:michael) ).to redirect_to(login_url)
		end
	end

	describe "Unauthenticated Delete Requests" do
		
		it "should not fulfill unauthenticated delete requests" do
			expect{ delete :destroy, id: relationships(:one) }.to_not change { Relationship.count }
		end
		
		it "should redirect unauthenticated delete requests to the login page" do
			expect( delete :destroy, id: relationships(:one) ).to redirect_to(login_url)
		end
	end
end