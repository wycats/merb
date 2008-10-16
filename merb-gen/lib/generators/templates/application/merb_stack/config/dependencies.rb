merb_gems_version = "<%= merb_gems_version %>"
dm_gems_version   = "<%= dm_gems_version %>"

dependency "merb-action-args", merb_gems_version  # Provides support for querystring arguments to be passed in to controller actions
dependency "merb-assets", merb_gems_version        # Provides link_to, asset_path, auto_link, image_tag methods (and lots more)
dependency "merb-cache", merb_gems_version         # Provides your application with caching functions 
dependency "merb-helpers", merb_gems_version       # Provides the form, date/time, and other helpers
dependency "merb-mailer", merb_gems_version        # Integrates mail support via Merb Mailer
dependency "merb-slices", merb_gems_version        # Provides a mechanism for letting plugins provide controllers, views, etc. to your app
dependency "merb-auth", merb_gems_version          # An authentication slice (Merb's equivalent to Rails' restful authentication)
dependency "merb-param-protection", merb_gems_version
 
dependency "dm-core", dm_gems_version         # The datamapper ORM
dependency "dm-aggregates", dm_gems_version   # Provides your DM models with count, sum, avg, min, max, etc.
dependency "dm-migrations", dm_gems_version   # Make incremental changes to your database.
dependency "dm-timestamps", dm_gems_version   # Automatically populate created_at, created_on, etc. when those properties are present.
dependency "dm-types", dm_gems_version        # Provides additional types, including csv, json, yaml.
dependency "dm-validations", dm_gems_version  # Validation framework
