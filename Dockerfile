FROM ruby:2.5.3
ARG build_without
ARG rails_env
RUN apt-get update -qq && apt-get install -y binutils curl git gnupg cmake nodejs python python-dev postgresql-client supervisor tar tzdata yarn
RUN mkdir /rails_terraform_docker
WORKDIR /rails_terraform_docker
COPY Gemfile /rails_terraform_docker/Gemfile
COPY Gemfile.lock /rails_terraform_docker/Gemfile.lock
RUN gem install bundler -v 2.0.2

RUN bundle install

#RUN yarn install

RUN RAILS_ENV=production NODE_ENV=production SECRET_KEY_BASE=not_set OLD_AWS_SECRET_ACCESS_KEY=not_set OLD_AWS_ACCESS_KEY_ID=not_set bundle exec rake assets:precompile

COPY . /rails_terraform_docker

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]