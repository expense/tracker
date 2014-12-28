require 'rails_helper'

RSpec.describe "statements/edit", :type => :view do
  before(:each) do
    @statement = assign(:statement, Statement.create!(
      :command => "MyString",
      :params => "MyText",
      :comment => "MyString"
    ))
  end

  it "renders the edit statement form" do
    render

    assert_select "form[action=?][method=?]", statement_path(@statement), "post" do

      assert_select "input#statement_command[name=?]", "statement[command]"

      assert_select "textarea#statement_params[name=?]", "statement[params]"

      assert_select "input#statement_comment[name=?]", "statement[comment]"
    end
  end
end
