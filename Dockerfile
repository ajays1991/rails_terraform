FROM ruby:2.5.3

ENV PATH /root/.yarn/bin:$PATH

ARG build_without
ARG rails_env
RUN apt-get update -qq && apt-get install -y binutils curl git gnupg cmake python python-dev postgresql-client supervisor tar tzdata
RUN apt-get install -y apt-transport-https apt-utils
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn
RUN mkdir /rails_terraform_docker
WORKDIR /rails_terraform_docker
COPY Gemfile /rails_terraform_docker/Gemfile
COPY Gemfile.lock /rails_terraform_docker/Gemfile.lock
RUN gem install bundler -v 2.0.2

COPY app/controllers/application_controller.rb.assets app/controllers/application_controller.rb
COPY app/assets app/assets
COPY public public
COPY config/environments/production.rb.assets config/environments/production.rb
COPY config/initializers/assets.rb config/initializers/assets.rb
COPY config/locales config/locales
COPY config/application.rb.assets config/application.rb
COPY config/environment.rb.assets config/environment.rb
COPY config/boot.rb config/boot.rb
COPY config/database.yml config/database.yml
COPY Rakefile.assets Rakefile
COPY bin bin
COPY config/webpacker.yml config/webpacker.yml
COPY config/webpack/production.js config/webpack/production.js
COPY config/webpack/environment.js config/webpack/environment.js
COPY package.json package.json
COPY app/javascript app/javascript

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