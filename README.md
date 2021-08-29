# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

### Ruby version: 2.7.1

### Rails version: 6.0.4

### System configuration
  - Linux / Mac
  - Run 'bundle install' in the root folder to install all the application related dependencies

### Database creation
  - bin/rails db:create

### Database initialization
  - bin/rails db:migrate

### How to run the test suite
  -- bin/rails db:test:prepare
  -- bundle exec rspec

### Documentation:
  - Implemented the assignment with 100% rspec code coverage
  - todo API Error handling is implemented as per jsonapi standards: (https://jsonapi.org/format/#errors)
  - Implemented rails logging using Logstash and logstash-event gems to generate JSON logs in the json_event format
  - Implemented API pagination for Task and Tags API's using pagy & pager_api light weight gems
  - Implemented rubocop - Automatic Rails code style checking tool. A RuboCop extension focused on enforcing Rails best  practices and coding conventions.
  - Implemented brakeman - Brakeman detects security vulnerabilities in Ruby on Rails applications via static analysis

  ### Refactor
    - Refactor with Service Objects
    - Implemented Private methods wherever required
    - Fix N+1 queries issue

  ### Todo: Pending
    - Implement mem / Redis cache
    - Performace test to check the performace of the application
    - Implement bullet gem to check N+1 query issues in the application
    - Find Big-O complexity

### ER Diagram
![Relationship between Task and Tag](task_tag.png?raw=true)

### Rspec code coverage
![Code coverage](coverage.png?raw=true)

### Security check using brakeman
![Security check](brakeman.png?raw=true)
