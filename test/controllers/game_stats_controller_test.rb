require 'test_helper'

class GameStatsControllerTest < ActionController::TestCase
  test "should get summary" do
    get :summary
    assert_response :success
  end

  test "should get add" do
    get :add
    assert_response :success
  end

end
