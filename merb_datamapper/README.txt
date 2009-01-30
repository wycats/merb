= merb_datamapper

A plugin for the Merb framework that provides DataMapper access

== Features

* Automatic connection to a data-store through DataMapper, via database.yml
* Easy use of multiple repositories.
* Generators for models, controllers and migrations.
* Sessions stored in a data-store managed by DataMapper
* wraps actions in DataMapper repository blocks, to enable the IdentityMap

=== Sessions

To use sessions:

1. set the session store to datamapper in init.rb:
    Merb::Config.use { |c|
      c[:session_store] = 'datamapper'
    }

2. add the dependency in init.rb:
    use_orm :datamapper

Sessions can be configured by a few plugin options:

[:session_storage_name] The name of the table to use to store the sessions (defaults to 'session')
[:session_repository_name] The repository to use for sessions. (defaults to <tt>:default</tt>)

=== Repository Blocks

Repository Blocks are a DataMapper feature, which enables the use of the
DataMapper IdentityMap, which can help with certain DataMapper features such as
strategic eager loading.  Read on http://www.datamapper.org for more information
on these features.

If, for whatever reason, it doesn't suit you, it can be disabled via setting the
<tt>:use_reposity_block</tt> option to <tt>false</tt>.

    Merb::Plugins[:merb_datamapper][:use_reposity_block] = false
