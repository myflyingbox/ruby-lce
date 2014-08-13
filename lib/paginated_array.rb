class PaginatedArray < Array
  attr_reader :total_count, :current_page,  :per_page
  

  def initialize(total_count, current_page, per_page)
    @total_count = total_count
    @current_page = current_page
    @per_page = per_page
    super()    
  end
  
  def total_page
    (total_count.fdiv(per_page)).ceil
  end
  
  def next_page
    next_page = current_page + 1
    next_page <= total_page ? next_page : false
  end
  
  def previous_page
    previous_page = current_page - 1
    previous_page > 0  ? previous_page : false
  end  
end
