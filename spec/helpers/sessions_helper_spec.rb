require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  fixtures :users
  
  describe "current_user" do
    it "current_user returns right user when session is nil" do
      user = users(:michael)
      remember(user)
      expect(user).to eq(current_user)
    end
  
    it "current_user returns nil when remember digest is wrong" do
      users(:michael).update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to be_nil
    end
  end
end