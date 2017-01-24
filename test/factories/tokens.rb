FactoryGirl.define do
  factory :token do
    content { generate :string }
    record_type { Token.record_type.values.sample }
    record_id do
      if record_type.constantize.last.present?
        record_type.constantize.last.id
      else
        create(record_type.underscore).id
      end
    end
  end
end
