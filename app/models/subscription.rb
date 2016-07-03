class Subscription < ActiveRecord::Base
  belongs_to :receiver, polymorphic: true

  has_one :token, as: :record, dependent: :destroy

  extend Enumerize
  enumerize :subscription_type, in: [ :deliveries ]
end
