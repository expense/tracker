require 'rails_helper'

RSpec.describe "items/index", :type => :view do
  before(:each) do
    assign(:items, [
      Item.create!(
        :command => "Command",
        :comment => "Comment"
      ),
      Item.create!(
        :command => "Command",
        :comment => "Comment"
      )
    ])
  end

  it "renders a list of items" do
    render
    assert_select "tr>td", :text => "Command".to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
  end
end
