FactoryGirl.define do
  factory :mob do
    name 'wombo'
    type 'wombomwombo'
    level 1
    health 100
    max_health 100
    damage 2
    map_id 123
    movement_type 0
    location [1, 3]
  end
end
