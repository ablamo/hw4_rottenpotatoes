class Movie < ActiveRecord::Base
  class Movie::NoMoviesFoundError < StandardError; end
  class Movie::NoDirectorInfoError < StandardError; end
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def find_similar
    raise Movie::NoDirectorInfoError, "Unknown director" unless (self.director && self.director != "")
    @movies = Movie.find_all_by_director(self.director)
    raise Movie::NoMoviesFoundError, "No other movies directed by the same director" unless @movies.length > 1
    @movies.delete_if { |a_movie| a_movie.title == self.title }
  end
end
