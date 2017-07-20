FactoryGirl.define do
  factory :movie do
    name 'Blairwitch Project'
    year 1999
  end
  factory :pusher, class: Movie do
    name 'Pusher'
    year 1996
  end
end
