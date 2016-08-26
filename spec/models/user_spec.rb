require 'rails_helper'

describe User do
	fixtures :users, :microposts
	
	context "Validating information" do
		let(:let_user) {User.new(name: "Example User", email: "user@example.com",
											 password: "foobar", password_confirmation: "foobar")}

		it "is a valid user object" do
			expect(let_user).to be_valid
		end

		describe "name validations:" do
			it "has a name" do
				let_user.name = "   "
				expect(let_user).not_to be_valid
			end

			it "name is not too long" do
				let_user.name = "a" * 51
				expect(let_user).not_to be_valid
			end
		end

		describe "email validations:" do
			it "has an email address" do
				let_user.email = "   "
				expect(let_user).not_to be_valid
			end

			it "has a reasonably short email address" do
				let_user.email = "a" * 244 + "@example.com"
				expect(let_user).not_to be_valid
			end

			it "accepts valid email addresses" do
				valid_addresses = %w[user@example.com
														 USER@foo.COM 
														 A_US-ER@foo.bar.org
														 first.last@foo.jp
														 alice+bob@baz.cn]
				valid_addresses.each do |valid_address|
					let_user.email = valid_address
					expect(let_user).to be_valid, "#{valid_address.inspect} should be valid"
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
					let_user.email = invalid_address
					expect(let_user).not_to be_valid, "#{invalid_address.inspect} should be invalid"
				end
			end

			it "rejects non-unique email addresses" do
				duplicate_user = let_user.dup
				duplicate_user.email = let_user.email.upcase
				let_user.save
				expect(duplicate_user).not_to be_valid
			end

			it "saves email addresses as lower-case" do
				mixed_case_email = "Foo@exAMPle.CoM"
				let_user.email = mixed_case_email
				let_user.save
				expect(mixed_case_email.downcase).to eq(let_user.reload.email)
			end
		end

		describe "password validations" do
			it "requires password" do
				let_user.password = let_user.password_confirmation = " " * 6
				expect(let_user).not_to be_valid
			end

			it "requires password of minimum length" do
				let_user.password = let_user.password_confirmation = "a" * 5
				expect(let_user).not_to be_valid
			end

			it "does not authenticate without a digest" do
				expect(let_user).not_to be_authenticated(:remember, '')
			end
		end

		describe "destroying a user" do
			it "destroys associated microposts" do
				let_user.save
				let_user.microposts.create!(content: "Lorem ipsum")
				expect{ let_user.destroy }.to change{ let_user.microposts.count }.by(-1)
			end
		end

		describe "following and unfollowing" do
			it "can follow another user" do
				michael = users(:michael)
				archer  = users(:archer)
				expect{ michael.follow(archer) }.to change{ michael.following?(archer) }.from(false).to(true)
			end
		end

		describe "feed" do
			it "feed should have the right posts" do
				michael = users(:michael)
				archer  = users(:archer)
				lana		= users(:lana)
				# Posts from followed user
				lana.microposts.each do |post_following|
					expect( michael.feed.include?(post_following) ).to be_truthy
				end
				# Posts from self
				michael.microposts.each do |post_self|
					expect( michael.feed.include?(post_self) ).to be_truthy
				end
				# Posts from unfollowed user
				archer.microposts.each do |post_unfollowed|
					expect( michael.feed.include?(post_unfollowed) ).to be_falsy
				end
			end
		end
	end
end