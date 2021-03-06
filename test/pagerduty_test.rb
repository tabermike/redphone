$: << File.dirname(__FILE__) + '/../lib' unless $:.include?(File.dirname(__FILE__) + '/../lib/')
require 'rubygems' if RUBY_VERSION < '1.9.0'
gem 'minitest'
require 'minitest/autorun'
require 'redphone/pagerduty'

PAGERDUTY_SERVICE_KEY = File.open("pagerduty_service_key.txt", "rb").read.gsub("\n", "")
credentials = File.open("pagerduty_credentials.txt", "rb").read.split("\n")
PAGERDUTY_SUBDOMAIN, PAGERDUTY_USER, PAGERDUTY_PASSWORD = credentials.each { |row| row }

class TestRedphonePagerduty < MiniTest::Unit::TestCase
  i_suck_and_my_tests_are_order_dependent!

  def setup
    @pagerduty = Redphone::Pagerduty.new(
      #:service_key => PAGERDUTY_SERVICE_KEY,
      :subdomain => PAGERDUTY_SUBDOMAIN,
      :user => PAGERDUTY_USER,
      :password => PAGERDUTY_PASSWORD
    )
  end

  def test_a_trigger_incident
    response = @pagerduty.trigger_incident(
      :service_key => PAGERDUTY_SERVICE_KEY,
      :description => "Testing Redphone Rubygem",
      :incident_key => "redphone/test"
    )
    assert_equal 'success', response['status']
  end

  def test_b_resolve_incident
    response = @pagerduty.resolve_incident(
      :service_key => PAGERDUTY_SERVICE_KEY,
      :incident_key => "redphone/test"
    )
    assert_equal 'success', response['status']
  end

  def test_c_incidents
    response = @pagerduty.incidents(:incident_key => "redphone/test")
    assert response['total'] > 0
  end
end
