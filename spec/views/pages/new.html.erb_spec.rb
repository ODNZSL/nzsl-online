require 'spec_helper'

describe "pages/new.html.erb" do
  before(:each) do
    assign(:page, stub_model(Page,
      :title => "MyString",
      :slug => "MyString",
      :label => "MyString",
      :order => 1,
      :template => "MyString",
      :show_in_nav => ""
    ).as_new_record)
  end

  it "renders new page form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pages_path, :method => "post" do
      assert_select "input#page_title", :name => "page[title]"
      assert_select "input#page_slug", :name => "page[slug]"
      assert_select "input#page_label", :name => "page[label]"
      assert_select "input#page_order", :name => "page[order]"
      assert_select "input#page_template", :name => "page[template]"
      assert_select "input#page_show_in_nav", :name => "page[show_in_nav]"
    end
  end
end
