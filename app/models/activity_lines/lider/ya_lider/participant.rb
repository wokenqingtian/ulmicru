class ActivityLines::Lider::YaLider::Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :contest, class_name: 'ActivityLines::Lider::YaLider'
  has_many :participations, class_name: 'ActivityLines::Lider::YaLider::Participation'
  has_many :fields, class_name: 'ActivityLines::Lider::YaLider::ParticipantField'

  validates :user_id, presence: true
  validates :contest_id, presence: true

  state_machine :state, initial: :active do
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

  include PgSearch
  pg_search_scope :search_everywhere, against: [ :user_id, :contest_id ],
    associated_against: { user: [ :first_name, :last_name, :email ] }

  def esse
    fields.where(title: :esse).first
  end

  def request_field(name)
    fields.where(title: name).first
  end
end
