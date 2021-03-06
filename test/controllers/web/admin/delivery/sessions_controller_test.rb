require 'test_helper'

class Web::Admin::Delivery::SessionsControllerTest < ActionController::TestCase
  setup do
    admin = create :admin
    sign_in admin
    @campaign = create :delivery_campaign
  end

  # TODO checking mailing
  test 'should post create' do
    post :create, id: @campaign.id
    assert_redirected_to admin_delivery_campaign_path @campaign
    @campaign.reload
    assert @campaign.during_mailing?
  end
end
