# Sites
A framework for Ruby on Rails web framework inspired by Django site fremework.
The idea of this gem to transparently make Rails apps to work with different domains.

## What is BODEV?

BODEV is the open-sourced work produced by the development staff at [Buildout, Inc](https://buildout.com). This library was originally forked from [Yellowen](https://github.com/Yellowen/site_framework), but appears to be no longer supported. The concept, however, is still valid ([Django still supports their implementation](https://docs.djangoproject.com/en/2.2/ref/contrib/sites/)), so we're taking ownership of the library and publishing our fork with updates for continued usage.

## Installation

Add `bodev-sites` to your `Gemfile`:

```ruby
gem "bodev-sites", require: "SiteFramework"
```

and after installing your project dependencies using `bundle install` command. Install
**SiteFramework** migrations like:

```bash
rake site_framework:install:migrations
```

That's it.

## Usage

**SiteFramework** provides to solution to multi-site support.

In both solution you have to add a migration for your tables and
make them domain aware (ActiveRecord Only). e.g in your migration:

```ruby
# Make posts table domain aware
site_aware(:posts)
```

If you're using **Mongoid** just add a reference to **SiteFramework::Domain** in your model.

When a request arrives to the Rails application `SiteFramework` will add three different
methods to `Rails.application`.

* **domain**: An instance of `SiteFramework::Domain` model which refer to current domain of
the request
* **domain_name**: Current domain as string.
* **Site**: An instance of `SiteFramework::Site` model which refer to current site.


### A) Rack middleware:
Simply add `SiteFramework::Middleware` to your middleware stack.

### B) Constrants
Just use `sites` DSL in your `routes.rb`. e.g:

```ruby
Rails.application.routes.draw do

  # Share routes
  get 'home/index'

  # All the routes defined in this section will be domain aware.
  sites(self) do
    root 'home#index'
  end

  default_site(self) do
    # routs for default site
  end
end
```
Note: You can provide default domains for **SiteFramework** via an
initializer like this:

```ruby
SiteFramework::Engine.setup do |config|

  config.default_domains = ['localhost', 'example.com']

end
```

**Personally I prefer this (B) option since it's more Railish.**

### Access Current Site and Domain in Controllers
After installing `site_framework` you'll have `site`, `domain` and `domain_name` methods
on your `request` objects to access the respected models. But if current request belongs
to default site the return value of these methods would be `nil`

### Access Current Site/Domain elsewhre
You can access to current `site`, `domain` and `domain_name` via `SiteFramework::CurrentState` object
every where just like this:

```ruby
SiteFramework::CurrentState.instance.site
SiteFramework::CurrentState.instance.domain
SiteFramework::CurrentState.instance.domain_name

# or

SiteFramework.current_site
SiteFramework.current_domain
SiteFramework.current_domain_name
```

In case of default site these methods will return `nil`

### Model Concern
**SiteFramework** provides an **ActiveSupport** concern which transparently
makes your models aware of the current **Site** and **Domain**. By includeing
`SiteFramework::SiteAware` into your model, default scope of your model will
change to return only records which belongs to current **Site**.

This way you can use external gems with your multi-site application easily.
All you have to do is to open there models and include the given concern.

Piece of cake. right?

### Default template
Since `v4.0` site model contains a field aka `default_template` which is blank by default.
By default if current request does not belongs to default site and `default_template` is not
blank, **site framework** will prepend the `default_template` to `view_path` of your application.

By this feature each site can have their own set of views.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credit
![Buildout](https://www.buildout.com)

**bodev-sites** development is currently being funded and maintained by Buildout.

Original implementation provided by Yellowen.

# License
**bodev-sites** is Copyright © 2019 Buildout, Inc. It is free software and may be redistributed under the terms specified in the LICENSE file.
