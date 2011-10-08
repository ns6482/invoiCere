require 'test_helper'
=begin
class RoutingTest < ActionController::TestCase

  def test_should_route_to_clients
    assert_routing '/clients', { :controller => "clients", :action => "index", :subdomain => "www"}
  end

  def test_should_route_to_client
    assert_routing '/clients/1', {:controller => "clients", :action => "show", :id => "1", :subdomain => "www" }
  end

  def test_should_route_to_client_edit
    assert_routing '/clients/1/edit', { :controller => "clients", :action => "edit", :id => "1" }
  end

  def test_should_route_to_client_new
    assert_routing '/clients/new', { :controller => "clients", :action => "new"}
  end

  def test_should_route_contacts_of_client
    options = { :controller => 'contacts',
      :action => 'index',
      :client_id => '1' }
    assert_routing('clients/1/contacts', options)
  end

  def test_should_route_contacts_of_client
    options = { :controller => 'contacts',
      :action => 'index',
      :client_id => '1', 
      :subdomain => "lvh"}
    assert_routing('clients/1/contacts', options)
  end

  def test_should_route_contacts_of_client_new
    options = { :controller => 'contacts',
      :action => 'new',
      :client_id => '1' }
    assert_routing('clients/1/contacts/new', options)
  end
end
=end
