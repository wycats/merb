require File.join(File.dirname(__FILE__), <%= go_up(modules.size + 1) %>, 'spec_helper.rb')

given "a <%= singular_model %> exists" do
  request(resource(:<%= plural_model %>), :method => "POST", 
    :params => { :<%= singular_model %> => {  }})
end

describe "resource(:<%= plural_model %>)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:<%= singular_model %>s))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of speakers" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a <%= singular_model %> exists" do
    before(:each) do
      @response = request(resource(:<%= plural_model %>))
    end
    
    it "has a list of <%= plural_model %>" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      @response = request(resource(:<%= plural_model %>), :method => "POST", 
        :params => { :<%= singular_model %> => {  }})
    end
    
    it "redirects to resource(:<%= plural_model %>)" do
      <%- if orm.to_sym == :datamapper -%>
      @response.should redirect_to(resource(<%= singular_model.capitalize %>.first), :message => {:notice => "<%= singular_model %> was successfully created"})
      <%- elsif orm.to_sym == :activerecord -%>
      @response.should redirect_to(resource(<%= singular_model.capitalize %>.first), :message => {:notice => "<%= singular_model %> was successfully created"})
      <% end -%>
    end
    
  end
end

