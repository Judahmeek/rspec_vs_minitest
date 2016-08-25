require 'rails_helper'

describe Micropost do
  fixtures :users, :microposts

	let(:let_micropost) {users(:michael).microposts.build(content: "Lorem ipsum")}

	it "should be valid" do
		expect(let_micropost).to be_valid
	end

	it "should check for a valid user id" do
		let_micropost.user_id = nil
		expect(let_micropost).not_to be_valid
	end

	it "should invalidate empty content" do
		let_micropost.content = "   "
		expect(let_micropost).not_to be_valid
	end

	it "should invalidate content exceeding 140 characters" do
		let_micropost.content = 'a' * 141
		expect(let_micropost).not_to be_valid
	end

	it "should be sorted by most recent" do
		expect(microposts(:most_recent)).to eq(Micropost.first)
	end

end
