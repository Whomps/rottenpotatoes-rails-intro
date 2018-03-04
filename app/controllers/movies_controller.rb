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
    @all_ratings = ['G', 'PG', 'PG-13', 'R', 'NC-17']	# is here the best place for this?

	
	if params[:sort].present? == false && params[:direction].present? == false && params[:ratings].present? == false && params[:new].present? == false
	  redirect_to action: :index, :sort => session[:sort], :direction => session[:direction], :ratings => session[:ratings], :new => "yes" and return
	end
	
	#if request.referrer == request.original_url
    #  printf "\n\nThis is my param sort: %s\n", params[:sort].to_s
    #  printf "This is my param direction: %s\n", params[:direction].to_s
    #  printf "This is my param ratings: %s\n", params[:ratings].to_s
	#  printf "This is my session sort: %s\n", session[:sort].to_s
	#  printf "This is my session sort: %s\n", session[:direction].to_s
	#  printf "This is my session sort: %s\n\n", session[:ratings].to_s
    #  redirect_to action: :index, :sort => session[:sort], :direction => session[:direction], :ratings => session[:ratings] and return
    #elsif
	#  printf "\n\nParams valid\n\n"
	#end
		
	params[:sort] ||= session[:sort]
    params[:direction] ||= session[:direction]
    params[:ratings] ||= session[:ratings]
		
	#Set my_ratings for filtering
	if params[:ratings].present?
	  @my_ratings = (params[:ratings].present? ? params[:ratings].each_key : [])  # maintain checkboxes
	  #printf "\nParams present\n"
	elsif session[:ratings].present?
	  @my_ratings = (session[:ratings].present? ? session[:ratings].each_key : [])
	  #printf "\nMIDDLE BOY\n"
	else
	  @my_ratings = @all_ratings
	  #printf "\nParams NOT present\n"
	end
	
	#Query DB
	if not @my_ratings.present? 	# if no show-ratings selected (never occurs after addition of the above section)
	  @movies = Movie.none		# return nothing
	elsif params[:sort].nil? || params[:direction].nil?		# if no sort selected
      #@session[:ratings] = params[:ratings] 
	  @movies = Movie.where("rating IN (?)", @my_ratings.each_entry)
	else						# ratings selected AND sort selected
	  #@session[:ratings] = params[:ratings] 
      @movies = Movie.where("rating IN (?)", @my_ratings.each_entry).order(params[:sort] + " " + params[:direction]) # injection vuln here!
	end
	
	session[:sort] = params[:sort]
    session[:direction] = params[:direction]
    session[:ratings] = params[:ratings]
	#printf "\n\n~~~~~~~SESSION REDEFINED~~~~~~~~~~\n\n" 
	
  end # I assume it is desired for sorting to reset if querying a new set of ratings
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
	#redirect_to action: :index, :sort => session[:sort], :direction => session[:direction], :ratings => session[:ratings]
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
