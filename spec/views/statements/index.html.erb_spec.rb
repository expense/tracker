require 'rails_helper'

RSpec.describe "statements/index", :type => :view do
  before(:each) do
    assign(:statements, [
      Statement.create!(
        :command => "add_expense",
        :params => '{"amount":1,"category":"food","from":"cash"}',
        :comment => "Comment"
      ),
      Statement.create!(
        :command => "add_expense",
        :params => '{"amount":2,"category":"food","from":"cash"}',
        :comment => ""
      )
    ])
  end

  it "renders a list of statements" do
    render
    assert_select "tr>td", :text => "add_expense".to_s, :count => 2
  end
end
