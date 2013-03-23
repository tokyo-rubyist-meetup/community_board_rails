# Tutorial

*This tutorial assumes you have already followed the [installation directions](README.md)*

## Step 0: Create a post in a community

Start up the development server. Register a user, create a community, and then post in it.

## Step 1: Returning a list of communities as JSON

We want to be able to get a list of communities like the following in our application.

```
$ curl http://localhost:3000/api/v1/communities.json
{"communities":[{"id":1,"name":"Tokyo Rubyist Meetup","post_count":1}]
```

First, lets create a controller at `app/controllers/api/v1/communities_controller.rb`

```ruby
class Api::V1::CommunitiesController < ApplicationController
  respond_to :json
  def index
    @communities = Community.all
    respond_with @communities
  end
end
```

Then connect the controller in `config/routes.rb`

``` ruby
namespace "api" do
  namespace "v1" do
    resources :communities
  end
end
```

If you fetch `curl http://localhost:3000/api/v1/communities.json` it will already return json in the standard Rails JSON format.

```json
[{"created_at":"2013-03-10T08:15:50Z","id":1,"name":"Tokyo Rubyist Meetup","owner_id":1,"updated_at":"2013-03-10T08:15:50Z"}]
```

Let's customize the JSON to be in the format we want using [active_model_serializers](https://github.com/rails-api/active_model_serializers). Add to your Gemfile

``` ruby
gem "active_model_serializers", "~> 0.7.0"
```

and then `bundle` it.

Use `rails g serializer community id name` to generate `app/serializers/community_serializer.rb`.

Restart rails, and fetch the communities again. This time, the json should look like

``` json
{"communities":[{"id":1,"name":"Tokyo Rubyist Meetup"}]}
```

Now we just need to add the `post_count` to the JSON. Add the attribute `:post_count`, then define a method like

``` ruby
def post_count
  object.posts.count
end
```

To make sure everything is working as expected, you can edit `spec/acceptance/api_spec.rb` and change the community spec marked `pending` to `scenario`. The specs should pass when you run `rspec spec/acceptance/api_spec.rb`.

## Step 2: Returning a list of posts for a community

Create the communities controller at `app/controllers/api/v1/posts_controller.rb`

``` ruby
class Api::V1::PostsController < ApplicationController
  before_filter :load_community
  respond_to :json

  def index
    @posts = @community.posts.new_to_old
    respond_with @posts
  end
end
```

Connect the controller in `config/routes.rb`

``` ruby
namespace "api" do
  namespace "v1" do
    resources :communities do
      resources :posts
    end
  end
end
```

To get the basic attributes, you can create a serializer with the attributes `id` and `text` in the same way you created the community. In addition to the basic attributes, we also want to nest a user object, so we can do things like showing the profile of the person who made the post.

active_model_serializers lets us do this with the `has_one` method. Add `has_one :user` to the `PostSerializer`.

We also want to generate a custom user serializer. In addition to the basic attributes of `id` and `name`, we also want to include the user's avatar. Add an `avatar_url` method to the UserSerializer.

At this point, if you change the `pending` index spec in the "posts" context to `scenario`, the spec should pass.

## Step 3: Adding OAuth using doorkeeper

The client application will need to be authenticated with the API in order to perform certain actions, such as creating a new post. For authentication, we will use the [doorkeeper gem](https://github.com/applicake/doorkeeper) to add OAuth support.

Add doorkeeper to your gemfile

``` ruby
gem 'doorkeeper', "~> 0.6.7"
```

And generate the initializer

```
rails generate doorkeeper:install
```

Open up the initializer. Since we're using [devise](https://github.com/plataformatec/devise), follow the instructions from Doorkeeper's README, and change the `resource_owner_authenticator` to the following

``` ruby
resource_owner_authenticator do
  current_user || warden.authenticate!(:scope => :user)
end
```

To tell Doorkeeper how to authenticate a user through the OAuth Credentials flow, we add the following block [from the doorkeeper wiki](https://github.com/applicake/doorkeeper/wiki/Using-Resource-Owner-Password-Credentials-flow)

``` ruby
resource_owner_from_credentials do |routes|
  request.params[:user] = {:email => request.params[:username], :password => request.params[:password]}
  request.env["devise.allow_params_authentication"] = true
  request.env["warden"].authenticate!(:scope => :user)
end
```

Now let's create the database tables doorkeeper requires by running the following:

```
rails generate doorkeeper:migration
rake db:migrate
```

If you change `pending "OAuth"` to `context "OAuth", all the specs should pass.

## Step 4: Creating new posts

We want to require users to be logged in to create posts, so to our `app/controllers/api/v1/posts_controller.rb`, let's add:

``` ruby
doorkeeper_for :create
```

When creating a post, we want to record the user who creates the post. Rather than having the client tell us which user creates it (which would be a huge security hole), we want to get it from the currently logged in user.

To do this, we need to lookup the user by their OAuth token. To do this, add the following method:

``` ruby
def current_resource_owner
  User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
end
```

For this application, we are controlling what parameters are allowed for creating and updating our models using the [strong_parameters gem](https://github.com/rails/strong_parameters) intead of Rails' default of attr_accessible. strong_parameters will become standard in Rails 4, so this is a good opportunity to get a sneak peak of how things will work.

Using strong_parameters, we whitelist the parameters that are allowed to be used in modifying our models.

For creating a post, we only want to allow something like the following json:

``` json
{ "post" : { "text": "A message" } }
```

To do this, we do the following:

``` ruby
params.require(:post).permit(:text)
```

Now all you need to do is implement the create method itself.

## Step 5: Creating an OAuth Application

The next step is to create an OAuth application that the iOS App will use. Go to http://localhost:3000/oauth/applications

Here we have a dashboard generated by doorkeeper. In a production application, you would normally disable this dashboard or protect it so that only admins could access it.

Click the New Application link, and fill in "iOS Application" for the name of application and "urn:ietf:wg:oauth:2.0:oob" as the redirect URL. The Application Id and Secret will be used by the iOS application to authenticate with our web application.
