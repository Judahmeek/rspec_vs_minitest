require 'rails_helper'

RSpec.describe "User Index", type: :request do
	fixtures :users

	let(:let_admin)         { users(:michael) }
	let(:let_non_admin)     { users(:archer) }
	let(:let_not_activated) { users(:lana) }

	it "index as admin including pagination and delete links" do
		log_in_as(let_admin)
		get users_path
		expect(response).to render_template('users/index')
		expect(response.body).to include('class="pagination"')
		first_page_of_users = User.where(activated: true).paginate(page: 1)
		first_page_of_users.each do |user|
			expect(response.body).to include("href=\"#{user_path(user)}\">#{user.name}</a")
			unless user == let_admin
				expect(response.body).to include("href=\"#{user_path(user)}\">delete</a")
			end
		end
		expect { delete user_path(let_non_admin) }.to change { User.count }.by(-1)
	end

	it "index as non-admin" do
		log_in_as(let_non_admin)
		get users_path
		expect(response.body).to_not include("delete</a>")
		expect(response.body).to_not include("#{let_not_activated.name}</a>")
		expect(response.body).to include("Sterling Archer</a>")
	end

end