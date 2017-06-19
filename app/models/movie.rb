class Movie
  include Mongoid::Document
  field :name
  field :year, type: Integer
end
