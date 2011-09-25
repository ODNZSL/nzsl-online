require "spec_helper"

describe PagePartsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/page_parts" }.should route_to(:controller => "page_parts", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/page_parts/new" }.should route_to(:controller => "page_parts", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/page_parts/1" }.should route_to(:controller => "page_parts", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/page_parts/1/edit" }.should route_to(:controller => "page_parts", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/page_parts" }.should route_to(:controller => "page_parts", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/page_parts/1" }.should route_to(:controller => "page_parts", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/page_parts/1" }.should route_to(:controller => "page_parts", :action => "destroy", :id => "1")
    end

  end
end
