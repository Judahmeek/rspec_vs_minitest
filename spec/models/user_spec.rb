require 'rails_helper'

describe User do
	context "Validating information" do
		before :each do
			@user = User.new(name: "Example User", email: "user@example.com",
											 password: "foobar", password_confirmation: "foobar")
		end

		it "is a valid user object" do
			expect(@user).to be_valid
		end

		describe "name validations:" do
			it "has a name" do
				@user.name = "   "
				expect(@user).not_to be_valid
			end

			it "name is not too long" do
				@user.name = "a" * 51
				expect(@user).not_to be_valid
			end
		end

		describe "email validations:" do
			it "has an email address" do
				@user.email = "   "
				expect(@user).not_to be_valid
			end

			it "has a reasonably short email address" do
				@user.email = "a" * 244 + "@example.com"
				expect(@user).not_to be_valid
			end

			it "accepts valid email addresses" do
				valid_addresses = %w[user@example.com
														 USER@foo.COM 
														 A_US-ER@foo.bar.org
														 first.last@foo.jp
														 alice+bob@baz.cn]
				valid_addresses.each do |valid_address|
					@user.email = valid_address
					expect(@user).to be_valid, "#{valid_address.inspect} should be valid"
				end
			end

			it "rejects invalid email addresses" do
				invalid_addresses = %w[user@example,com
														 user_at_foo.org
														 user.name@example.
														 foo@bar_baz.com
														 foo@bar+baz.com
														 foo@bar..com]
				invalid_addresses.each do |invalid_address|
					@user.email = invalid_address
					expect(@user).not_to be_valid, "#{invalid_address.inspect} should be invalid"
				end
			end

			it "rejects non-unique email addresses" do
				duplicate_user = @user.dup
				duplicate_user.email = @user.email.upcase
				@user.save
				expect(duplicate_user).not_to be_valid
			end

			it "saves email addresses as lower-case" do
				mixed_case_email = "Foo@ExAMPle.CoM"
				@user.email = mixed_case_email
				@user.save
				expect(mixed_case_email.downcase).to eq(@user.reload.email)
			end
		end

		describe "password validations" do
			it "requires password" do
				@user.password = @user.password_confirmation = " " * 6
				expect(@user).not_to be_valid
			end

			it "requires password of minimum length" do
				@user_password = @user.password_confirmation = "a" * 5
				expect(@user).not_to be_valid
			end

			it "does not authenticate without a digest" do
				expect(@user).not_to be_authenticated(:remember, '')
			end
		end

		describe "destroying a user" do
			it "destroys associated microposts" do
				@user.save
				@user.microposts.create!(content: "Lorem ipsum")
				expect{ @user.destroy }.to change{ @user.microposts.count }.by(-1)
			end
		end

		describe "following and unfollowing" do
			it "can follow another user" do
				skip "fixtures not accessible in RSpec(?)"
				michael = users(:michael)
				archer  = users(:archer)
				expect{ michael.follow(archer) }.to change{ michael.following?(archer) }.from(false).to(true)
			end
		end

		describe "feed" do
			skip "fixtures not available in RSpec(?)"
		end
	end
end