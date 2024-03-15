FROM ruby:3.1.4
# RUN addgroup -S dockergroup -g 503 && adduser -S dockeruser -u 504 -G dockergroup && apk --no-cache add g++ make bash

RUN cp /usr/share/zoneinfo/CET /etc/localtime 
# Install gems
ENV APP_HOME /app
ENV HOME /root

WORKDIR $APP_HOME
COPY ./src ./src/
# WORKDIR $APP_HOME/src/data_collector_gem
# RUN gem build data_collector.gemspec; gem install data_collector-0.41.0.gem

WORKDIR $APP_HOME

# RUN chown -R dockeruser:dockergroup /app
# USER dockeruser:dockergroup

COPY ./Gemfile ./
RUN gem install bundle; bundle install

CMD cd /app/src/; ruby lirias_collector.rb