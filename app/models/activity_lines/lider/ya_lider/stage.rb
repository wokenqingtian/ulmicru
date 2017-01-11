class ActivityLines::Lider::YaLider::Stage < ActiveRecord::Base
  belongs_to :contest, class_name: 'ActivityLines::Lider::YaLider'
  has_many :participations, class_name: 'ActivityLines::Lider::YaLider::Participation'
  has_many :participants, through: :participations

  validates :number, presence: true, uniqueness: { scope: :ya_lider_id }

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
end
