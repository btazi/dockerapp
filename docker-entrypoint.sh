git clone --depth 1 http://bitbucket.org/btazi/dockerapp app

cd app

gem install bundler

bundle exec rake db:migrate

if [[ $? != 0 ]]; then
	echo
	echo "== Failed to migrate. Running setup first."
	echo
	bundle exec rake db:setup && \
	bundle exec rake db:migrate
fi

export SECRET_KEY_BASE=$(rake secret)

sudo service nginx start

bundle exec rake assets:precompile

bundle exec unicorn 