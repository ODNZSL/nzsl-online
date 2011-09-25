require 'spec_helper'

describe "page_parts/new.html.erb" do
  before(:each) do
    assign(:page_part, stub_model(PagePart,
      :title => "MyString",
      :order => 1,
      :body => "MyText",
      :translation_path => "MyString",
      :page_id => 1
    ).as_new_record)
  end

  it "renders new page_part form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => page_parts_path, :method => "post" do
      assert_select "input#page_part_title", :name => "page_part[title]"
      assert_select "input#page_part_order", :name => "page_part[order]"
      assert_select "textarea#page_part_body", :name => "page_part[body]"
      assert_select "input#page_part_translation_path", :name => "page_part[translation_path]"
      assert_select "input#page_part_page_id", :name => "page_part[page_id]"
    end
  end
end
