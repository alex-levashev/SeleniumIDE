require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "First" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "https://visapoint.eu/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_first" do
    @driver.get(@base_url + "/disclaimer")
    verify { (@driver.title).should == "Ministry of Foreign Affairs of the Czech Republic" }
    @driver.find_element(:id, "ctl00_cp1_btnAccept_input").click
    verify { (@driver.title).should == "Ministry of Foreign Affairs of the Czech Republic" }
  end
  
  def element_present?(how, what)
    ${receiver}.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    ${receiver}.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = ${receiver}.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
