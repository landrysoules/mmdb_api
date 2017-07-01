class MoviesController < ApplicationController
  def index
    @movies = Movie.all
    json_response(@movies, :ok)
  end

  def create
    @movie = Movie.create!(movies_params)
    json_response(@movie, :created)
  end

  private

  def movies_params
    params.require(:movie).permit(:name, :year)
  end
end
