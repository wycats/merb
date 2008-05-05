merb-freezer
============

This plugin lets you freeze Merb and run it using the frozen gems. 

Why would you want to freeze Merb?
------------------------------------

* You might have multiple applications on the same server/slice/cluster. Different applications might require different versions of Merb. 

* You might work with a team of developers and want everyone to be using the same Merb version.

* You are using Merb Edge, you want to make sure the production server and your co workers are developing/testing against the same revision.


What are your options?
-----------------------

* You just want to lock your app to a specific version. For instance version merb-core 0.9.3

* You only want to use frozen gems located in /framework or /gems


How to lock your app?
---------------------

_TODO_

How to use frozen gems
----------------------

Instead of starting merb by typing "merb" in your console, type "frozen-merb" and that's it :)
If frozen-merb can't find frozen gems in /framework or /gems then Merb will start normally using the system's gems.

You can also specify the path to use to start your frozen app by passing --merb-root or -m argument and the path to your app. (for god/monit scripts for instance)


How to freeze your gems?
------------------------

In your init.rb file, require this plugin.

    require 'merb-freezer'

You now get a new set of rake tasks:

    rake freeze:core            # Freeze core from git://github.com/wycats/merb...
    rake freeze:more            # Freeze more from git://github.com/wycats/merb...
    rake freeze:plugins         # Freeze plugins from git://github.com/wycats/m...

You can freeze components using 2 modes, Git Submodules or rubygems:

    rake freeze:core MODE=rubygems
or
    rake freeze:core MODE=submodules  (default mode)
    
Wait, that's not it, you can also update your frozen gems using UPDATE=true:


    rake freeze:core UPDATE=true
    
What about your other gems? Same thing, you can do:

    rake freeze:gem GEM=merbful_authentication
    
or 

   rake freeze:gem GEM=git://github.com/ivey/merb-for-rails.git 