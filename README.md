# Steps are necessary to get the application up and running



## System dependencies
- Ruby version: 3.1.2
- Rails 7
- Posgresql

## Prerequirement
1. Docker Compose


## How to setup and get up
1. `docker-compose run web rails db:migrate`
2. `docker-compose run web rails db:seed`
3. `docker-compose run web rails db:generate_sample_data` (Optional)
4. `docker-compose up`  => http://0.0.0.0:3000/ (login with admin@example.com/123123)

## How to run the test suite
- Rspec:
```sh
docker-compose run web bundle exec rspec
```

- Rubocop:
```sh
docker-compose run web bundle exec rubocop
```

## Services (job queues, cache servers, search engines, etc.)

## Deployment instructions
