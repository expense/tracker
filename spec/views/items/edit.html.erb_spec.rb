require 'rails_helper'

RSpec.describe "items/edit", :type => :view do
  before(:each) do
    @item = assign(:item, Item.create!(
      :command => "MyString",
      :comment => "MyString"
    ))
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(@item), "post" do

      assert_select "input#item_command[name=?]", "item[command]"

      assert_select "input#item_comment[name=?]", "item[comment]"
    end
  end
end
