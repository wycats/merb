require File.dirname(__FILE__) + '/spec_helper'

describe "merb_param_protection" do
  describe "Controller", "parameter filtering" do
    describe "accessible parameters" do
      class ParamsAccessibleController < Merb::Controller
        params_accessible :customer => [:name, :phone, :email], :address => [:street, :zip]
        params_accessible :post => [:title, :body]
        def create; end
      end

      class ParamsProtectedController < Merb::Controller
        params_protected :customer => [:activated?, :password], :address => [:long, :lat]
        def update; end
      end


      it "should store the accessible parameters for that controller" do
        pending
        @params_accessible_controller = ParamsAccessibleController.new( fake_request )
        @params_accessible_controller.stub!(:initialize_params_filter)

        # FIXME : this call to dispatch is where I break
        @params_accessible_controller.dispatch('create')
        @params_accessible_controller.accessible_params_args.should == {
          :address=> [:street, :zip], :post=> [:title, :body], :customer=> [:name, :phone, :email]
        }
      end

      it "should remove the parameters from the request that are not accessible" do
        pending
        @params_accessible_controller = ParamsAccessibleController.new( fake_request )
        # FIXME : this call to dispatch is where I break
        @params_accessible_controller.dispatch('create')
      end
    end

    describe "protected parameters" do
      before(:each) do
        pending
        @params_protected_controller = ParamsProtectedController.new( fake_request )
        # FIXME : this call to dispatch is where I break
        #@params_protected_controller.dispatch('update')
      end

      it "should store the protected parameters for that controller" do
        @params_protected_controller.protected_params_args.should == {
          :address=> [:long, :lat], :customer=> [:activated?, :password]
        }
      end
    end

    describe "param clash prevention" do
      it "should raise an error 'cannot make accessible'" do
        lambda {
          class TestAccessibleController < Merb::Controller
            params_protected :customer => [:password]
            params_accessible :customer => [:name, :phone, :email]
            def index; end
          end
        }.should raise_error("Cannot make accessible a controller (TestAccessibleController) that is already protected")
      end

      it "should raise an error 'cannot protect'" do
        lambda {
          class TestProtectedController < Merb::Controller
            params_accessible :customer => [:name, :phone, :email]
            params_protected :customer => [:password]
            def index; end
          end
        }.should raise_error("Cannot protect controller (TestProtectedController) that is already accessible")
      end
    end
  end

  describe "param filtering" do
    before(:each) do
      Merb::Router.prepare do |r|
        @test_route = r.match("/the/:place/:goes/here").to(:controller => "Test", :action => "show").name(:test)
        @default_route = r.default_routes
      end
    end

    it "should remove specified params" do
      post_body = "post[title]=hello%20there&post[body]=some%20text&post[status]=published&post[author_id]=1&commit=Submit"
      request = fake_request( {:request_method => 'POST'}, {:post_body => post_body})
      request.remove_params_from_object(:post, [:status, :author_id])
      request.params[:post][:title].should == "hello there"
      request.params[:post][:body].should == "some text"
      request.params[:post][:status].should_not == "published"
      request.params[:post][:author_id].should_not == 1
      request.params[:commit].should == "Submit"
    end

    it "should restrict parameters" do
      post_body = "post[title]=hello%20there&post[body]=some%20text&post[status]=published&post[author_id]=1&commit=Submit"
      request = fake_request( {:request_method => 'POST'}, {:post_body => post_body})
      request.restrict_params(:post, [:title, :body])
      request.params[:post][:title].should == "hello there"
      request.params[:post][:body].should == "some text"
      request.params[:post][:status].should_not == "published"
      request.params[:post][:author_id].should_not == 1
      request.params[:commit].should == "Submit"
      request.trashed_params.should == {"status"=>"published", "author_id"=>"1"}
    end
  end
  
  it "should not have any plugin methods accidently exposed as actions" do
    Merb::Controller.callable_actions.should be_empty
  end

end