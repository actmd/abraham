# Abraham

_Guide your users in the one true path._

![Watercolor Sheep](https://upload.wikimedia.org/wikipedia/commons/e/e4/Watercolor_Sheep_Drawing.jpg)

Abraham injects dynamically-generated [Shepherd.js](http://github.hubspot.com/shepherd/docs/welcome/) code into your Rails application whenever a user should see a guided tour. Skip a tour, and we'll try again next time; complete a tour, and it won't show up again.

* Define tour content with simple YAML files, in any/many languages.
* Organize tours by controller and action.
* Plays nicely with Turbolinks.

## Requirements

Abraham needs to know the current user to track tour views, e.g. `current_user` from Devise.

## Installation

Add `abraham` and its JavaScript dependencies to your Gemfile:

```
gem 'abraham'

source 'https://rails-assets.org' do
  gem 'rails-assets-shepherd.js', '~> 1.8'
  gem 'rails-assets-js-cookie', '~> 2.1'
end
```

Then run:

```
$ bundle install
$ rails generate abraham:install
```

Require `abraham` in `app/assets/javascripts/application.js`

```
//= require abraham
```

Require a Shepherd.js CSS theme in `app/assets/stylesheets/application.scss`

```
//= require "shepherd.js/dist/css/shepherd-theme-default"
```

Shepherd.js provides the following themes:

- `shepherd-theme-arrows`
- `shepherd-theme-arrows-fix`
- `shepherd-theme-arrows-plain-buttons`
- `shepherd-theme-dark`
- `shepherd-theme-default`
- `shepherd-theme-square`
- `shepherd-theme-square-dark`

Update `config/abraham.yml` if you choose a different theme:

```
defaults: &defaults
  :default_theme: 'shepherd-theme-arrows'
```

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

### Testing your tours

Abraham loads tour definitions once when you start your server. Restart your server to see tour changes.

If you'd like to run JavaScript integrations tests without the Abraham tours getting in the way, clear the Abraham configuration in your test helper, e.g.

```
Rails.application.configure do
  config.abraham.tours = {}
end
```
