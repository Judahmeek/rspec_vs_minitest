require 'rails_helper'

describe Relationship do

	let(:let_relationship) {Relationship.new(follower_id: 1, followed_id: 2)}

	it "should be valid" do
		expect(let_relationship).to be_valid
	end

	it "should require a follower_id" do
		let_relationship.follower_id = nil
		expect(let_relationship).not_to be_valid
	end

	it "should require a followed_id" do
		let_relationship.followed_id = nil
		expect(let_relationship).not_to be_valid
	end

end
