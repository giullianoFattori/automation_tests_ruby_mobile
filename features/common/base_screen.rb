require_relative '../support/helpers/swipe_helpers.rb'
class BaseScreen
  include SwipeHelpers

  def self.identificator(element_name, &block)
    define_method(element_name.to_s, *block)
  end

  class << self
    alias value identificator
    alias action identificator
    alias trait identificator
  end

  def respond_to_missing?
    true
  end

  def check_trait(timeout = 30)
    wait(timeout) { get_element(trait).enabled? }
  rescue Appium::Core::Wait::TimeoutError => e
    raise "#{trait} not found \nError: #{e.message}"
  end

  def wait_for_element_then_touch(element, timeout = 30)
    wait(timeout) { get_element(element).click }
  rescue Appium::Core::Wait::TimeoutError => e
    raise "#{element} not found \nError: #{e.message}"
  end

  def method_missing(method, *args)
    if method.to_s.start_with?('touch_')
      wait_for_element_then_touch public_send(method.to_s.sub('touch_', ''))

    elsif method.to_s.start_with?('swipe_up_to_')
      swipe_to_element public_send(method.to_s.sub('swipe_up_to_', ''))

    elsif method.to_s.start_with?('enter_')
      enter args[0], public_send(method.to_s.sub('enter_', ''))

    elsif method.to_s.end_with?('_displayed?')
      element_displayed? public_send(method.to_s.sub('_displayed?', ''))

    elsif method.to_s.end_with?('_on_screen?')
      element_on_screen? public_send(method.to_s.sub('_on_screen?', ''))
    else
      super
    end
  end

  def enter(text, element)
    wait_for_element_then_touch element
    wait do
      txt_sent = (get_element element).send_keys text
      txt_sent || true
    end
  rescue Timeout::Error => e
    raise "Could not send keys to element #{element} \nError: #{e.message}"
  end

  def element_displayed?(element, timeout = 30)
    wait(timeout) { get_element(element).displayed? }
  rescue Timeout::Error => e
    raise "Element #{element} not visible \nError: #{e.message}"
  end

  def accept_alert_if_present(timeout = 5)
    if is_ios?
      begin
        wait(timeout) { get_element([:class, 'XCUIElementTypeAlert']) }
        alert_accept
        true
      rescue StandardError
        false
      end
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

  def element_on_screen?(element, timeout = 5)
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
    opts = opts.is_a?(Numeric) ? {timeout: opts, interval: 0.2} : {timeout: 30, interval: 0.2}

    if opts.is_a? Hash
      opts.empty? ? Appium::Core::Wait.until { yield } : Appium::Core::Wait.until(opts) { yield }
    end
  end

  def wait_true(opts = {})
    opts = opts.is_a?(Numeric) ? {timeout: opts, interval: 0.2} : {timeout: 30, interval: 0.2}

    if opts.is_a? Hash
      opts.empty? ? Appium::Core::Wait.until_true { yield } : Appium::Core::Wait.until_true(opts) { yield }
    end
  end

  # rubocop:disable Style/GlobalVars
  def get_user
    raise 'credential nao encontrada' if $credential.nil?

    $credential
  end
  # rubocop:enable Style/GlobalVars
end
