class UserSignInForm < ApplicationForm
  self.main_model = :user

  attributes :id, :email
end
