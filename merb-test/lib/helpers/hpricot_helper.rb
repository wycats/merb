module Merb::Test::HpricotHelper
  # returns the inner content of
  # the first tag found by the css query
  def tag(css_query)
    process_output
    @output.content_for(css_query)
  end
  
  # returns an array of tag contents
  # for all of the tags found by the
  # css query
  def tags(css_query)
    process_output
    @output.content_for_all(css_query)
  end
  
  # returns a raw Hpricot::Elem object
  # for the first result found by the query
  def element(css_query)
    process_output
    @output[css_query].first
  end
  
  # returns an array of Hpricot::Elem objects
  # for the results found by the query
  def elements(css_query)
    process_output
    Hpricot::Elements[*css_query.split(",").map(&:strip).map do |query|
      @output[query]
    end.flatten]
  end
  
  def get_elements css_query, text
    els = elements(css_query)
    case text
      when String then els.reject! {|t| !t.should_contain(text) }
      when Regexp then els.reject! {|t| !t.should_match(text) }
    end
    els
  end
  
  protected
    # creates a new DocumentOutput object from the response
    # body if hasn't already been created. This is
    # called automatically by the element and tag methods
    def process_output
      if !@block && (@output.nil? || (@controller.body != @response_output))
        @output = HpricotTestHelper::DocumentOutput.new(@controller.body)
        @response_output = @controller.body  
      end
    end
end