require 'test_helper'

class ChatsControllerTest < ActionDispatch::IntegrationTest
  test "should get chat" do
    get chats_chat_url
    assert_response :success
  end

end
