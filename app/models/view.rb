class View < ActiveRecord::Base
  belongs_to :record, polymorphic: true
  belongs_to :user
end