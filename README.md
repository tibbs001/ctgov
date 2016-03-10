# Application:  ctgov

# This application retrieves data from clinicaltrials.gov and stores it in a relational database so that
# the content can by analyzed in aggregate.

# To get started...

#			1.  Install ElasticSearch (but only if you will use/develop the ctgov front-end)
#			2.  Retrieve ctgov from github:  git clone git@github.com:tibbs001/ctgov.git  (prob already done if you're reading this)
#			3.  Change to the directory you just cloned:  cd ctgov
#			4.	Install gems:  bundle install
#			5.  Rename config/database.yml_sample to config/database.yml & specify your site-specific db values.
#			6.  Rename config/secrets.yml_sample to config/database.yml & specify your own base keys.
#			7.  Setup the database:  rake db:setup

#	(Note:  By default, this process will populate the db with a small sample set of studies.
#		When you're ready to populate your db with the full set of studies from clinicaltrials.gov,
#		uncomment the appropriate line in app/models/asker.rb method: url_to_get_all and then
#		run: 'Asker.new.monthly_loader' from a rails console session.)

