require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
	
	describe "Unauthenticated Create Requests" do
    around do |spec|
      @spec_user = User.create(name: "example",
                  email: "example@example.com",
                  password_digest: User.digest('password'),
                  admin: true,
                  activated: true,
                  activated_at: Time.zone.now)
      spec.run
      @spec_user.destroy
    end

    it " should not fulfill unauthenticated create requests" do
      expect{ post :create, id: @spec_user.id }.to_not change { Micropost.count }
    end
    
    it "should redirect unauthenticated create requests to the login page" do
      expect( post :create, id: @spec_user.id ).to redirect_to(login_url)
    end
  end

	describe "Unauthenticated Delete Requests" do
    around do |spec|
      spec_user = User.create( name: "example",
                                email: "example@example.com",
                                password_digest: User.digest('password'),
                                admin: false,
                                activated: true,
                                activated_at: Time.zone.now)
      other_user = User.create( name: "other",
                                email: "other@example.com",
                                password_digest: User.digest('password'),
                                admin: false,
                                activated: true,
                                activated_at: Time.zone.now)
      @example_rel = Relationship.create(follower: spec_user, followed: other_user)
      spec.run
      spec_user.destroy
      other_user.destroy
      @example_rel.destroy
    end    
    it "should not fulfill unauthenticated delete requests" do
      expect{ delete :destroy, id: @example_rel.id }.to_not change { Relationship.count }
    end
    
    it "should redirect unauthenticated delete requests to the login page" do
      expect( delete :destroy, id: @example_rel.id ).to redirect_to(login_url)
    end
  end
end