# Client / Server Team-up: Pairing Ruby on Rails with iOS

This repository contains the sample application for the event [Client / Server Team-up: Pairing Ruby on Rails with iOS](http://www.tokyorubyistmeetup.org/events/2814). A live version of the application is [running here](https://community-board.herokuapp.com/). Also, you can check out the slides: https://speakerdeck.com/pwim/creating-a-restful-api-for-mobile-applications

## Install Dependencies

This guide assumes you are using OSX or Linux. Although it is possible to use Windows, the way to setup your system is substantially different, and for this event is not recommended.

### Ruby

**Ruby 1.9 or higher is required**

If you don't know what Ruby version you have, it probably isn't recent enough. From the command line, you can check what version you are running with `ruby -v`.

The easiest way to use a newer version of Ruby is [RVM](https://rvm.io/), which allows you to manage multiple Ruby versions.

Install RVM by pasting the following into your terminal

    curl -L https://get.rvm.io | bash -s stable --ruby

Install dependencies

    rvm requirements

Install Ruby 2.0.0

    rvm install 2.0.0

### PhantomJS

The integration tests use [Poltergeist](https://github.com/jonleighton/poltergeist) for executing JavaScript. Poltergeist depends on PhantomJS, and instructions for installing it can be found at the [Poltergeist home page](https://github.com/jonleighton/poltergeist). If you do not install PhantomJS, some of the tests will fail, but you will otherwise be able to complete the tutorial.

### Git

Git is a distributed version control system. Your computer most likely has it installed. If you are unsure, you can confirm by typing `git`. If you don't have it installed, you can get it from [Git's home page](http://git-scm.com/).

## Setup the application

Check out a local copy of the application.

    git clone git://github.com/tokyo-rubyist-meetup/community_board_rails.git

Switch to the application directory.

    cd community_board_rails

Assuming you have install RVM, you will asked to trust the .rvm file. Type y to trust it.

    ==============================================================================
    = NOTICE                                                                     =
    ==============================================================================
    = RVM has encountered a new or modified .rvmrc file in the current directory =
    = This is a shell script and therefore may contain any shell commands.       =
    =                                                                            =
    = Examine the contents of this file carefully to be sure the contents are    =
    = safe before trusting it! ( Choose v[iew] below to view the contents )      =
    ==============================================================================
    Do you wish to trust this .rvmrc file? (/tmp/community_board_rails/.rvmrc)
    y[es], n[o], v[iew], c[ancel]> y

Install the bundler gem

    gem install bundler

Install the bundled gems

    bundle install

Setup the database

    rake db:setup

Run the specs to make sure everything is working

    rake

You can start up the local server with

    rails s

Now you should be able to view the application at http://localhost:3000/ in your web browser.

## Deploy application to Heroku

[Heroku](http://www.heroku.com/) is a platform for hosting web applications. Create a free account at Heroku if you don't already have one. Once you've done that, you can create and deploy a heroku application with

    heroku create

Then push it to heroku with

    git push heroku master

Setup the database with

    heroku rake db:setup

Now access your newly created application at the URL that the heroku create command output.

To make debugging easier, you can increase the log level with

    heroku config:add LOG_LEVEL=DEBUG

To follow the logs, use

    heroku logs --tail

## Questions

If you have a question, please [create a new issue](https://github.com/tokyo-rubyist-meetup/community_board_rails/issues/new). If you have any improvements, [create a pull request](https://github.com/tokyo-rubyist-meetup/community_board_rails/pull/new).
