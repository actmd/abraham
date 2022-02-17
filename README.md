# Abraham

[![Build Status](https://travis-ci.com/actmd/abraham.svg?branch=master)](https://travis-ci.com/actmd/abraham)

_Guide your users in the one true path._

![Watercolor Sheep](https://upload.wikimedia.org/wikipedia/commons/e/e4/Watercolor_Sheep_Drawing.jpg)

Abraham makes it easy to show guided tours to users of your Rails application. When Abraham shows a tour, it keeps track of whether the user has completed it (so it doesn't get shown again) or dismissed it for later (so it reappears in a future user session).

* Define tour content with simple YAML files, in any/many languages.
* Organize tours by controller and action.
* Trigger tours automatically on page load or manually via JavaScript method.
* Built with the [Shepherd JS](https://shepherdjs.dev/) library. Plays nicely with Turbolinks.
* Ships with two basic CSS themes (default & dark) — or write your own

## Requirements

* Abraham needs to know the current user to track tour views, e.g. `current_user` from Devise.
  * If you are using a different method to identify who is currently logged in, you can, for example, add an alias to make it work. Assuming you have a method `current_foo` to identify your currenly logged-in user, you can add `alias_method 'current_user', 'current_foo'` in the place you define `current_foo`.
* Abraham is tested on Rails 5.2, 6.0, and 6.1

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
$ yarn add js-cookie@^2.2.0 shepherd.js@^6.0.0-beta
```

Mount the engine in `config/routes.rb`. It is important to mount Abraham as `abraham`, since the inserted `abraham_tour` partial (below) leverages an isolated named route.

```
mount Abraham::Engine, at: 'abraham'
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

Tell Abraham where to insert the JavaScript partial. This partial sets up the [Shepherd JS](https://shepherdjs.dev/) tour/s.

Generally it is inserted in `app/views/layouts/application.html.erb`, just before the closing `body` tag:

```erb
<%= abraham_tour %>

</body>
</html>
```

## Defining your tours

Define your tours in the `config/tours` directory corresponding to the views defined in your application. Its directory structure mirrors your application's controllers, and the tour files mirror your actions/views. (As of version 2.4.0, Abraham respects controllers organized into modules.)

```
config/
└── tours/
    ├── admin/
    │   └── articles/  
    │       └── edit.en.yml    
    ├── blog/
    │   ├── show.en.yml
    │   └── show.es.yml    
    └── articles/
        ├── index.en.yml
        ├── index.es.yml
        ├── show.en.yml
        └── show.es.yml
```

For example, per above, when a Spanish-speaking user visits `/articles/`, they'll see the tours defined by `config/tours/articles/index.es.yml`.

(Note: You must specify a locale in the filename, even if you're only supporting one language.)

### Tour content

Within a tour file, each tour is composed of a series of **steps**. A step may have a `title` and must have `text`. You may attach a step to a particular element on the page, and place the callout in a particular position.

In this example, we define a tour called "intro" with 3 steps:

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

See below for how to define custom buttons.

When you specify an `attachTo` element, use the `placement` option to choose where the callout should appear relative to that element:

* `bottom` / `bottom center`
* `bottom left`
* `bottom right`
* `center` / `middle` / `middle center`
* `left` / `middle left`
* `right` / `middle right`
* `top` / `top center`
* `top left`
* `top right`

Abraham tries to be helpful when your tour steps attach to page elements that are missing:

* If your first step is attached to a particular element, and that element is not present on the page, the tour won't start. ([#28](https://github.com/actmd/abraham/issues/28))
* If your tour has an intermediate step attached to a missing element, Abraham will skip that step and automatically show the next. ([#6](https://github.com/actmd/abraham/issues/6))

### Automatic vs. manual tours

By default, Abraham will automatically start a tour that the current user hasn't seen yet.
You can instead define a tour to be triggered manually using the `trigger` option:

```yml
walkthrough:
  trigger: "manual"
  steps:
    1:
      text: "This walkthrough will show you how to..."
```

This tour will not start automatically; instead, use the `Abraham.startTour` method with the tour name:

```
<button id="startTour">Start tour</button>

<script>
  document.querySelector("#startTour").addEventListener("click", function() {
    Abraham.startTour("walkthrough"));
  });
</script>
```

...or if you happen to use jQuery:

```
<script>
  $("#startTour").on("click", function() { Abraham.startTour('walkthrough'); })
</script>
```

### Custom buttons

You can define custom buttons in a step like so:

```
my_tour:
  steps:
    1:
      text: "Welcome to my custom button tour"
      buttons:
        1:
          text: 'Show this to me later'
          action: 'cancel'
          classes: 'custom-button shepherd-button-secondary'
        2:
          text: 'Finish now'
          action: 'complete'
          classes: 'custom-button'
```

* `action` is one of the Shepherd tour method names, i.e. `cancel`, `next`, or `complete`
* `classes` are the CSS class names you want applied to the button

### Testing your tours

Abraham loads tour definitions once when you start your server. Restart your server to see tour changes.

If you'd like to run JavaScript integrations tests without the Abraham tours getting in the way, clear the Abraham configuration in your test helper, e.g.

```
Rails.application.configure do
  config.abraham.tours = {}
end
```

## Full example

We provide a [small example app](https://github.com/actmd/abraham-example) that implements Abraham, so you can see it in action.

## Upgrading

### From version 2.3.0 or earlier

Abraham 2.4.0 introduced an updated initializer that supports controllers organized into modules.
Rerun the generator with these options to replace the old initializer:

```
$ rails generate abraham:install --skip-migration --skip-config
```

### From version 1

Abraham v1 was built using Shepherd 1.8, v2 now uses Shepherd 6 – quite a jump, yes.

If you were using Abraham v1, you'll want to take the following steps to upgrade:

1. Update your gem to the latest version
1. Fix your yarn dependencies to use the right versions
1. Shepherd no longer provides a set of themes. Abraham maintains two of the legacy themes: default and dark. You'll want to choose one of those or migrate your theme to the new Shepherd structure.
1. Abraham now exposes the entire Shepherd configuration object, so your `abraham.yml` file should now fully define the `tour_options` value instead of `default_theme`
1. There's been a slight change to `initializers/abraham.rb`. Replace yours with [the latest](https://github.com/actmd/abraham/blob/master/lib/generators/abraham/templates/initializer.rb).

If you have any trouble at all, please [submit an issue](https://github.com/actmd/abraham/issues) for assistance!

## Contributing

Contributions are welcome!

Create a feature branch (using git-flow) and submit as a pull request (with a base branch of `develop`).

Everyone interacting in Abraham's codebase, issue tracker, etc. is expected to follow the [Contributor Covenent Code of Conduct](https://www.contributor-covenant.org/version/1/4/code-of-conduct).

### Getting started with the source code

Abraham uses `rvm` with a gemset to ensure the appropriate version of Ruby and its dependencies. Make sure that's installed before you get started.

```
~ git clone git@github.com:actmd/abraham.git
Cloning into 'abraham'...
~ cd abraham
ruby-2.5.3 - #gemset created /Users/jon/.rvm/gems/ruby-2.5.3@abraham
ruby-2.5.3 - #generating abraham wrappers - please wait
~ bundle install
Bundle complete! 13 Gemfile dependencies, 73 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
~ yarn install
```

### Testing

#### Testing locally

This Rails engine contains a test app called `dummy` with controller and system tests. You can run tests by:

```
~ rake app:assets:precompile
~ rails test
```

Please note that if you change anything in the `lib/generators` folder (i.e. configuration, intializer, migration) you'll need to migrate the `dummy` app accordingly.

Final testing should be done in a standalone Rails app, following the README instructions.

To install the `abraham` gem with a local path:

```
gem 'abraham', path: '~/Workspace/abraham'
```

#### Automated testing

We use GitHub Actions to automatically test this engine with Rails 5.2, 6.0, and 6.1.

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
