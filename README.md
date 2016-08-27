# Ruby on Rails Tutorial: [RSpec](https://github.com/Judahmeek/rspec_vs_minitest/tree/rspec) vs Minitest

To view RSpec version of this repository, visit https://github.com/Judahmeek/rspec_vs_minitest/tree/rspec

##Differences Between RSpec & Minitest
The largest difference between Minitest & RSpec is RSpec's lack of a proper equivalent of `assert_select`.

I had to create some very brittle substring and regex matches to get those tests to pass, most notable in the [User Profile Integration Examples](spec/integration/users_profile_spec.rb)

[Capybara](https://github.com/jnicklas/capybara) solves this issue, as demonstrated here (It's on my to-do list. lol): http://ruby-journal.com/how-to-write-rails-view-test-with-rspec/

##Fixtures vs Factories
To keep the similarities between versions as close as possible, I used fixtures for RSpec instead of [Factory_Girl](https://github.com/thoughtbot/factory_girl).
Both fixtures & factories have pros & cons, and I encourage readers to explore both sides of this issue: https://www.google.com/#q=factory+girl+vs+fixtures

However, if you're going to learn to use RSpec, then you should probably learn to use [Factory_Girl](https://github.com/thoughtbot/factory_girl) & [Capybara](https://github.com/jnicklas/capybara) as well,
since these three gems seem to be used together often. 

Be warned that proper configuration of all three gems together may be non-trivial: http://brandonhilkert.com/blog/7-reasons-why-im-sticking-with-minitest-and-fixtures-in-rails/ (See reason 3)

##Special thanks to Michael Hartl
This is the sample application for the
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](http://www.railstutorial.org/)
by [Michael Hartl](http://www.michaelhartl.com/).