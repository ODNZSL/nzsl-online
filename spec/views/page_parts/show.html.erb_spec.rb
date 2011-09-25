require 'spec_helper'

describe "page_parts/show.html.erb" do
  before(:each) do
    @page_part = assign(:page_part, stub_model(PagePart,
      :title => "Title",
      :order => 1,
      :body => "MyText",
      :translation_path => "Translation Path",
      :page_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Translation Path/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
