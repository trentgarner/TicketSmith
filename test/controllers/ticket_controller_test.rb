require "test_helper"

class TicketControllerTest < ActionDispatch::IntegrationTest
  test "should get title:string" do
    get ticket_title:string_url
    assert_response :success
  end

  test "should get description:text" do
    get ticket_description:text_url
    assert_response :success
  end

  test "should get status:string" do
    get ticket_status:string_url
    assert_response :success
  end

  test "should get priority:string" do
    get ticket_priority:string_url
    assert_response :success
  end

  test "should get reporter:string" do
    get ticket_reporter:string_url
    assert_response :success
  end

  test "should get assignee:string" do
    get ticket_assignee:string_url
    assert_response :success
  end
end
