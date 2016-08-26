require 'rails_helper'

RSpec.describe "Microposts Interface", type: :request do
  fixtures :users, :microposts

	let(:let_user) {users(:michael)}

	it "micropost interface" do
		log_in_as(let_user)
		get root_path
		expect(response.body).to include('class="pagination"')
		expect(response.body).to include('type="file"')
		# Invalid submission
	  expect { post microposts_path, micropost: { content: "" } }.not_to change { Micropost.count }
		expect(response.body).to include('id="error_explanation"')
		# Valid submission
		content = "This micropost really ties the room together"
		picture = fixture_file_upload('spec/fixtures/rails.png', 'image/png')
	  expect { post microposts_path, micropost: { content: content, picture: picture } }.to change { Micropost.count }.by(1)
		expect( assigns(:micropost).picture? ).to be_truthy
		follow_redirect!
		expect(response.body).to include(content)
		# Delete a post.
		expect(response.body).to include('delete</a>')
		first_micropost = let_user.microposts.paginate(page: 1).first
	  expect { delete micropost_path(first_micropost) }.to change { Micropost.count }.by(-1)
		# Visit a different user.
		get user_path(users(:archer))
		expect(response.body).not_to include('delete</a>')
	end

	it "micropost sidebar count" do
		log_in_as(let_user)
		get root_path
		expect(response.body).to include('34 microposts')
		# User with zero microposts
		other_user = users(:mallory)
		log_in_as(other_user)
		get root_path
		expect(response.body).to include('0 microposts')
		other_user.microposts.create!(content: "A micropost")
		get root_path
		expect(response.body).to include('1 micropost')
	end

end
