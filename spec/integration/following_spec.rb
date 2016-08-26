require 'rails_helper'

RSpec.describe "Following Functionality", type: :request do
  fixtures :users

	let(:let_user)  {users(:michael)}
	let(:let_other) {users(:archer)}

  before(:each) {log_in_as(let_user)}

	it "should display a view listing all followed users" do
		get following_user_path(let_user)
		expect( let_user.following.empty? ).to be_falsy
		expect( response.body ).to match(let_user.following.count.to_s)
		let_user.following.each do |user|
		  expect(response.body).to include("href=\"#{user_path(user)}\"")
		end
	end

	it "should display a view listing all followers" do
		get followers_user_path(let_user)
		expect( let_user.followers.empty? ).to be_falsy
		expect( response.body ).to match(let_user.followers.count.to_s)
		let_user.followers.each do |user|
		  expect(response.body).to include("href=\"#{user_path(user)}\"")
		end
	end

	it "should follow a user the standard way" do
	  expect { post relationships_path, followed_id: let_other.id }.to change { let_user.following.count }.by(1)
	end

	it "should follow a user with Ajax" do
	  expect { xhr :post, relationships_path, followed_id: let_other.id }.to change { let_user.following.count }.by(1)
	end

	it "should unfollow a user the standard way" do
		let_user.follow(let_other)
		relationship = let_user.active_relationships.find_by(followed_id: let_other.id)
		expect { delete relationship_path(relationship) }.to change { let_user.following.count }.by(-1)
	end

	it "should unfollow a user with Ajax" do
		let_user.follow(let_other)
		relationship = let_user.active_relationships.find_by(followed_id: let_other.id)
		expect { xhr :delete, relationship_path(relationship) }.to change { let_user.following.count }.by(-1)
	end

end
