FactoryGirl.define do
  factory :player do
    name { 'Tester' }
    species { 'Human' }
    type { 'Warrior' }
    password { 'testpw' }
  end
end