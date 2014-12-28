require 'rails_helper'

RSpec.describe "statements/index", :type => :view do
  before(:each) do
    assign(:statements, [
      Statement.create!(
        :command => "Command",
        :params => "MyText",
        :comment => "Comment"
      ),
      Statement.create!(
        :command => "Command",
        :params => "MyText",
        :comment => "Comment"
      )
    ])
  end

  it "renders a list of statements" do
    render
    assert_select "tr>td", :text => "Command".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
  end
end
