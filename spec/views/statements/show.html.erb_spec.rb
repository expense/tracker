require 'rails_helper'

RSpec.describe "statements/show", :type => :view do
  before(:each) do
    @statement = assign(:statement, Statement.create!(
      :command => "Command",
      :params => "MyText",
      :comment => "Comment"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Command/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Comment/)
  end
end
