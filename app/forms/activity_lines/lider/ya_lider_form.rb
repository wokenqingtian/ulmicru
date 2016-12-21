class ActivityLines::Lider::YaLiderForm < ApplicationReform
  properties :contest_year, :contest_number

  validates :contest_year, presence: true
  validates :contest_number, presence: true
end