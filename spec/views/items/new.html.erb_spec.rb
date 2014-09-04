require 'rails_helper'

RSpec.describe "items/new", :type => :view do
  before(:each) do
    assign(:item, Item.new(
      :command => "MyString",
      :comment => "MyString"
    ))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", items_path, "post" do

      assert_select "input#item_command[name=?]", "item[command]"

      assert_select "input#item_comment[name=?]", "item[comment]"
    end
  end
end
