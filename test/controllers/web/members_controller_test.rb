require 'test_helper'

class Web::MembersControllerTest < ActionController::TestCase
  setup do
    @member = create :member
    sign_in @member
  end

  test 'should not get new unsigned' do
    sign_out
    get :new
    assert_response :redirect, @response.body
  end

  test 'should get new' do
    get :new
    assert_response :success, @response.body
  end

  test 'should create member' do
    @member.update state: :unavailable
    attributes = attributes_for :member
    [:first_name, :last_name, :patronymic, :ticket].each do |attribute|
      attributes[attribute] = @member.send attribute
    end
    create :event_registration
    create :comment
    create :authentication
    post :create, member: attributes
    assert_response :redirect, @response.body
    assert_redirected_to account_path
    assert_equal attributes[:patronymic], Member.last.patronymic
  end

  test 'should get show' do
    @member.confirm
    get :show, ticket: @member.ticket
    assert_response :success, @response.body
  end

  test 'should get show for 100 members' do
    tickets = Member.presented.map(&:ticket).compact.shuffle!.first 100
    tickets.each do |ticket|
      get :show, ticket: ticket
      assert_response :success, ticket
    end
  end
end
