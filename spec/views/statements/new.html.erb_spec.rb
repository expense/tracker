require 'rails_helper'

RSpec.describe "statements/new", :type => :view do
  before(:each) do
    assign(:statement, Statement.new(
      :command => "MyString",
      :params => "MyText",
      :comment => "MyString"
    ))
  end

  it "renders new statement form" do
    render

    assert_select "form[action=?][method=?]", statements_path, "post" do

      assert_select "input#statement_command[name=?]", "statement[command]"

      assert_select "textarea#statement_params[name=?]", "statement[params]"

      assert_select "input#statement_comment[name=?]", "statement[comment]"
    end
  end
end
