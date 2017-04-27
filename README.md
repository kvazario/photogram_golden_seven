# Photogram Golden Seven

## RCAV + CRUD


The goal of this project is to understand how to allow users to generate data for our database tables through their browsers. To do this, you will write one complete database-backed web CRUD **resource**. When we say "resource", we mean:

 - a database table
 - a Ruby class to represent it (called a "model")
 - the complete set of RCAVs that are required for users to interact with it through their browsers

To start with, we'll keep it simple and manage just one resource: photos. Our goal is to build an app that lets users submit URLs of photos and add captions for them, like this:

### [This is the target you should aim to build.](https://photogram-golden-seven-target.herokuapp.com/)

Eventually, we'll add the ability to sign up, upload photos, and follow other users, and we'll wind up building Instagram. But for now, anonymous visitors will simply copy-paste the URLs of images that are already on the Internet.

**We just need to put together everything we've learned about RCAV with everything we've learned about CRUDing models with Ruby.**

Web applications are not much more than a collection of related resources that users can CRUD, so understanding how each of these operations works on one table is essential. **CRUD resources are the legos that the web is built out of.**

At the most basic level, our job when building web apps is to build support for **addresses** that users can visit that, when visited, **trigger controller actions** which perform the interaction that the user wants.

Then we need to give the users a convenient way to visit that URL (there's only two ways: either a link or a form submit button which point to that URL).

## Identify the interface

Go click around the target and try to identify all of the URLs that exist in it. Remember from `omnicalc_params` that every form involves two RCAVs: one to display the form, and a second to process the inputs. You might have to View Source to get all of the URLs.

**For a standard CRUD resource**, we usually support seven actions. **The Golden Seven** actions are:

### Create

 - `"/photos/new"`: displays a blank form to the user
 - `"/create_photo"`: receives info from the new form and inserts a row into the table

### Read

 - `"/photos"`: displays a list of multiple rows
 - `"/photos/4"`: displays the details of one row

### Update

 - `"/photos/4/edit"`: displays a pre-populated form to the user with existing data
 - `"/update_photo/4"`: receives info from the edit form and updates a row in the table

### Delete

 - `"/delete_photo/4"`: removes a row from the table

Now that we've identified the entire interface of the application, we can get started building it!

## Setup

 1. Fork this repository.
 1. Clone your fork.
 1. `cd` in to the application's root folder.
 1. `bundle install`
 1. `rails server`
 1. Open up the code in Atom.

### Standard Workflow

 1. Fork to your own account.
 1. Clone to your computer.
 1. In the GitHub Desktop app, [create a branch for your work](https://help.github.com/desktop/guides/contributing/creating-a-branch-for-your-work/#creating-a-branch).
 1. Open the entire folder you downloaded in Atom.
 1. Make your first change to the code. (You could modify this `README.md` file by adding your username next to the project in the heading, for example.)
 1. In the GitHub Desktop app, create a commit. You *must* type a "summary"; "description" is optional.
 1. Click Publish. Verify that your branch is now visible on your fork at GitHub.com in the "Branch" dropdown.
 1. **Commit and Sync often as you work.**
 1. Make new branches freely to experiment! You can always switch back to an older branch using the dropdown in the Desktop App, and all of your files will instantly snap back to their older state. **So, when in doubt, create a branch**, _especially_ before starting on a new task.
 1. You don't need to merge back into your master branch; in the end, just stay on whatever your best branch is. (In the real world, you would ultimately merge your best branch back into your master branch and deploy it to your production server.)
 1. Run `rails grade` as often as you like to see how you are doing.
 1. You can push commits and `rails grade` right up until the due date.
 1. If you have a question about your code, a great way to get feedback is to open a [Pull Request](https://help.github.com/articles/creating-a-pull-request/). After creating it, if you include the URL of your Pull Request when you post your question, reviewers will be able to easily see the changes you've made and leave comments on each line of your code with suggestions.

## Generate the database table

(Your [CRUD with Ruby guide](https://guides.firstdraft.com/crud-with-ruby.html) will be handy for all CRUD-related portions of this project.)

First, we need an underlying database table to store photos. Lets use a Rails generator to help us write the code to get one:

```bash
rails generate model photo caption:text source:string
```

This is a command line command, not a Ruby expression, so don't attempt to execute it within `rails console`. Run it at a command prompt.

This command will generate two files:

 - A migration file that contains a Ruby script that, when executed, will create a table called "photos" with two columns in it; "caption" and "source".
 - A Ruby class called `Photo` that will represent this table so that we can interact with it easily.

Execute the migration with:

```bash
rails db:migrate
```

You now have a database table!

### Add some data manually

Let's add some rows to it with some Ruby. Jump into `rails console` and do some CRUD with Ruby:

```ruby
Photo.count
Photo.first

p = Photo.new
p.source = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/SQM_GE_289A_Boxcab_Carmelita_-_Reverso.jpg/640px-SQM_GE_289A_Boxcab_Carmelita_-_Reverso.jpg"
p.caption = "Train"
p.save

Photo.count
Photo.first

Photo.find(1)
```

### Pre-populate the table with more data quickly

To save us some time, we've prepared a Ruby script that will repeat the above process 16 times. Run the script with the following command:

```bash
rails db:seed
```

You can re-run this command whenever you want to add 16 more rows to the table (useful if you, for example, delete all of the rows while testing your delete link).

## Implement the Golden Seven

### Stub out all seven RCAVs

Let's quickly complete all seven RCAVs. Here are the routes we'll need for the URLs we identified above, with some sensible sounding controller and action names and somewhat silly flexible segment names:

```ruby
# CREATE
get("/photos/new", { :controller => "photos", :action => "new_form" })
get("/create_photo", { :controller => "photos", :action => "create_row" })

# READ
get("/photos", { :controller => "photos", :action => "index" })
get("/photos/:the_id", { :controller => "photos", :action => "show" })

# UPDATE
get("/photos/:la_id/edit", { :controller => "photos", :action => "edit_form" })
get("/update_photo/:le_id", { :controller => "photos", :action => "update_row" })

# DELETE
get("/delete_photo/:da_id", { :controller => "photos", :action => "destroy_row" })
```

(Your [RCAV Flowchart](https://guides.firstdraft.com/rcav-flowchart.html) guide will be handy for all RCAV-related portions of this project.)

For each one, complete the RCAV. In the view template, simply add an `<h1>Hi</h1>` to prove that you connected the RCAV dots without any bugs.

### READ (index, show)

Our first goal will be to allow users to READ photos -- individual details, and a list of all of them.

 - We'll have to add two routes:
  - `get("/photos/:id", { :controller => "photos", :action => "show" })`
  - `get("/photos",     { :controller => "photos", :action => "index" })`
  - (as well as a route for the bare domain, which also goes to the `index` action)

We'll eventually want links on the index page that lead to the details page of each photo that look like:

 - [http://localhost:3000/photos/1](http://localhost:3000/photos/1)
 - [http://localhost:3000/photos/2](http://localhost:3000/photos/2)
 - [http://localhost:3000/photos/3](http://localhost:3000/photos/3)
 - [http://localhost:3000/photos/4](http://localhost:3000/photos/4)

Hints: Remember your [CRUD with Ruby guide](https://guides.firstdraft.com/crud-with-ruby.html), and what you know about the `params` hash.

### CREATE (new_form, create_row)

We're now done with the "R" in CRUD. Our users can **Read** individual rows and collections of rows from our photos table. But they still have to depend on us to create the data in the first place, through the Rails console or something.

Let's now attack the "C" in CRUD: **Create**. We want to allow users to generate content for our applications; that is almost always where the greatest value lies.

#### new_form

The first step is: let's give the user a form to type some stuff in to. Add the following route:

    get("/photos/new", { :controller => "photos", :action => "new_form" })

**Note: If you add this below the `show` route, Rails will get confused. (Why?) Add this route above the show route instead.**

This action has a very simple job: draw a blank form in the user's browser for them to type some stuff into.

It's been a while since we've done any forms, but let's shake off the rust and craft a form for a photo with two inputs: one for the image's URL and one for a caption. Complete the RCAV and add the following HTML in the view:

```html
<form action="/create_photo">
  <div>
    <label for="source_input">
      Image URL
    </label>

    <input id="source_input" type="text" name="the_source">
  </div>

  <div>
    <label for="caption_input">
      Caption
    </label>

    <input id="caption_input" type="text" name="the_caption">
  </div>

  <button>
    Create Photo
  </button>
</form>
```

It turns out that forms, when submitted, take the values that users type in to the inputs and add them to the request. However, they do it by tacking them on to the end of the URL after a `?`, in what is called a **query string**.

"Query string" is HTTP's name for a list of key/value pairs. The **keys** are the `name`s of the `<input>` tags, and the **values** are what the user typed.

In Ruby, we call a list of key/value pairs a Hash. Same thing, different notation. So

```
?sport=football&color=purple
```

in a URL would translate into something like

```
{ :sport => "football", :color => "purple" }
```

in Ruby.

Why do we care? Well, it turns out that Rails does exactly that translation when it sees a query string show up on the end of one of our URLs.

Rails ignores the query string as far as routing is concerned, and still sends the request to same action... but it puts the extra information from the form into the `params` hash for us!

Alright, we're getting close... there's only one problem left. When a user clicks submit on the form, we probably don't want to go right back to the `new_form` action again. That action's job was to draw the blank form on the screen, and we're right back where we started.

We need a way to pick a different URL to send the data to when the user clicks the submit button. If we could do that, then we could set up a route for that URL, and then in the action for that route, we could pluck the information the user typed from the `params` hash and use it to create a new row in our table.

Fortunately, we can very easily pick which URL receives the data from a form: it is determined by adding an `action` attribute to the `<form>` tag, like so:

```html
<form action="http://localhost:3000/create_photo">
```

Think of the action attribute as being like the `href` attribute of the `<a>` tag. It determines where the user is sent after they click. The only difference between a form and a link is that when the user clicks a form, some extra data comes along for the ride, but either way, the user is sent to a new URL.

Of course, if you click it right now, you'll just see "Hi", since that's all that the action does right now. Let's make it smarter, and process the inputs from the form.

#### create_row

```ruby
get("/create_photo", { :controller => "photos", :action => "create_row" })
```

**Your next job** is to write some Ruby in the `create` action to:

 - create a new row for the photos table
 - fill in its column values by pulling the information the user typed into the form out of the `params` hash
 - save it

Once this action has done its job of adding a row to the table, we have to make a choice: do we display a confirmation message in the view template, or do we simply send the user back to the index page?

If the former, simply add whatever HTML to the view template you think is appropriate. It's usually helpful to at least include a link back to the index page.

If you instead just want to send the user back to the index page immediately, try the following in the action instead of `render`:

```ruby
redirect_to("http://localhost:3000/photos")
```

or just

```ruby
redirect_to("/photos")
```

### DELETE (destroy)

Under each photo on the index page, add a link labeled "Delete". The markup for these links should look like:

```html
<a href="/delete_photo/<%= photo.id %>">Delete</a>
```

Does it make sense how that link is being put together?

When I click that link, the photo should be removed and I should be sent back to the index page.

### UPDATE (edit_form, update_row)

#### edit_form

Under each photo on the index page, there is a link labeled "Edit". The markup for these links should look like:

```html
<a href="http://localhost:3000/photos/<%= photo.id %>/edit">Edit</a>
```

The job of this action should be to display a form to edit an existing photo, somewhat like the `new_form` action.

It's a little more complicated than `new_form`, though, because instead of showing a blank form, you should show a form that's pre-populated with the current values for a particular photo (determined by what's after the slash).

Hint: You can pre-fill an `<input>` with the `value=""` attribute; e.g.,

```html
<input type="text" name="the_caption" value="<%= @photo.caption %>">
```

The `action` attributes of your edit forms should look like this:

```html
<form action="http://localhost:3000/update_photo/4">
```

so that when the user clicks submit, we can finally do the work of updating our database. But the `4` should be dynamic, not hardcoded, so embed some Ruby instead:

```html
<form action="http://localhost:3000/update_photo/<%= @photo.id %>">
```

#### update_row

Add another route:

```ruby
get("/update_photo/:id", { :controller => "photos", :action => "update_row" })
```

The job of this action is to receive data from an edit form, retrieve the corresponding row from the table, and update it with the revised information. Give it a shot.

Afterwards, redirect the user to the details page of the photo that was just edited.

## Rinse and repeat

This is optional, but when I was learning this material, I found sheer repetition to be really helpful in connecting the dots in my brain.

A suggestion: download a fresh copy of this repo again (you can just download the ZIP rather than cloning), and repeat the whole process. Try to rely less on the instructions this time.

Rinse and repeat.

## Conclusion

If we can connect all these dots, we will have completed one entire database-backed CRUD web resource. Every web application is essentially just a collection of multiple of these resources; they are the building blocks of everything we do, and we'll just cruise from here.

Struggle with it; **come up with questions**.
