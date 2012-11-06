# Simple Todo List

This is my take on building a ruby app based on [Entity-Boundary-Interactor pattern](http://www.youtube.com/watch?v=WpkDN78P884).  I've heard about deferring persistence until it's needed, but I never thought about deferring the framework as well. Basically, Uncle Bob suggests that if you start a project by running, "rails myproject", that you are doing it wrong.  The more I thought about this, the more I started to agree.

I am big on Test Driven Development, and I want my tests to be "FAST".  Even a fresh rails project is a little too slow for my taste on start.  I want my tests to feel as if they finish before I finishing type "rake".

## The Rails App

Added a simple rails app that uses this code, it can be viewed at [simple-todo-rails](https://github.com/graemenelson/simple-todo-rails).