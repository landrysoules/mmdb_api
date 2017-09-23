FROM ruby:2.4.2-jessie
MAINTAINER Landry Soules
RUN apt-get update && apt-get install -qq -y build-essential --fix-missing --no-install-recommends
ENV INSTALL_PATH /mmdb_api
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY Gemfile Gemfile
RUN bundle install

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . .
CMD rails server
