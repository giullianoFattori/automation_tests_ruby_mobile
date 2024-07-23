module SwipeHelpers

  #
  # Modulo que mantem todos os tipos de swipe/scroll que possam
  # ser nessessários no processo de desenvolvimento dos testes
  #

  def swipe_to_element(element, speed = 'slow', retries = 15)
    element_count = element_on_screen? element, 2

    unless element_count
      retr = retries
      while retries.positive?
        swipe_screen speed
        sleep 1
        el = element_on_screen? element, 2
        break if el

        retries -= 1
      end

      raise "Swiped #{retr} times but was unable to find '#{element}' element" if retries.zero?
    end
  end

  # rubocop:disable Metrics/LineLength
  def swipe_to_element_from_reference(element_reference, element, retries = 15)
    manage.timeouts.implicit_wait = 0
    element_find = element_on_screen? element
    unless element_find
      while retries.positive?
        completed = wait { get_element element_reference }
        Appium::TouchAction.new.swipe(start_x: 0.66, start_y: completed.rect[:y], end_x: 10, end_y: completed.rect[:y], duration: 1000).perform if is_android?
        Appium::TouchAction.new.swipe(start_y: completed.rect[:y], end_y: completed.rect[:y], start_x: 999, end_x: 0.1, duration: 5000).perform if is_ios?
        element_find = element_on_screen? element
        break if element_find

        retries -= 1
      end
      manage.timeouts.implicit_wait = 5
      raise "Swiped #{retries} times but was unable to find '#{element}' element" if retries.zero?
    end
  end
  # rubocop:enable Metrics/LineLength

  # rubocop:disable Metrics/AbcSize
  def swipe_screen(speed = 'slow')
    @wsize ||= window_size
    case speed
    when 'slow'
      sy = @wsize.height * 0.70
      ey = @wsize.height * 0.40
      sx =  @wsize.width / 2
      ex =  @wsize.width / 2
      duration = 450
    when 'fast'
      sy = @wsize.height * 0.80
      ey = @wsize.height * 0.30
      sx =  @wsize.width / 2
      ex =  @wsize.width / 2
      duration = 450
    when 'down'
      sy = @wsize.height * 0.30
      ey = @wsize.height * 0.80
      sx =  @wsize.width / 2
      ex =  @wsize.width / 2
      duration = 450
    when 'left'
      sy = @wsize.height * 0.50
      ey = @wsize.height * 0.50
      sx = @wsize.width * 0.9
      ex = @wsize.width * 0.2
      duration = 1000
    when 'right'
      sy = @wsize.height * 0.50
      ey = @wsize.height * 0.50
      sx = @wsize.width * 0.2
      ex = @wsize.width * 0.9
      duration = 1000
    else
      raise "wrong swipe parameter: #{speed}"
    end
    action.move_to_location(sx, sy).pointer_down(:left).pause.move_to_location(ex, ey).pointer_up(:left).perform
  end
  # rubocop:enable Metrics/AbcSize
end
