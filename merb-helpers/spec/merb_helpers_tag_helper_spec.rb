require File.dirname(__FILE__) + '/spec_helper'

# Merb::Router.prepare do
#   default_routes
# end

describe Merb::Helpers::Tag do
  include Merb::Helpers::Tag
  
  describe "#tag" do
    it 'generates <div>content</div> from tag :div, "content"' do
      response = get "/tag_helper/tag_with_content"

      response.body.should match_tag(:div)
      response.body.should include("Astral Projection ~ Dancing Galaxy")
    end

    it 'outputs content returned by the block when block is given'  do
      response = get "/tag_helper/tag_with_content_in_the_block"

      response.body.should match_tag(:div)
      response.body.should include("Astral Projection ~ Trust in Trance 1")
    end

    it 'generates tag attributes for all of keys of last Hash' do
      response = get "/tag_helper/tag_with_attributes"

      doc = Hpricot(response.body)
      (doc/"div.psy").size.should == 1
      (doc/"div#bands").size.should == 1
      (doc/"div[@invalid_attr='at least in html']").size.should == 1
    end    

    it 'handles nesting of tags/blocks' do
      response = get "/tag_helper/nested_tags"

      doc = Hpricot(response.body)
      (doc/"div.discography").size.should == 1
      (doc/"div.discography"/"ul.albums").size.should == 1
      (doc/"div.discography"/"ul.albums"/"li.first").size.should == 1

      (doc/"#tit").size.should == 1
      (doc/"#tit").first.inner_html.should == "Trust in Trance 2"
    end
  end
end
