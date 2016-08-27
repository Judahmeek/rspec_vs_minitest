require 'rails_helper'

RSpec.describe "User Profile", type: :request do
	include ApplicationHelper
	fixtures :users

	let(:let_user) { users(:michael) }

	it "should display the user's profile" do
		get user_path(let_user)
		expect(response).to render_template( 'users/show' )
		expect(response.body).to include("<title>#{ full_title(let_user.name) }")
		expect(response.body).to match(/#{ let_user.name }\s*<\/h1>/)
		expect(response.body).to match(/h1>\s*<img alt=\"#{let_user.name}\" class="gravatar"/) #bad approximation of assert_select 'h1>img.gravatar'
		expect(response.body).to match(let_user.microposts.count.to_s)
		expect(response.body).to include('<div class="pagination"')
		let_user.microposts.paginate(page: 1).each do |micropost|
			expect(response.body).to match(micropost.content)
		end
	end

end