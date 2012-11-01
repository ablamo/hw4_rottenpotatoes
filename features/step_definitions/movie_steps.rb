# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    
    Movie.create!(:title => movie[:title], :release_date => movie[:release_date], :rating => movie[:rating], :director => movie[:director])
  end
end

Then /the director of "(.+)" should be "(.+)"/ do |the_movie, the_director|
   assert Movie.find_by_title(the_movie).director == the_director
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see ["|'](.*)['|"] before ['|"](.*)['|"]/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  regexp = /#{e1}.*#{e2}/m # m means match across newlines
  assert page.body =~ regexp
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  all_ratings = Movie.all_ratings
  selected_ratings = []
  unselected_ratings = []
  if uncheck
    unselected_ratings = rating_list.split(/,\s*/)
    selected_ratings = all_ratings - unselected_ratings
  else
    selected_ratings = rating_list.split(/,\s*/)
    unselected_ratings = all_ratings - selected_ratings
  end
  selected_ratings.each do |select| 
    step %Q{I check "ratings_#{select}"}
  end
  unselected_ratings.each do |select|
    step %Q{I uncheck "ratings_#{select}"}
  end    
end

Then /I should( not)? see the following movies: (.*)/ do |not_see, movie_list|
  proccessed_movie_list = movie_list.split(/['|"]/).reject{ |e| e.empty? || e == ', ' || e== ','}
  proccessed_movie_list.each do |movie|
    step %Q{I should#{not_see} see "#{movie}"}
  end
end

Then /^I should be redirected to (.+)$/ do |page_name|
  # This code works
  #puts page.driver.request.env["HTTP_REFERER"]
  #puts page.driver.status_code
  #puts URI.parse(current_url)
  
# This code Fails:
  #puts "el referer: " + request.headers['HTTP_REFERER']
  #request.headers['HTTP_REFERER'].should_not be_nil
  #request.headers['HTTP_REFERER'].should_not == request.request_uri

  step "I should be on #{page_name}"
end

When /I (un)?check all the ratings/ do |uncheck|
  all_ratings = Movie.all_ratings
  all_ratings_str = ""
  all_ratings.each do |rat|
    all_ratings_str = rat + ", " + all_ratings_str
  end
  all_ratings_str.gsub!(/, $/, '')
  step %Q{I #{uncheck}check the following ratings: #{all_ratings_str}}
end

Then /I should see all of the movies/ do
  elementos = Movie.all.length + 1 # for the header
  assert elementos == page.all('#movies tr').size
end
