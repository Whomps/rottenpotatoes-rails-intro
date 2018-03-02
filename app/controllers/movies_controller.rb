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
    @all_ratings = ['G', 'PG', 'PG-13', 'R']	# is here the best place for this?
	
	if params[:ratings].present?
	  @my_ratings = (params[:ratings].present? ? params[:ratings].each_key : [])  # maintain checkboxes
	  printf "\nParams present\n"
	else
	  @my_ratings = @all_ratings
	  printf "\nParams NOT present\n"
	end
	
	#if @new_visit == true	# This does not work if you delete cookies
	#  @my_ratings = @all_ratings 	# enable all checkboxes for new users
	#  @new_visit = false
	#end
	# The above won't work for me in FireFox, but sometimes works in Chrome?
	
	if not @my_ratings.present? 	# if no show-ratings selected (never occurs after addition of the above section)
	  @movies = Movie.none		# return nothing
	elsif params[:sort].nil? || params[:direction].nil?		# if no sort selected
	  @movies = Movie.where("rating IN (?)", @my_ratings.each_entry)
	else						# ratings selected AND sort selected
      @movies = Movie.where("rating IN (?)", @my_ratings.each_entry).order(params[:sort] + " " + params[:direction]) # injection vuln here!
	end
  end # I assume it is desired for sorting to reset if querying a new set of ratings
  
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
