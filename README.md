# Bookmarks
### Week 4 afternoon challenge

Practicing some old Ruby / Sinatra fundamentals

Our website will have the following specifications:

-   Show a list of bookmarks
-   Add new bookmarks
-   Delete bookmarks
-   Update bookmarks
-   Comment on bookmarks
-   Tag bookmarks into categories
-   Filter bookmarks by tag
-   Users are restricted to manage only their own bookmarks

We'll be using BDD (Behaviour Driven Development) to deliver this website.

### User Story 1

We wrote our first user story as:

    As a user
    So I can see my saved bookmarks
	I’d like to be able to pull up a list of bookmarks

As a part of this user story we created a simple domain model to act as structure that we'd be aiming for.

<img width="992" alt="Screenshot 2020-11-16 at 14 46 16" src="https://user-images.githubusercontent.com/71782749/99295211-08c24e80-283d-11eb-8ee4-5c8d7fbe0167.png">

First, we made sure that we'd followed [all of the steps](https://github.com/makersacademy/course/blob/master/pills/ruby_web_project_setup_list.md) of setting up a sinatra app, making our feature test pass with the smallest amount of code written.

We refactored our working from a hardcoded array to a Class method def self.all :

    # in lib/bookmark.rb

    class Bookmark
	  def self.all
	     [
	      "http://www.makersacademy.com",
	      "http://www.destroyallsoftware.com",
	      "http://www.google.com"
	     ]
	  end
    end
The app.rb route looks like:

    get '/bookmarks' do
	  @bookmarks = Bookmark.all
	  erb :'bookmarks/index'
    end

The erb iterates over the @bookmarks array using each. This concludes User Story 1.

### User Story 2

```
As a time-pressed user
So that I can save a website
I would like to add the site's address and title to bookmark manager
```

For this our first approach was to create a database in PostgreSQL. Our bookmarks table was created using the following settings:

```
bookmark_manager=# CREATE TABLE bookmarks(id SERIAL PRIMARY KEY, url VARCHAR(60));
```

Downloading PG allowed us to connect to a database within ruby. We altered our self.all method to allow integration with the database. Our method now looks like:

```
class Bookmark
  def self.all
    connection = PG.connect(dbname: 'bookmark_manager')
    result = connection.exec('SELECT * FROM bookmarks')
    result.map { |bookmark| bookmark['url'] }
  end
end
```

In this method we are creating a connection to the database, then calling the correct table using a query. Finally we assigned the query to a variable which we then mapped over to result in an array of urls. By doing this we only had to change the code in our bookmark.rb file, we did not change anything in our erb, spec or app files.

### Setting up Test Environment

You've now setup and are maintaining two databases for Bookmark Manager. Remember to update the README with instructions to create the test database, and run the psql commands for both databases.

```
Connect to psql
Create the database using the psql command CREATE DATABASE bookmark_challenge;
Connect to the database using the pqsl command \c bookmark_challenge;
Run the query we have saved in the file 01_create_bookmarks_table.sql
Setup testing environment
Create the database using the psql command CREATE DATABASE bookmark_challenge_test;
Connect to the database using the pqsl command \c bookmark_challenge_test;
Run the query we have saved in the file 01_create_bookmarks_table.sql
```

### User Story 3
```
As a user
So I can store bookmark data for later retrieval
I want to add a bookmark to Bookmark Manager
```
