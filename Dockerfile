FROM phusion/passenger-ruby22

ENV HOME /home/app

CMD ["/sbin/my_init"]

RUN mkdir -p /etc/my_init.d
ADD docker/etc/my_init.d/slack.sh /etc/my_init.d/slack.sh

# nginx
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD ./docker/etc/nginx/sites-enabled/app.conf /etc/nginx/sites-enabled/app.conf
ADD ./docker/etc/nginx/main.d/app-env.conf /etc/nginx/main.d/app-env.conf
EXPOSE 80

# rails
RUN mkdir -p /usr/src/app
ADD . /usr/src/app
ADD docker/usr/src/app/config/database.yml /usr/src/app/config/database.yml
RUN chown -R app:app /usr/src/app
WORKDIR /usr/src/app

RUN sudo -u app RAILS_ENV=production bundle install --deployment --without test development doc
RUN sudo -u app RAILS_ENV=production bundle exec rake assets:precompile

# clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
