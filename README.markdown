# Hoboken
Leverages the ruby framework sinatra to provide a very(!) basic wiki.

## Required Gems
* dm-core
* dm-is-versioned
* dm-timestamps
* haml
* sinatra
* wikitext

dm-is-versioned and dm-timestamps are part of dm-more.  You'll need at least 0.9.7.  You also need a dm compatible database adapter (sqlite3, mysql, etc.).  If you want to use something other than sqlite3, you'll need to edit init.rb until a proper config file system is added.

You can install wikitext from http://github.com/stephenjudkins/ruby-wikitext/tree/master

## How To:

First copy (or rename) config.yml.template to config.yml in the app root.  If you want to use something besides the default datamapper connection string specified in the config you can change it as you wish.  You should then 

    $ rake migrate

To create you're database.  Now you're ready to run.

    $ ruby wiki.rb

then visit:  http://0.0.0.0:4567/ or visit http://0.0.0.0:4567/Whatever to start creating a page named "Whatever"

Standard WikiText applies per the wikitext gem.  Versioning is active, though complex diffs on versions aren't yet available and merging is still rudimentary.

When rendering a wiki page, items that exist in the database as other pages will be automatically linked to.

## NOTE:

if you get complaints along the lines of

    Gem::Exception: can't activate data_objects (= 0.9.7, runtime), already activated data_objects-0.9.9

then you should specify a version of data\_objects (in wiki.rb underneath "require 'sinatra'") like so

    gem 'data_objects', '0.9.7'

## TODO:
* authentication
* diffs on versions