require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  around do |spec|
    @spec_user = User.create( name: "example",
                              email: "example@example.com",
                              password_digest: User.digest('password'),
                              admin: true,
                              activated: true,
                              activated_at: Time.zone.now)
    spec.run
    @spec_user.destroy
  end
  
  it "should let users log in" do
    log_in_as(@spec_user)
    expect(subject.current_user).to eq(@spec_user)
  end
end