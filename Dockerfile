FROM seapy/ruby:2.2.0
MAINTAINER ChangHoon Jeong <iamseapy@gmail.com>

RUN apt-get update

# Install nodejs
RUN apt-get install -qq -y nodejs

# Intall software-properties-common for add-apt-repository
RUN apt-get install -qq -y software-properties-common

# Install Nginx.
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get install -qq -y nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx
# Add default nginx config
ADD nginx-sites.conf /etc/nginx/sites-enabled/default

# Install Rails App
USER app
WORKDIR /home/app
ONBUILD ADD Gemfile /home/app/Gemfile
ONBUILD ADD Gemfile.lock /home/app/Gemfile.lock
ONBUILD RUN bundle install --without development test

# Add default unicorn config
ADD unicorn.rb /home/app/config/unicorn.rb

ENV RAILS_ENV production

CMD bundle exec rake assets:precompile

ADD docker-entrypoint.sh /home/app/docker-entrypoint.sh
RUN sudo chmod +x /home/app/docker-entrypoint.sh
ADD setup.sh /home/app/setup.sh
ENTRYPOINT /home/app/docker-entrypoint.sh