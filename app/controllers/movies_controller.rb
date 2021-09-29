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
    # part 2
    @all_ratings = Movie.ratings
    
    session[:sort] = params[:sort] unless params[:sort].nil?
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    #check whether sort or not
    
    if (params[:ratings].nil? && !session[:ratings].nil?) || 
      (params[:sort].nil? && !session[:sort].nil?)
      #if ratings is not select, we redirect to new page
      redirect_to movies_path("ratings" => session[:ratings], "sort" => session[:sort])
    elsif !params[:ratings].nil? || !params[:sort].nil?
      if !params[:ratings].nil?
        array_ratings = params[:ratings].keys
        return @movies = Movie.where(rating: array_ratings).order(session[:sort])
      else
        return @movies = Movie.all.order(session[:sort])
      end
    elsif !session[:ratings].nil? || !session[:sort].nil?
      redirect_to movies_path("ratings" => session[:ratings], "sort" => session[:sort])
    else
      return @movies = Movie.all
    end

  end#part1 complete


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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
