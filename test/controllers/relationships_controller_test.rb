require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase

    test "create should require logged-in user" do
        assert_no_difference 'Relationship.count' do
            post :create  # params don't matter because create request should be caught by logged_in_user before_action
        end               # except... you can't properly test for a change in the relationship count by an unauthenticated user without them
        assert_redirected_to login_url
    end

    test "destroy should require logged-in user" do
        assert_no_difference 'Relationship.count' do
            delete :destroy, id: relationships(:one)
        end
        assert_redirected_to login_url
    end

end
