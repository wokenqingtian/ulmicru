FactoryGirl.define do
  factory :position do
    title { generate :string }
    member_id { Member.last ? Member.last.id : create(:member).id }
    begin_date { DateTime.now }
    end_date { DateTime.now }
    state { Position.state_machines[:state].states.map(&:name).first.to_s }
  end

  factory :position_corporative_lead, parent: :position do
    title 'Руководитель корпоративных проектов'
    for_now 1
  end

  factory :position_deputy_corporative_lead, parent: :position_corporative_lead do
    title 'Заместитель руководителя корпоративных проектов'
  end

  factory :position_press_center_head, parent: :position do
    title 'Руководитель пресс-центра'
    for_now 1
  end
end
