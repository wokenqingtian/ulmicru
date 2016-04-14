FactoryGirl.define do
  factory :member do
    first_name { generate :human_name }
    last_name { generate :human_name }
    email
    patronymic { generate :human_name }
    motto { generate :string }
    ticket { generate :integer }
    parent_id { Member.last ? Member.last.id : nil }
    mobile_phone { generate :phone }
    birth_date { generate :datetime }
    home_adress { generate :string }
    avatar { generate :image }
    password { generate :password }
    password_confirmation { password }
    municipality { Member.municipality.values.first } 
    locality { Member.locality.values.first }
    state { Member.state_machines[:state].states.map(&:name).first.to_s }
    member_state { Member.state_machines[:member_state].states.map(&:name).first.to_s }
    role 'user'
    type 'Member'

    trait :corporate_head do
      ticket 238
    end
  end
end
