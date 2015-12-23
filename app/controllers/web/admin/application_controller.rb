class Web::Admin::ApplicationController < Web::ApplicationController
  before_filter :authenticate_admin!
  layout 'web/admin/application'

  protected

  def choose_users
    @users = User.presented.decorate
  end
end
