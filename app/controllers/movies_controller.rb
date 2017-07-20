class MoviesController < ApplicationController
  def initialize
    @ws_service = WebScraping::WebScrapingService.new
    @util_service = Common::UtilService.new
  end

  def index
    @local_movies = Movie.all
    render json: @local_movies
  end

  def search
    request = params['request']
    @local_movies = Movie.where(name: /#{request}/i).entries
    @imdb_movies = @ws_service.search(request)
    render json: {
      local_movies: @local_movies,
      imdb_movies: @util_service.filter_results(request, @imdb_movies)
    }
  end

  def create
    @movie = Movie.create!(movies_params)
    render json: @movie, status: :created
  end

  private

  def movies_params
    params.require(:movie).permit(:name, :year)
  end
end
