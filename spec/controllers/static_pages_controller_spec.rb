require 'spec_helper'

describe StaticPagesController do

  describe "GET 'show'" do
    it "should return 404 if a page cannot be found" do
      get 'show'
      response.status.should == 404
    end


  end

end

