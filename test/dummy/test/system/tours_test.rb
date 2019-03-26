require "application_system_test_case"

class ToursTest < ApplicationSystemTestCase
  setup do
    @user_id = Random.rand(1..99999)
    @cookie_name = "abraham-dummy-#{@user_id}-dashboard-home-intro"
    ApplicationController.any_instance.stubs(:current_user).returns(OpenStruct.new(id: @user_id))
  end

  test "see and complete a tour" do
    visit dashboard_home_url

    # Tour Step 1
    assert_selector ".shepherd-element", visible: true
    assert_selector ".shepherd-text", text: "ENGLISH This first HOME step is centered text-only"
    assert_selector ".shepherd-button", text: "LATER"
    assert_selector ".shepherd-button", text: "CONTINUE"
    find(".shepherd-button", text: "CONTINUE").click

    # Tour Step 2
    assert_selector ".shepherd-header", text: "ENGLISH This step has a title"
    assert_selector ".shepherd-text", text: "ENGLISH This intermediate step has some text"
    assert_selector ".shepherd-button", text: "EXIT"
    assert_selector ".shepherd-button", text: "NEXT"
    find(".shepherd-button", text: "NEXT").click

    # Tour Step 3 (should be skipped)
    refute_selector ".shepherd-header", text: "ENGLISH A missing step"
    
    # Tour Step 4
    assert_selector ".shepherd-header", text: "ENGLISH The final step"
    assert_selector ".shepherd-text", text: "ENGLISH Some text here too, and it's attached to the right"
    assert_selector ".tippy-arrow", visible: true
    assert_selector ".shepherd-button", text: "DONE"
    find(".shepherd-button", text: "DONE").click

    # Tour should no longer be visible
    refute_selector ".shepherd-element"

    # Tour should not reappear on reload
    visit dashboard_home_url
    refute_selector ".shepherd-element"
  end

  test "mark a tour for later and it will not come back in this session" do
    visit dashboard_home_url
    assert_selector ".shepherd-element", visible: true

    # Dismiss tour
    find(".shepherd-button", text: "LATER").click

    # Tour should no longer be visible
    refute_selector ".shepherd-element"

    # Tour should not reappear on reload
    visit dashboard_home_url
    refute_selector ".shepherd-element"

    # Clear the cookie (simulate browser restart)
    execute_script("Cookies.remove('#{@cookie_name}', { domain: '127.0.0.1' });")

    # Tour should reappear
    visit dashboard_home_url
    assert_selector ".shepherd-element", visible: true
  end
end
