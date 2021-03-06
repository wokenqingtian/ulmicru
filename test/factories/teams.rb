FactoryGirl.define do
  factory :team do
    title { generate :string }
    member_id { create(:member).id }
    description { generate :string }
    state { Team.state_machines[:state].states.map(&:name).first.to_s }
    publicity { Team.publicity.values.first }
    type { [ 'Team::Departament', 'Team::Primary', 'Team::Committee', 'Team::Subdivision', 'Team::Administration'].sample }
    municipality { Team::Departament.municipality.values.sample }
  end

  factory :departament, parent: :team, class: 'Team::Departament' do
    municipality { Team::Departament.municipality.values.first }
    type 'Team::Departament'
  end
  factory :primary, parent: :team, class: 'Team::Primary' do
    type 'Team::Primary'
  end
  factory :subdivision, parent: :team, class: 'Team::Subdivision' do
    type 'Team::Subdivision'
  end
  factory :administration, parent: :team, class: 'Team::Administration' do
    type 'Team::Administration'
  end
  factory :committee, parent: :team, class: 'Team::Committee' do
    type 'Team::Committee'
    project_type { Team::Committee.project_type.values.sample }
    project_id do 
      if project_type.constantize.last.present?
        project_type.constantize.last.id
      else
        create(project_type.underscore).id
      end
    end
  end
  factory :team_with_teammates, parent: :team do
    users { create_list :user, 5 }
  end
  factory :presidium, parent: :administration do
    title 'Президиум'
  end
  factory :area_headers, parent: :team do
    title 'Руководители областных программ и проектов МИЦ'
  end
end
