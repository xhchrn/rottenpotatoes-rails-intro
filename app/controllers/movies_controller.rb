class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # if @current_page?(@root)
    #   @movies = Movie.all
    # end
    # @movies = Movie.all

    # get the sorted unique possible values of ratings
    @all_ratings = Movie.all_ratings

    if params.include?(:ratings)
      @selected_ratings = params[:ratings].keys
    elsif !@selected_ratings
      @selected_ratings = @all_ratings
    end

    selected_movies = Movie.where(rating: @selected_ratings)

    if params[:sort] == "title"
      @movies = selected_movies.order("title")
      @title_class = "hilite"
      @release_date_class = nil
    elsif params[:sort] == "release_date"
      @movies = selected_movies.order("release_date")
      @title_class = nil
      @release_date_class = "hilite"
    else
      @movies = selected_movies
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
