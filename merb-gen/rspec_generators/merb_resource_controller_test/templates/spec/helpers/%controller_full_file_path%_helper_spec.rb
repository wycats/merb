require File.join(File.dirname(__FILE__), "<%= Array.new((controller_modules.size + 1),'..').join("/") %>", 'spec_helper.rb')

describe Merb::<%= full_controller_const %>Helper do

end