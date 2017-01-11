class ActivityLines::Lider::YaLider::Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :contest, class_name: 'ActivityLines::Lider::YaLider'

  state_machine :state, initial: :unviewed do
    state :unviewed
    state :active
    state :won
    state :lost
    state :removed
    state :declined

    event :confirm do
      transition all => :active
    end

    event :remove do
      transition all => :removed
    end

    event :restore do
      transition removed: :active
    end
  end
end
