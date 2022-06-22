# FROM ruby:2.7.6-alpine
# RUN addgroup -S dockergroup -g 503 && adduser -S dockeruser -u 504 -G dockergroup && apk --no-cache add g++ make bash

FROM ruby:2.4.3-alpine
#RUN addgroup -gid 503 dockergroup && adduser --uid 504 dockeruser --group dockergroup && apk --no-cache add g++ make bash
RUN addgroup -S dockergroup -g 503 && adduser -S dockeruser -u 504 -G dockergroup && apk --no-cache add g++ make bash

# Install gems
ENV APP_HOME /app
ENV HOME /root

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN chown -R dockeruser:dockergroup /app
USER dockeruser:dockergroup

COPY ./Gemfile ./
RUN gem install bundler
RUN bundle install
COPY ./src ./src/
