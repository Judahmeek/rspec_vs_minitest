require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  fixtures :users
  
  it "should let users log in" do
    log_in_as(users(:michael))
    expect(subject.current_user).to eq(users(:michael))
  end
end