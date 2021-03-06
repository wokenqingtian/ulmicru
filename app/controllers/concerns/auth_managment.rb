# -*- coding: utf-8 -*-
module Concerns
  module AuthManagment
    include PermissionsConcern

    def sign_in(user)
      session[:user_id] = user.id
    end

    def sign_out
      session[:user_id] = nil
    end

    def signed_in?
      current_user
    end

    def signed_as_admin?
      signed_in? && current_user.role.in?(['admin', 'author', 'tech_admin'])
    end

    def authenticate_admin!
      redirect_to not_found_page_path unless signed_as_admin?
    end

    def authenticate_permitted_user!
      unless signed_as_admin?
        if self.class.name.include?('Unviewed') && Concerns::NotificatableItems.items(current_user.id).any?
          return
        elsif self.class.name.include?('Welcome')
          unless permitted_to? :see, :welcome
            redirect_to not_found_page_path
          end
        elsif !permitted_to?(action_name, to_param(model_class.name))
          redirect_to not_found_page_path
        end
      end
    end

    def authenticate_user!
      redirect_to new_session_path(notification: :need_auth) unless signed_in?
    end

    def authenticate_confirmed_user!
      redirect_to account_path(notification: :need_auth) if current_user.unviewed? && request.fullpath != account_path
    end

    def authenticate_member!
      unless current_user&.is_member? && current_user.member_confirmed?
        redirect_to not_found_page_path
      end
    end

    def current_user
      @_current_user ||= User.find_by(id: session[:user_id])
    end

    def required_basic_auth!
      authenticate_or_request_with_http_basic do |user, password|
        user == configus.basic_auth.username && password == configus.basic_auth.password
      end
    end
  end
end
