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
    assert_selector ".shepherd-text", text: "ENGLISH This first HOME step is centered & 'text-only'"
    assert_selector ".shepherd-button", text: "Later"
    assert_selector ".shepherd-button", text: "Continue"
    find(".shepherd-button", text: "Continue").click

    # Now try to manually trigger another tour
    find('#show_manual').click
    # Even though we triggered another tour, it should not appear since one is already active
    assert_selector ".shepherd-element", count: 1, visible: true

    # Tour Step 2
    assert_selector ".shepherd-header", text: "ENGLISH This step has a \"title\""
    assert_selector ".shepherd-text", text: "ENGLISH This intermediate step has \"some text\""
    assert_selector ".shepherd-button", text: "Exit"
    assert_selector ".shepherd-button", text: "Next"
    find(".shepherd-button", text: "Next").click

    # Tour Step 3 (should be skipped)
    refute_selector ".shepherd-header", text: "ENGLISH A missing step"
    
    # Tour Step 4
    assert_selector ".shepherd-header", text: "ENGLISH The final step"
    assert_selector ".shepherd-text", text: "ENGLISH Some text here too, and it's attached to the right"
    assert_selector ".shepherd-arrow", visible: true
    assert_selector ".shepherd-button", text: "Done"
    find(".shepherd-button", text: "Done").click

    # Tour should no longer be visible
    refute_selector ".shepherd-element"

    # Tour should not reappear on reload
    visit dashboard_home_url
    refute_selector ".shepherd-element"

    # Now start a manual tour
    find('#show_manual').click
    assert_selector ".shepherd-element", visible: true
    assert_selector ".shepherd-text", text: "You triggered the manual tour"
    assert_selector ".shepherd-button", text: "Done"
    find(".shepherd-button", text: "Done").click

    # Even though we finished the manual tour, we can start it again right away
    find('#show_manual').click
    assert_selector ".shepherd-element", visible: true
  end

  test "mark a tour for Later and it will not come back in this session" do
    visit dashboard_home_url
    assert_selector ".shepherd-element", visible: true

    # Dismiss tour
    find(".shepherd-button", text: "Later").click

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

  test "navigate with turbolinks between pages with tours" do
    visit dashboard_home_url
    assert_selector ".shepherd-element", visible: true
    # Navigate to other page
    find("a").click
    assert_selector ".shepherd-element", visible: true
  end

  test "tour with missing first step attachTo does not appear" do
    visit dashboard_missing_url
    # No tour should be visible, since the first step is invalid
    refute_selector ".shepherd-element"
  end

  test "page with two incomplete tours shows them on consecutive visits" do
    # First tour should appear at first visit
    visit dashboard_other_url
    assert_selector ".shepherd-element", visible: true
    assert_selector ".shepherd-header", text: "TOUR ONE step one ENGLISH"
    find(".shepherd-button", text: "Done").click

    # Second tour should appear at second visit
    visit dashboard_other_url
    assert_selector ".shepherd-element", visible: true
    assert_selector ".shepherd-header", text: "TOUR TWO step one ENGLISH"
    find(".shepherd-button", text: "Done").click

    # Now no tours should appear since they're both done
    visit dashboard_other_url
    refute_selector ".shepherd-element"
  end

  test "tour with custom buttons" do
    visit dashboard_buttons_url
    assert_selector ".shepherd-element", visible: true
    assert_selector ".shepherd-button", text: "Show this to me later"
    assert_selector ".shepherd-button", text: "Finish now"

    # Confirm that the custom buttons' specified actions work

    ### Click cancel
    find(".shepherd-button", text: "Show this to me later").click
    ### Revisit
    visit dashboard_buttons_url
    ### Tour doesn't appear
    refute_selector ".shepherd-element"
    ### Clear the cookie
    execute_script("Cookies.remove('abraham-dummy-#{@user_id}-dashboard-buttons-button_tour', { domain: '127.0.0.1' });")
    ### Revisit
    visit dashboard_buttons_url
    ### Tour should reappear and let us click the other button
    find(".shepherd-button", text: "Finish now").click
    ### Revisit
    visit dashboard_buttons_url
    ### Tour doesn't appear (now because it's completed)
    refute_selector ".shepherd-element"
  end
end
