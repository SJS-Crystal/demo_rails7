# Steps are necessary to get the application up and running



## System dependencies
- Ruby version: 3.1.2
- Rails 7
- Posgresql

# Use Docker
## How to setup and get up
1. `docker-compose run web rails db:create`
2. `docker-compose run web rails db:migrate`
3. `docker-compose run web rails db:seed` or `docker-compose run web rails db:generate_sample_data`
4. `docker-compose up`

# Don't Use Docker
## Database creation
```sh
rails db:create
```

## Database initialization
- Init data with sample:
```sh
rake db:generate_sample_data
```
OR
- Init only necessary data:
```sh
rake db:seed
```

## Application starting
1. `bundle`
2. `bundle exec rails s`

## How to run the test suite
- Rspec:
```sh
bundle exec rspec
```

## Services (job queues, cache servers, search engines, etc.)

## Deployment instructions
