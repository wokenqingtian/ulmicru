class ActivityLines::Corporative::Merit < ActiveRecord::Base
  belongs_to :user

  extend Enumerize
  enumerize :nomination, in: [ :first_degree, :second_degree ]

  validates :nomination, uniqueness: { scope: :user_id }

  state_machine :state, initial: :active do
    state :active
    state :removed

    event :remove do
      transition all => :removed
    end

    event :restore do
      transition all => :active
    end
  end

  include StateMachine::Scopes

  scope :honorary_members, -> { active.where nomination: :first_degree }
  scope :second_degree, -> { active.where nomination: :second_degree }

  include PgSearch
  pg_search_scope :search_everywhere, against: [ :year, :nomination, :user_id ]

  def self.collections
    [ :honorary_members, :second_degree ]
  end
end
