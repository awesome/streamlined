require File.join(File.dirname(__FILE__), "../../../test_helper")
require "streamlined/helpers/breadcrumb_helper"

class Streamlined::BreadcrumbHelperTest < Test::Unit::TestCase
  include Streamlined::Helpers::BreadcrumbHelper

  def test_breadcrumb_defaults_to_false
    assert !breadcrumb
  end

  def test_render_breadcrumb_for_list_context
    assert_render_breadcrumb(:list)
    assert_select root_node(render_breadcrumb), "div[id=breadcrumb]", "Home < Fancy Models"
  end

  def test_render_breadcrumb_for_edit_context
    assert_render_breadcrumb_for_sub_context(:edit)
    flexmock(self).should_receive(:header_text).with("Edit").and_return("Edit Some Name").once
    assert_select root_node(render_breadcrumb), "div[id=breadcrumb]", "Home < Fancy Models < Edit Some Name" 
  end

  def test_render_breadcrumb_for_new_context
    assert_render_breadcrumb_for_sub_context(:new)
    flexmock(self).should_receive(:header_text).with("New").and_return("New Some Name").once
    assert_select root_node(render_breadcrumb), "div[id=breadcrumb]", "Home < Fancy Models < New Some Name" 
  end

  def test_render_breadcrumb_for_other_context
    assert_render_breadcrumb_for_sub_context(:foo)
    flexmock(self).should_receive(:header_text).with_no_args.and_return("Foo").once
    assert_select root_node(render_breadcrumb), "div[id=breadcrumb]", "Home < Fancy Models < Foo" 
  end
  
  private 
  def assert_render_breadcrumb(context)
    flexmock(self) do |m|
      m.should_receive(:link_to).with("Home", "/").and_return("Home").once
      m.should_receive(:model_name => "FancyModel").once
      m.should_receive(:crud_context => context).at_least.once
    end
  end

  def assert_render_breadcrumb_for_sub_context(context)
    flexmock(self).should_receive(:link_to).with("Fancy Models", {:action => "list"}).and_return("Fancy Models").once
    assert_render_breadcrumb(context)
  end
end