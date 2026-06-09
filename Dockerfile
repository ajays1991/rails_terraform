FROM ruby:3.0

ENV PATH /root/.yarn/bin:$PATH

ARG build_without
ARG rails_env
RUN apt-get update -qq && apt-get install -y binutils curl git gnupg cmake python python-dev postgresql-client supervisor tar tzdata
RUN apt-get install -y apt-transport-https apt-utils
RUN apt-get update && \
    apt-get install -y nodejs npm
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn
RUN mkdir /rails_terraform_docker
COPY . /rails_terraform_docker
WORKDIR /rails_terraform_docker

RUN gem install bundler -v 2.4.22

RUN bundle install
RUN yarn install

RUN DISABLE_BOOTSNAP=1 bundle exec rake assets:precompile

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 80

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "80"]