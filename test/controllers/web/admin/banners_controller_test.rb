require 'test_helper'

class Web::Admin::BannersControllerTest < ActionController::TestCase
  setup do
    @banner = create :banner
    admin = create :admin
    sign_in admin
    @exceptions_attributes = ['id', 'created_at', 'updated_at', 'begin_date', 'end_date', 'horizontal', 'vertical']
  end

  test 'should get new' do
    get :new
    assert_response :success, @response.body
  end

  test 'should get index' do
    get :index
    assert_response :success, @response.body
  end

  test 'should get index all pages and tabs' do
    if ENV['DB'] == 'prod'
      BannerDecorator.collections.each do |collection|
        pages = Banner.send(collection).count / 25
        (pages + 2).times do |page|
          get :index, page: page
          assert_response :success
          print "Page #{page} of #{pages} of #{collection}\r"
        end
      end
    end
  end

  test 'should get index with search' do
    get :index, search: @banner.link
    assert_response :success, @response.body
  end

  test 'should get index without instances' do
    Banner.destroy_all
    get :index
    assert_response :success, @response.body
  end

  test 'should create banner' do
    attributes = attributes_for :banner
    post :create, banner: attributes
    assert_response :redirect, @response.body
    assert_redirected_to admin_banners_path
    banner = Banner.last
    banner.attributes.keys.except(*@exceptions_attributes).each do |key|
      assert_equal attributes[key.to_sym], banner.send(key), key
    end
  end

  test 'should get edit' do
    get :edit, id: @banner
    assert_response :success, @response.body
  end

  test 'should patch update' do
    attributes = attributes_for :banner
    patch :update, banner: attributes, id: @banner
    assert_response :redirect, @response.body
    assert_redirected_to admin_banners_path
    @banner.reload
    @banner.attributes.keys.except(*@exceptions_attributes).each do |key|
      assert_equal attributes[key.to_sym], @banner.send(key), key
    end
  end

  test 'should delete destroy' do
    delete :destroy, id: @banner
    @banner.reload
    assert @banner.removed?
  end
end
