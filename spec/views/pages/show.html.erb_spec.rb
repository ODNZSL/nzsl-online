require 'spec_helper'

describe "pages/show.html.erb" do
  before(:each) do
    @page = assign(:page, stub_model(Page,
      :title => "Title",
      :slug => "Slug",
      :label => "Label",
      :order => 1,
      :template => "Template",
      :show_in_nav => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Slug/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Label/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Template/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
