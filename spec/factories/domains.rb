FactoryBot.define do
  factory :domain do
    sequence(:name) do |n|
      # insert the number into the first part of the domain to prevent duplication
      array = Faker::Internet.domain_name.split('.')
      array[0] << n.to_s
      array.join('.')
    end

    trait :with_stamps do
      stamps { build_list :label_stamp, 3 }
    end
  end
end
