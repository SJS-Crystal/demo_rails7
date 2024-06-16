FROM ruby:3.1.2

RUN mkdir -p /home/project
WORKDIR /home/project
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install -j $(nproc)
RUN bundle lock --add-platform arm64-darwin-22
RUN bundle lock --add-platform aarch64-linux
RUN bundle lock --add-platform x86_64-linux
COPY . .
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
CMD ["rails", "s", "-p", "3000", "-b", "0.0.0.0"]
