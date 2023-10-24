FROM ruby:3.1.2

RUN mkdir -p /home/assignment
WORKDIR /home/assignment
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install -j $(nproc || sysctl -n hw.ncpu)
COPY . .
CMD rm tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'
