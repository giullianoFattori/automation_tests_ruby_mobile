require_relative '../support/helpers/swipe_helpers.rb'
class BaseScreen

  # Generic class that has methods for both platforms(Android/iOS) 
  # Do not create specific methods here, only generics methods for both platforms(Android/iOS) 
  # This class was created to facilitate Appium framework, including waiting in native methods.
  
  include SwipeHelpers

  # Wait method is called almost all methods in this class, if it is necessary modify this time, it is possible change directly in the specific method.
  @@timeout = 30 # Standard @@timeout to wait method;

  def self.identificator(element_name, &block)
    define_method(element_name.to_s, *block)
  end

  class << self
    alias value identificator
    alias action identificator
    alias trait identificator
  end


  def wait_for_element_then_touch(element)
    wait(@@timeout) { get_element(element).click }
  rescue Appium::Core::Wait::timeoutError => e
    raise "#{element} not found \nError: #{e.message}"
  end

  def method_missing(method, *args)

    if method.to_s.start_with?('touch_')
      wait_for_element_then_touch public_send(method.to_s.sub('touch_', ''))

    elsif method.to_s.start_with?('swipe_up_to_')
      swipe_to_element public_send(method.to_s.sub('swipe_to_', ''))

    elsif method.to_s.start_with?('enter_')
      enter public_send(method.to_s.sub('enter_', '')), args[0]

    elsif method.to_s.end_with?('_displayed?')
      element_displayed? public_send(method.to_s.sub('_displayed?', ''))

    elsif method.to_s.end_with?('_on_screen?')
      element_on_screen? public_send(method.to_s.sub('_on_screen?', ''))

    elsif method.to_s.end_with?('_clear')
      element_clear public_send(method.to_s.sub('_clear', ''))
    else
      super
    end
  end

  def enter(element, text)
    wait_for_element_then_touch element
    wait do
      txt_sent = (get_element element).send_keys text
      txt_sent || true
    end
  rescue timeout::Error => e
    raise "Could not send keys to element #{element} \nError: #{e.message}"
  end

  def element_displayed?(element)
    wait(@@timeout) { get_element(element).displayed? }
  rescue timeout::Error => e
    raise "Element #{element} not visible \nError: #{e.message}"
  end

  def element_clear(element)
    wait(@@timeout) { get_element(element).clear }
  rescue timeout::Error => e
    raise "Element #{element} not visible \nError: #{e.message}"
  end

  def accept_alert_if_present()
    if is_ios?
      begin
        wait(@@timeout) { get_element([:class, 'XCUIElementTypeAlert']) }
        alert_accept
        true
      rescue StandardError
        false
      end
    else
      alert_accept
    end
  end

  def count_element_on_screen(element, selector = :id)
    if element.is_a? Array
      selector = element[0].to_sym
      element = element[1]
    end

    arr = find_elements(selector, element)

    if is_ios?
      not_visible = []
      arr.each do |a|
        vi = a.visible?
        not_visible << a if vi == 'false'
      end
      arr -= not_visible
    end
    arr
  end

  def get_element(element)
    begin
      if element.is_a? Array
        case element.size
        when 2
          selector = element[0].to_sym
          element = element[1]
          el = find_element(selector, element)
        when 3
          selector = element[0].to_sym
          count = (element.size == 3 ? element[2].to_i : 0)
          element = element[1]
          el = find_elements(selector, element)[count]
          if el.nil?
            raise Selenium::WebDriver::Error::NoSuchElementError, \
                  "The element #{element} was not found"
          end
        end
      else
        el = find_element :id, element
      end
    rescue StandardError => e
      if e.class.to_s.include?('InvalidSessionIdError' || 'NoSuchDriverError' || 'UnknownError')
        raise e
      else
        raise Selenium::WebDriver::Error::NoSuchElementError, \
              "Could not find the element #{element}"
      end
    end
    el
  end

  def element_on_screen?(element, timeout = 0)
    timeout = @@timeout if timeout == 0
    if is_android?
      wait(timeout) { get_element element }
    else
      wait_true(timeout) { get_element(element).visible? == 'true' }
    end
    true
  rescue Appium::Core::Wait::TimeoutError
    false
  end

  def get_text(element)
    if is_android?
      get_element(element).text
    else
      get_element(element).value
    end
  end

  def is_android?
    ENV['PLATFORM'] == 'android'
  end

  def is_ios?
    ENV['PLATFORM'] == 'ios'
  end

  def wait(opts = {})
    opts = opts.is_a?(Numeric) ? {timeout: opts, interval: 0.2} : opts
    opts = {timeout: 30, interval: 0.2}.merge(opts)
  
    Appium::Core::Wait.until(timeout: opts[:timeout], interval: opts[:interval]) do
      yield
    end
  end

  def wait_true(opts = {})
    opts = opts.is_a?(Numeric) ? {timeout: opts, interval: 0.2} : {timeout: 30, interval: 0.2}

    if opts.is_a? Hash
      opts.empty? ? Appium::Core::Wait.until_true { yield } : Appium::Core::Wait.until_true(opts) { yield }
    end
  end
end
