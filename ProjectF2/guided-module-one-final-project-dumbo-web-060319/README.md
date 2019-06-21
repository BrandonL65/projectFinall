# Module One Project 

Congratulations, you're at the end of module one! You've worked crazy hard to get here and have learned a ton.

For your final project, we'll be building a Command Line database application.

### Goals for the Command Line CRUD App

1. Build at least three models with corresponding tables, including a join table
2. Access a Sqlite3 Database using ActiveRecord
3. Build out a CLI that allows users to interact with your database
4. Use good OO design patterns. You should have separate models for your runner and CLI interface.

## Instructions

### Set Up and Planning
1. Fork and clone the module one final project. The person who forked the lab should share the link with their teammate(s) to clone, and add them as collaborators. As you work, be sure to create a flow of creating a branch, committing and pushing it up to master, merging, and having teammates pull down the new master.
2. Before you start building, take a look at the files you have available in this repo.
    * In the main directory, you've got a gemfile that gives you access to activerecord, pry, rake, and sqlite3. Remember to bundle install!
    * In the bin directory, you've got a run.rb file that you can run from the command line with ```ruby bin/run.rb.```
    * In config, you've got your database set up with activerecord, as well as all of your models from the lib file made available to your database.
    * In the lib directory, you'll be building all your models.
    * Note that there is no spec directory. Your goal is to use Behavior Driven Development to confirm that your code is doing what it should. This means instead of running rspec or learn, you should frequently be opening up the rake console and confirming that your methods and associations work.

3. Your first goal should be to decide on your models and determine the relationships between them. You'll need one many-to-many relationship.
  Here are some ideas:
    * Train Line, Station, Station Lines: A line has many stations and a station has many lines, station_lines belongs to line and station
    * Movie, Actor, Movie Actors: A movie has many actors and an actor has many movies, movie_actors belongs to movie and actor
    * Tweet, Topic, Tweet topics: A tweet has many topics and a topic has many tweets, tweet_topic belongs to tweet and topic

    Whiteboard out your ideas and think about what columns you'll want in the corresponding tables, including foreign keys. Where are foreign keys stored in a many-to-many relationship? **Get your data modeling approved by an instructor before moving on to the next step.**

### Data Models    
4. Make a new file for each model in your lib folder. What's the naming convention for a model filename? Check out previous labs for a reminder. Remember that activerecord gem from our gemfile? Make sure that every model inherits from activerecord base.
5. Be sure to include the relationships between your models. The <a href="http://guides.rubyonrails.org/association_basics.html">activerecord documentation</a> is a great source if you get stuck! Check out the ```has_many :through``` section when setting up your many-to-many relationship.

### Migrations
6. Create your database and migrations in the terminal (keeping in mind that you have Rake available to you! Run ```rake -T``` in your terminal for a refresher.) What are the naming conventions for migration files and table names?
7. Now is a great time top open up your console in the terminal and make sure everything's working properly. Your database is empty at this point, so start by creating a new row in your table. For the train example, we'd do something like this:
```
fulton = Station.create(name: "Fulton")
```
You should see the station inserted into your database. Cool! Now let's test our relationships:
```
a = Line.create(name: "A")
fulton.lines << a
```
Woah! What did we just do there? The first part is simple: we added the a line to our line table. Then, we accessed our station, Fulton Station, and accessed its array of lines. (Because a station has many lines, right?) Finally, we pushed the A line into Fulton's lines. Amazing!! High fives all around.

![celebration](https://media.giphy.com/media/Is1O1TWV0LEJi/giphy.gif)

### Seeding the Database
8. At this point, we could continue adding items to our database through the console, but let's be real. There are 425 train stations in New York--entering them individually would take forever!! There must be a better way...

Enter the seeds file. What is a seed file? It's a file, located in the db folder, where you create new instances of your classes and save them to your database. There are several ways this could happen. You could iterate over as csv file, for example, pulling out relevant data, and creating a new row in your database for every row in the file.

For now, let's just manually create some objects, and set up the relationships between them. You can do it in exactly the same way we did in the console.

```
z = Line.create(name: "Z")

broad = Station.create(name: "Broad Street")

# how could we add associations between the c line and broad street
# station?

```

You'll want to make sure you have enough data to play around with once you get your command line interface up and running. Five to ten instances of each model, as well as the corresponding relationships should be enough. You can always add more later.

Once your file is ready, run ```rake -T``` to see which rake task you can use to seed your database.


### CLI
9. Okay, so we've got our databases; we've got our models; and we've got our relationships set up between them. Now, what do we do with all this stuff? We don't want our users to have to use the console every time they want to see which train lines go through fulton station, so let's create a command line interface!

First things first, open up the runfile and create a method that greets our app user. Then, let's call the method.
```
def greet
  puts 'Welcome to TrainFinder, the command line solution to for your MTA train-finding needs!"
end

greet
```
Now, let's run the file from the terminal with ``` ruby bin/run.rb ```.

We should see our welcome message printed. Rad!! But wait--why are we defining this method in the runfile? Isn't that going to get messy? Answer: yes.

10. Instead, let's create a Command Line Interface model in our lib directory. This model won't have a corresponding table, it's just going to be a place for us to write methods relating to the interface of our app. Now, let's move the greet method definition into the Command Line Interface model.

Now, our ```bin/run.rb``` should create a new instance of our Command Line Interface model and call the instance method, greet.

```
new_cli = CommandLineInterface.new
new_cli.greet
```
Run ```ruby bin/run.rb``` to make sure everything works!

11. Alright, we've greeted our user, but so far we haven't given them any information that we worked so hard to store in our database. Let's give them some of our valuable data! First things first: how should we decide what to show our users? It would probably be overwhelming if we printed out every train line for every station in New York city, so let's ask the user which station they'd like to see lines for.

Create a new method in the Command Line Interface model:

```
def gets_user_input
  puts "We can help you find which train lines are available at NYC subway stations."
  puts "Enter a subway station to get started:"
  #what could we put here to allow a user to type a response?
end
```

Now, call it from the run file and run your app to make sure everything works!

12. So, we've gotten an input from our user, but what do we do with the it?

First let's think big picture: our goal is to take the user's input--a string of a station name--and use that station name to find a station in our database. Then we want to grab all of that station's lines and output the lines to our user.

Now let's think about how we'll code out this process: first, we want a method that uses the station name to query our database, right? Know any activerecord methods we could use to find a station by its name?


Think on it....



Keep thinking....



Alright, have you got an idea?

Is it this activerecord method?

```
  Station.find_by(name: station)
```

Nice!

Now, create a method that takes the user's input as an argument, and passes that variable to ```find_by```, returning the station from your database.

Okay, so now we can find our station, but how do we hand off the user's input to the find station method?

We could do something like this in our run file...
```
new_cli = CommandLineInterface.new
new_cli.greet
input = new_cli.gets_user_input
new_cli.find_station(input)
```
...BUT LET'S NOT!

Instead, let's move our individual method calls from the run file to a runner method in our Command Line Interface model.

```

def run
  greet
  input = gets_user_input
  find_station(input)  
end

```
And let's change our run file to just call the run method.

13. So, we can greet our user, grab their input, and use that input to find a station. We're on the home stretch, but there are a few things left to do. First, we need to find the lines associated with the station, and then we need to output the lines to the user.

First, let's make a method to access the station lines and add it to our run file:

```
def find_lines(station)
  station.lines
end

```
The find lines method takes in an instance of station and returns that station's lines. How can we pass the station that we found in ```find_station``` as the argument in ```find_lines```? How about in our run method!

Lets set the return value of find_station to a variable and pass that variable to the ```find_lines``` method.


14. Finally, let's output those lines to our users! Create a method that iterates over lines and outputs the line name to the console!

```
def show_lines(lines)
  lines.each do |line|
    #how could we output each line's name here?
   end
end
```

Now, add this method to the run method, and pass it the lines we got in the ```find_lines method```. Finally, run ```ruby bin/run.rb```. Woot, woot! We've got a working 'skateboard' version of our app!!

![party](https://media.giphy.com/media/l0MYt5jPR6QX5pnqM/giphy.gif)
## Next Steps
  How can we improve on our CLI app to have a motorcycle version and eventually a cadillac convertible version? Lots of ways!
  * Format the output of train lines to be less bland. Perhaps the lines could be separated with commas, or interpolated to read 'A line'.
  * Look for a <a href="http://web.mta.info/developers/data/nyct/subway/StationEntrances.csv">.csv file</a> or API that we can use to seed our database with lots and lots more data. How could you seed a database with rows from a csv file or with JSON data from an API?
  * Find a way for our program to not break if a user inputs a station name IN ALL CAPS, or if their cat walks over the keyboard and enters "sfudihdsuifhsidu."
  * Build out full CRUD functionality for one of our models from the command line.
  * Allow the user to do multiple searches without having to run the app each time. What if they want to seach fifty different stations and then exit the app midway through a search?
  * Add functionality using our existing data. In the console, we can find all the stations associated with a train line. How can we build that into our interface?
  * Once a user choses a train line, open an mta web page corresponding with their selected line in the user's browser.
  * Use a gem jazz up the look of our app with <a href="https://github.com/miketierney/artii">ascii text</a> or <a href="https://rubygems.org/gems/colorize/versions/0.8.1">colors</a>.

## Final Steps
* Prepare a demo video describing how a user would interact with your working project.
    * The video should:
      * Have an overview of your project.(2 minutes max)
* Prepare a presentation to follow your video.(3 minutes max)      
    * Your presentation should:  
      * Describe something you struggled to build, and show us how you ultimately implemented it in your code.  
      * Discuss 3 things you learned in the process of working on this project.
      * Address, if anything, what you would change or add to what you have today?
      * Present any code you would like to highlight.
* OPTIONAL, BUT RECOMMENDED: Write a blog post about the project and process.



<p class='util--hide'>View <a href='https://learn.co/lessons/guided-module-one-final-project'>Guided Module One Final Project</a> on Learn.co and start learning to code for free.</p>
