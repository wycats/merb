= merb_datamapper

A plugin for the Merb framework that provides DataMapper access

To use sessions:

1. set the session store to datamapper in init.rb:
    Merb::Config.use { |c|
      c[:session_store] = 'datamapper'
    }

2. add the dependency in init.rb:
    use_orm :datamapper
