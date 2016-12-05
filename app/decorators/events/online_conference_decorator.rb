class Events::OnlineConferenceDecorator < ApplicationDecorator
  delegate_all

  def self.collections
    [ :future, :past, :removed ]
  end
end
