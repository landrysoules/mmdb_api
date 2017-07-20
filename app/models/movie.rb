class Movie
  include Mongoid::Document
  field :name
  field :year, type: Integer
  has_many :directors
  has_many :writers
  has_many :actors
end
