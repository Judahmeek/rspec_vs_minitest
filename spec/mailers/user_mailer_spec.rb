require 'rails_helper'

describe UserMailer do
  fixtures :users
  
  it "should send account_activation email" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    expect( "Account activation" ).to eq(mail.subject)
    expect( [user.email] ).to eq(mail.to)
    expect( ["noreply@example.com"] ).to eq(mail.from)
    expect( mail.body.encoded ).to match(user.name)
    expect( mail.body.encoded ).to match(user.activation_token)
    expect( mail.body.encoded ).to match(CGI::escape(user.email))
  end

  it "should send password_reset email" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    expect( "Password reset" ).to eq(mail.subject)
    expect( [user.email] ).to eq(mail.to)
    expect( ["noreply@example.com"] ).to eq(mail.from)
    expect( mail.body.encoded ).to match(user.reset_token)
    expect( mail.body.encoded ).to match(CGI::escape(user.email))
  end

end