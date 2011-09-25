require 'spec_helper'

describe "page_parts/index.html.erb" do
  before(:each) do
    assign(:page_parts, [
      stub_model(PagePart,
        :title => "Title",
        :order => 1,
        :body => "MyText",
        :translation_path => "Translation Path",
        :page_id => 1
      ),
      stub_model(PagePart,
        :title => "Title",
        :order => 1,
        :body => "MyText",
        :translation_path => "Translation Path",
        :page_id => 1
      )
    ])
  end

  it "renders a list of page_parts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Translation Path".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
