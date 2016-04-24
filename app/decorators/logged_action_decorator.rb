class LoggedActionDecorator < ApplicationDecorator
  delegate_all

  def user_short_name
    object.user.decorate.short_name
  end
end