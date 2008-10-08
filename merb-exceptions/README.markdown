merb_exceptions
===============
A simple Merb plugin to ease exception notifications.

The notifier currently supports two interfaces, Email Alerts and Web Hooks. Emails are formatted as plain text and sent using your Merb environment's mail settings. Web hooks as sent as post requests.

Instead of a messy port of a rails plugin this is a complete rewrite from scratch and so is able to take full advantage of Merb's exception handling functionality.

Getting Going
-------------
Once you have the Gem installed you will need to add it as a dependency in your projects `init.rb` file

    dependency 'merb_exceptions'

Configuration goes in `config/plugins.yml` file (which you may need to create). See 'Settings' below for a full description of the options.

    :exceptions:
      :app_name: My App Name
      :email_from: exceptions@myapp.com
      :web_hooks: http://localhost:4000/exceptions
      :email_addresses: 
      - user@myapp.com
      - hello@exceptions.com
      :environments:
        - staging
        - production

The plugin now automatically includes itself into your Exceptions controller. If you are using an old version of this plugin, you can remove the include from your Exceptions controller.

If you have specified any email addresses, and are not already requiring merb-mailer, then you need to do so. It also needs configuration.

    dependency 'merb-mailer'

Settings
--------
`web_hooks`, `email_addresses`, and `environments` can either be a single string or an array of strings.

`app_name`: Used to customise emails and web hooks (default "My App")

`email_from`: Exceptions are sent from this address

`web_hooks`: Each url is sent a post request. See 'Web Hooks' for more info.

`email_addresses`: Each email address is sent an exception notification using Merb's built in mailer settings.

`environments`: Notifications will only be sent for environments in this list, defaults to `production`

Advanced usage
--------------
Including `MerbExceptions::ControllerExtensions` creates an `internal_server_error` action which renders the default exception page and delivers the exception. If you need to rescue any other exceptions or customize the behavior in any way you can write your own actions in `ExceptionsController` and make a call to `render_and_notify`.

For example to be notified of 404's:

    def not_found
      render_and_notify :format => :html
    end

`render_and_notify` - passes any provided options directly to Merb's render method and then sends the notification after rendering.

`notify_of_exceptions` - if you need to handle the render yourself for some reason then you can call this method directly. It sends notifications without any rendering logic. Note though that if you are sending lots of notifications this could delay sending a response back to the user so try to avoid using it where possible.

Web hooks
---------
Web hooks are a great way to push your data beyond your app to the outside world. For each address on your `web_hooks` list we will send a HTTP:POST request with the following parameters for you to consume.

WEBHOOKS FORMATTING IS CURRENTLY BROKEN. WILL POST AN EXAMPLE OF THE CORRECT FORMAT HERE WHEN IT'S FIXED.

Requirements
------------
* Edge Merb

Install
-------
Install gem from github

    sudo gem install newbamboo-merb_exceptions --source=http://gems.github.com

or install from source with

    rake install_gem

Licence
-------
(The MIT License)

Copyright (c) 2008 New Bamboo

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.