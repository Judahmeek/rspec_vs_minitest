require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

	def setup
		@micropost = microposts(:orange)
	end

	test "should redirect create when not logged in" do
		assert_no_difference 'Micropost.count' do
			post :create, micropost: { content: "Lorem ipsum" }
		end
		assert_redirected_to login_url
	end

	test "should redirect destroy when not logged in" do
		assert_no_difference 'Micropost.count' do
			delete :destroy, id: @micropost
		end
		assert_redirected_to login_url
	end

	test "should redirect destroy for another user's micropost" do
		log_in_as(users(:michael)) # This is confusing. Michael is an admin so shouldn't he be able to delete other user's posts?
		micropost = microposts(:ants) # this micropost doesn't belong_to michael
		assert_no_difference 'Micropost.count' do
			delete :destroy, id: micropost
		end
		assert_redirected_to root_url
	end

end
