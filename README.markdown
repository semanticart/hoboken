# Hoboken
Leverages the ruby framework sinatra to provide a very(!) basic wiki.

## Required Gems
* dm-core
* dm-is-versioned
* dm-timestamps
* haml
* sinatra
* wikitext

dm-is-versioned and dm-timestamps are part of dm-more.  You also need a dm compatible database adapter (sqlite3, mysql, etc.).  If you want to use something other than sqlite3, you'll need to edit init.rb until a proper config file system is added.

## How To:
    $ ruby wiki.rb

then visit:  http://0.0.0.0:4567/ or visit http://0.0.0.0:4567/Whatever to start creating a page named "Whatever"

Standard WikiText applies per the wikitext gem.

## TODO:
* default css template
* add viewing old version
* config files
* reverting to previous versions
* diffs on versions
* specs