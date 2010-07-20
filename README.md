# Hermes Server

Hermes is a minimal path-finding developed in Ruby on Rails using as backend PostGIS.

Hermes is the great messenger of the gods in Greek mythology and additionally as a guide to the Underworld. An Olympian god, he is also the patron of boundaries and of the travelers who travel across them.

## Prerequisites

To run the project you will need PostgreSQL and PostGIS extension in your system, you can look in internet for guides like this for <a href="http://techblog.strange-quark.com/gis/postgis-installation">Ubuntu Linux</a>, or this for <a href="http://www.lincolnritter.com/blog/2007/12/04/installing-postgresql-postgis-and-more-on-os-x-leopard/">Mac OSX</a>

You will need postgresql library for Ruby also:

   $ sudo gem install postgresql

## Initial Config
Put your Google Maps API Key in config/gmaps_api_key.yml and setup your database configuration in config/database.yml

You can run the server locally:

    $ rake gems:install #=> Install required dependencies the first time
    $ rake db:create #=> Create the database if you don't already
    $ rake db:migrate #=> Create application database tables
    $ script/server #=> Start Rails App