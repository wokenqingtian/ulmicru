require 'scopes_rails/state_machine/scopes'

module QuestionaryScopes
  extend ActiveSupport::Concern
  include StateMachine::Scopes

  included do
    scope :unviewed, -> { where(member_state: :unviewed).order('id DESC') }
    scope :presented, -> { where.not(state: :removed) }
    scope :member_on_the_trial, -> { where member_state: :on_the_trial }
    scope :member_trial_passed, -> { where member_state: :trial_passed }
    scope :need_to_review, -> { where 'member_state = \'unviewed\' OR member_state = \'updated\'' }
  end
end
