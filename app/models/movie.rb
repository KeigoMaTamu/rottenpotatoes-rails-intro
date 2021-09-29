class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G','PG','PG-13','R']
  end
  
  def self.with_ratings(ratings_list, sort_by = nil)
    movies = if ratings_list.empty? 
      Movie.all
    else 
      Movie.where('rating in (?)', ratings_list)
    end
  
    if sort_by 
      movies.order(sort_by)
    else 
      movies
    end
  end
end
