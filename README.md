# Steps are necessary to get the application up and running



## System dependencies
- Ruby version: 3.1.2
- Rails 7
- Posgresql

## Database creation
```sh
rails db:create
```

## Database initialization
- Init data:
```sh
rake db:seed
```
OR
- Init data with sample:
```sh
rake db:generate_sample_data
```

## How to run the test suite
- Rspec:
```sh
bundle exec rspec
```

## Services (job queues, cache servers, search engines, etc.)

## Deployment instructions
