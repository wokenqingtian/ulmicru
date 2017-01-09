module Concerns
  module PermissionsConcern
    def permitted_to?(action, model_name)
      permitted_users_id = Organization::Permissions.send(model_name)[action.to_sym].map &:id
      permitted_users_id.include? current_user.id
    end
  end
end