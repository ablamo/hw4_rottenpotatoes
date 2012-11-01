require 'spec_helper'

describe Movie do
  describe 'finding movies with valid director attribute' do
    before :each do
        @movie1 = Movie.create!(:title => 'Movie 1', :director => 'Director 1')
        @movie2 = Movie.create!(:title => 'Movie 2', :director => 'Director 1')
        @movie3 = Movie.create!(:title => 'Movie 3', :director => 'Director 2')
    end
    it 'should search and return all other movies directed by its director' do
      Movie.should_receive(:find_all_by_director).with("Director 1").
        and_return([@movie1,@movie2])
      @movies = @movie1.find_similar
      @movies.each do |a_movie|
        a_movie.director.should == 'Director 1'
      end
      @movies.should_not include @movie1
    end  
    it 'should raise an NoMoviesFoundError when there are no other movie directed by the given movie director' do
      lambda {@movie3.find_similar}.
        should raise_error(Movie::NoMoviesFoundError)
    end
  end
  describe 'raising Error when the movie has no director' do
    before :each do
      @movie1 = Movie.create!(:title => 'Movie 1')
    end
    it 'should raise an NoMoviesFoundError when the given movie has no value for director' do
      lambda {@movie1.find_similar}.
        should raise_error(Movie::NoDirectorInfoError)
    end
    it 'should raise an NoMoviesFoundError when the given movie has empty string value for director' do
      @movie1.update_attribute(:director, "")
      lambda {@movie1.find_similar}.
        should raise_error(Movie::NoDirectorInfoError)
    end
  end
end

#    it 'should call Tmdb with title keywords given valid API key' do
#      TmdbMovie.should_receive(:find).
#        with(hash_including :title => 'Inception')
#      Movie.find_in_tmdb('Inception')
#    end
#    it 'should raise an InvalidKeyError with no API key' do
#      Movie.stub(:api_key).and_return('')
#      lambda { Movie.find_in_tmdb('Inception') }.
#        should raise_error(Movie::InvalidKeyError)
#    end
#    it 'should raise an InvalidKeyError with invalid API key' do
#      TmdbMovie.stub(:find).
#        and_raise(RuntimeError.new("API returned status code '404'"))
#      lambda { Movie.find_in_tmdb('Inception') }.
#      should raise_error(Movie::InvalidKeyError)
#    end
#  end
#end

