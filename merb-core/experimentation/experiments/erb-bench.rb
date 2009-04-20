require File.join(File.dirname(__FILE__), "..", "..", "lib", "merb-core")
require "rubygems"
require "rbench"

class Array
  alias_method :concat, :<<
end

class Erubis::ArrayEruby < Erubis::BlockAwareEruby
  def add_preamble(src)
    src << "_old_buf, @_erb_buf = @_erb_buf, []; "
    src << "@_engine = 'erb'; "
  end

  # :api: private
  def add_postamble(src)
    src << "\n" unless src[-1] == ?\n      
    src << "_ret = @_erb_buf; @_erb_buf = _old_buf; _ret.join;\n"
  end
end

class Context
  def initialize
    @hello = "Hello world"
  end
  
  def helper1
    "Hello!"
  end
  
  def helper2
    old, @_erb_buf = @_erb_buf, ""
    yield
    ret = @_erb_buf
    @_erb_buf = old
    "<div>#{ret}  </div>\n"
  end
end

text = <<-HTML
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-type" content="text/html; charset=utf-8">
  <title>ERB</title>
  
</head>
<body>
  Text only!
</body>
</html>
HTML

basic = <<-HTML
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-type" content="text/html; charset=utf-8">
  <title>ERB</title>
  
</head>
<body>
  <%= @hello %>
  <%= helper1 %>
  Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  <%= helper1 %>
  Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  <%= helper1 %>
  Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  <%= helper1 %>
  Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
</body>
</html>
HTML

blocks = <<-HTML
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-type" content="text/html; charset=utf-8">
  <title>ERB</title>
  
</head>
<body>
  <%= @hello %>
  <%= helper1 %>
  <%= helper2 do %>
    <%= helper1 %>
  <% end =%>
  <%= helper1 %>
  Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  <%= helper1 %>
  Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  <%= helper1 %>
  Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  <%= helper1 %>
  Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.  
</body>
</html>
HTML


def define_template(name, template, line)
  code = "def #{name}(_locals={}); #{template.src}; end"
  # puts name
  # puts "---"
  # puts code
  Context.module_eval code, __FILE__, line
end

define_template("text", Erubis::BlockAwareEruby.new(text), 36)
define_template("basic", Erubis::BlockAwareEruby.new(basic), 51)
define_template("blocks", Erubis::BlockAwareEruby.new(blocks), 67)

define_template("array_text", Erubis::ArrayEruby.new(text), 36)
define_template("array_basic", Erubis::ArrayEruby.new(basic), 51)
define_template("array_blocks", Erubis::ArrayEruby.new(blocks), 67)


(ARGV[0] || 1).to_i.times do
RBench.run(100_000) do
  column :normal
  column :array
  
  report("text") do
    normal { Context.new.text }
    array { Context.new.array_text }
  end
  report("basic") do
    normal { Context.new.basic }
    array { Context.new.array_basic }
  end
  report("blocks") do
    normal { Context.new.blocks }
    array { Context.new.array_blocks }
  end  
end
end