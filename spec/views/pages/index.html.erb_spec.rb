require 'spec_helper'

describe "pages/index.html.erb" do
  before(:each) do
    assign(:pages, [
      stub_model(Page,
        :title => "Title",
        :slug => "Slug",
        :label => "Label",
        :order => 1,
        :template => "Template",
        :show_in_nav => ""
      ),
      stub_model(Page,
        :title => "Title",
        :slug => "Slug",
        :label => "Label",
        :order => 1,
        :template => "Template",
        :show_in_nav => ""
      )
    ])
  end

  it "renders a list of pages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Label".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Template".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
