module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def hilite_helper(col_title)
	if(params[:sort].to_s == col_title)
		return 'hilite'
	else
		return nil
	end
  end
  
  def sort_table(column, title = nil)
    title ||= column.titlecase
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction 
  end
  
end
