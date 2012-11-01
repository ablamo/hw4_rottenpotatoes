Feature: add movies to RottenPotatoes
 
  As a movie buff
  So that I can maintain my list of movies
  I want to be able to add new movies
 
Background: movies in database
 
  Given the following movies exist:
  | title        | rating | director     | release_date |
  | Star Wars    | PG     | George Lucas |   1977-05-25 |
  | Blade Runner | PG     | Ridley Scott |   1982-06-25 |
  | Alien        | R      |              |   1979-05-25 |
  | THX-1138     | R      | George Lucas |   1971-03-11 |


Scenario: add a new movie
  When I am on the new movie page
  And  I fill in "Title" with "Fake title"
  And  I select "G" from "Rating"
  And  I press "Save Changes"
  Then I should be on the home page
  And I should see "Fake title"


