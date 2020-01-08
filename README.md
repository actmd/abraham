# Abraham

[![Build Status](https://travis-ci.com/actmd/abraham.svg?branch=master)](https://travis-ci.com/actmd/abraham)

_Guide your users in the one true path._

![Watercolor Sheep](https://upload.wikimedia.org/wikipedia/commons/e/e4/Watercolor_Sheep_Drawing.jpg)

Abraham injects dynamically-generated [Shepherd](https://shepherdjs.dev/) JavaScript code into your Rails application whenever a user should see a guided tour. Skip a tour, and we'll try again next time; complete a tour, and it won't show up again.

* Define tour content with simple YAML files, in any/many languages.
* Organize tours by controller and action.
* Plays nicely with Turbolinks.
* Ships with two basic CSS themes (default & dark) -- or write your own

## Requirements

Abraham needs to know the current user to track tour views, e.g. `current_user` from Devise.

## Installation

Add `abraham` to your Gemfile:

```
gem 'abraham'

```

Install the gem and run the installer:

```
$ bundle install
$ rails generate abraham:install
$ rails db:migrate
```

Install the JavaScript dependencies:

```
$ yarn add jquery@^3.4.0 js-cookie@^2.2.0 shepherd.js@^6.0.0-beta
```

Require `abraham` in `app/assets/javascripts/application.js`

```
//= require abraham
```

Require a CSS theme in `app/assets/stylesheets/application.scss`

```
*= require abraham/theme-default
```

Abraham provides the following themes:

- `theme-default`
- `theme-dark`

Update `config/abraham.yml` if you choose a different theme:

```
defaults: &defaults
  :tour_options: '{ defaultStepOptions: { classes: "theme-dark" } }'
```

You can also [write your own Shepherd theme](https://shepherdjs.dev/docs/tutorial-03-styling.html) based on Shepherd's [default CSS](https://github.com/shipshapecode/shepherd/releases/download/v6.0.0-beta.1/shepherd.css).

Tell Abraham where to insert its generated JavaScript in `app/views/layouts/application.html.erb`, just before the closing `body` tag:

```erb
<%= abraham_tour %>
</body>
</html>
```

## Defining your tours

Define your tours in the `config/tours` directory. Its directory structure should mirror your application's controllers, and the tour files should mirror your actions/views.

```
config/
└── tours/
    └── blog/
    │   ├── show.en.yml
    │   └── show.es.yml    
    └── articles/
        ├── index.en.yml
        ├── index.es.yml
        ├── show.en.yml
        └── show.es.yml
```

NB: You must specify a locale in the filename, even if you're only supporting one language.

### Tour content

A tour is composed of a series of steps. A step may have a title and must have a description. You may attach a step to a particular element on the page, and place the callout to the left, right, top, or bottom.

```yaml
intro:
  steps:
    1:
      text: "Welcome to your dashboard! This is where we'll highlight key information to manage your day."
    2:
      title: "Events"
      text: "If you're participating in any events today, we'll show that here."
      attachTo:
        element: ".dashboard-events"
        placement: "right"
    3:
      title: "Search"
      text: "You can find anything else by using the search bar."
      attachTo:
        element: ".navbar-primary form"
        placement: "bottom"
```

Abraham takes care of which buttons should appear with each step:

* "Later" and "Continue" buttons on the first step
* "Exit" and "Next" buttons on intermediate steps
* "Done" button on the last step

Abraham tries to be helpful when your tour steps attach to page elements that are missing:

* If your first step is attached to a particular element, and that element is not present on the page, the tour won't start. ([#28](https://github.com/actmd/abraham/issues/28))
* If your tour has an intermediate step attached to a missing element, Abraham will skip that step and automatically show the next. ([#6](https://github.com/actmd/abraham/issues/6))

### Testing your tours

Abraham loads tour definitions once when you start your server. Restart your server to see tour changes.

If you'd like to run JavaScript integrations tests without the Abraham tours getting in the way, clear the Abraham configuration in your test helper, e.g.

```
Rails.application.configure do
  config.abraham.tours = {}
end
```

## Full example

We provide a [small example app](https://github.com/actmd/abraham-example) that implements abraham, so you can see it in action.

## Upgrading from version 1

Abraham v1 was built using Shepherd 1.8, v2 now uses Shepherd 6 -- quite a jump, yes.

If you were using Abraham v1, you'll want to take the following steps to upgrade:

1. Update your gem to the latest version
1. Fix your yarn dependencies to use the right versions
1. Shepherd no longer provides a set of themes. Abraham maintains two of the legacy themes: default and dark. You'll want to choose one of those or migrate your theme to the new Shepherd structure.
1. Abraham now exposes the entire Shepherd configuration object, so your `abraham.yml` file should now fully define the `tour_options` value instead of `default_theme`
1. There's been a slight change to `initializers/abraham.rb`. Replace yours with [the latest](https://github.com/actmd/abraham/blob/master/lib/generators/abraham/templates/initializer.rb).

If you have any trouble at all, please [submit an issue](https://github.com/actmd/abraham/issues) for assistance!

## Contributing

Contributions are welcome!

Create a feature branch (using git-flow) and submit as a pull request.

Everyone interacting in Abraham's codebase, issue tracker, etc. is expected to follow the [Contributor Covenent Code of Conduct](https://www.contributor-covenant.org/version/1/4/code-of-conduct).

### Testing

#### Testing locally

This Rails engine contains a test app called `dummy` with controller and system tests. They'll all get run with `rails t`.

Please note that if you change anything in the `lib/generators` folder (i.e. configuration, intializer, migration) you'll need to migrate the `dummy` app accordingly.

Final testing should be done in a standalone Rails app, following the README instructions.

To install the `abraham` gem with a local path:

```
gem 'abraham', path: '~/Workspace/abraham'
```

#### Automated testing

We use TravisCI to automatically test this engine with Rails 5.1, 5.2, and 6.0. For test history, venture over to [TravisCI](https://travis-ci.com/actmd/abraham).

### Releasing

Create a git-flow release:

```
$ git flow release start VERSION_NUMBER
```

Edit `lib/abraham/version.rb` and increase the version number.

Build the gem and push to Rubygems:

```
$ rake build
$ gem push pkg/abraham-VERSION_NUMBER.gem
```

Finish the git-flow release and push to GitHub:

```
$ git flow release finish
$ git push origin develop
$ git push origin master
$ git push --tags
```
