require 'spec_helper'

describe MoviesController do
  before :each do
    @fake_movie = FactoryGirl.build(:movie)
  end
  describe 'removing movies' do
    before :each do
      Movie.stub(:find).and_return(@fake_movie)
      @fake_movie.stub(:title).and_return('Movie 1') 
    end
    it 'should call the model method that performs the remove' do
      @fake_movie.should_receive(:destroy).and_return(true)
      delete :destroy, {:id => '1'}
    end
    describe 'once the movie is deleted' do
      before :each do
        @fake_movie.stub(:destroy).and_return(true)
        delete :destroy, {:id => '1'}
      end
      it 'should redirect to the home page' do
           response.should be_redirect
           response.should redirect_to(movies_path)
      end
      it 'should fill in the flash information with the error message' do
           delete :destroy, {:id => '1'}
           flash[:notice].should == "Movie 'Movie 1' deleted."
      end
    end
  end
  describe 'finding movies with same director' do
    before :each do
      @fake_results = [mock('movie1'), mock('movie2')]
    end
    it 'should call the model method that perfom the find similar movies' do
      Movie.should_receive(:find).with('1').
        and_return(@fake_movie)
      @fake_movie.should_receive(:find_similar).
        and_return(@fake_results)
      get :find_similar, {:id => '1'}
    end
    describe 'after finding similar movies' do
      before :each do
        Movie.stub(:find).and_return(@fake_movie)
	@fake_movie.stub(:find_similar).and_return(@fake_results)
        @fake_movie.stub(:title).and_return('Movie 1') 
        get :find_similar, {:id => '1'}
      end
      it 'should select the Find By Same Director Results template for rendering' do
        response.should render_template('find_similar')
      end
      it 'should make the find results available to that template' do
        assigns(:movies).should == @fake_results
      end
      it 'should make the movie title available to that template' do
        assigns(:movie).should be @fake_movie
      end
    end
    describe 'capturing NoDirectorInfoError with movies whith no director' do
       before :each do
         Movie.stub(:find).and_return(@fake_movie)
         @fake_movie.stub(:find_similar).and_raise(Movie::NoDirectorInfoError) 
         @fake_movie.stub(:title).and_return('Movie 1') 
         get :find_similar, {:id => '1'}
       end
       it 'should redirect to the home page' do
         response.should be_redirect
         response.should redirect_to(movies_path)
       end
       it 'should fill in the flash information with the error message' do
         get :find_similar, {:id => '1'}
         flash[:notice].should == "'Movie 1' has no director info"
       end
    end
  end
end
