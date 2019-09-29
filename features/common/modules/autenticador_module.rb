module AutenticadorModule
  def validate_login_screen
    raise 'Campo CPF para login não exibido' unless cpf_field_displayed?
    raise 'Botão entrar não exibido' unless btn_enter_displayed?
  end

  def sign_in(opts = {})
    enter_cpf_field opts.fetch(:cpf)
    wait_true(4) { !is_keyboard_shown }
    touch_btn_enter
    accept_alert_if_present
    touch_btn_wrong_number
    select_address(opts)
    select_home_number(opts)
  end

  def sign_in_novo_login(opts = {})
    enter_cpf_field opts.fetch(:cpf)
    wait_true(4) { !is_keyboard_shown }
    touch_btn_enter
    # TODO: acrescentado para avaliacao
    cancela_popup_continuar_onde_parou
    select_email(opts)
    select_phone(opts)
    insert_sms_code(opts)
    select_address(opts)
    select_home_number(opts)
    select_signature(opts)
  end

  def sign_in_login_simplificado(opts = {})
    enter_cpf_field opts.fetch(:cpf)
    touch_btn_enter
    accept_alert_if_present
    select_email opts
    select_phone(opts)
    select_signature(opts)
  end

  def sign_in_first_login(opts = {})
    enter_cpf_field opts.fetch(:cpf)
    wait_true(4) { !is_keyboard_shown }
    touch_btn_enter
    # TODO: acrescentado para avaliacao
    cancela_popup_continuar_onde_parou
    select_email(opts)
    select_phone(opts)
    insert_sms_code(opts)
    select_address(opts)
    select_home_number(opts)
  end

  def cancela_popup_continuar_onde_parou
    touch_btn_cancelar if element_on_screen? btn_cancelar, 15
  end

  def select_email(opts = {})
    accept_alert_if_present
    cancela_popup_continuar_onde_parou
    mail_field = begin
      wait_true(15) { get_element(email_label).enabled == 'true' }
                 rescue Appium::Core::Wait::TimeoutError
                   false
    end
    if mail_field
      i = 10
      until get_element(btn_mail_next).enabled?
        enter_email_field opts.fetch(:email)
        sleep 1
        i -= 1
        opt = get_text(email_field).include?(opts.fetch(:email)) unless get_text(email_field).nil?
        condition = [
          i.zero?,
          opt
        ]
        break if condition.any?
      end
      touch_btn_mail_next
    end
  end

  def select_phone(opts = {})
    wait { get_element(phone_number_field).displayed? }
    btn_send_sms_displayed?
    i = 10
    until get_element(btn_send_sms).enabled?
      enter_phone_number_field opts.fetch(:phone)
      sleep 1
      i -= 1
      opt = opts.fetch(:phone).tr('() -', '').include?(get_text(phone_number_field).tr('() -', '')) \
unless get_text(phone_number_field).nil?
      condition = [
        i.zero?,
        opt
      ]
      break if condition.any?
    end
    touch_btn_send_sms
  end

  def select_signature(opts = {})
    @account = opts.fetch(:signature)
    if element_on_screen? txt_choose_signature, 15
      swipe_up_to_choose_signature unless element_on_screen? choose_signature, 10
      begin
        touch_choose_signature while choose_signature_on_screen?
      rescue Appium::Core::Wait::TimeoutError
        nil
      end
    end
  end

  def valida_dados_login(opts = {})
    cpf_logado = wait { get_element(cpf_textview) }
    attribute = is_ios? ? 'value' : 'text'
    valida_cpf = cpf_logado.attribute(attribute).tr('CPF: .-', '')
    cpf_usuario = opts.fetch(:cpf).tr('.-', '')

    if cpf_usuario != valida_cpf
      raise 'Cpf logado: ' + valida_cpf \
            + ' é diferente do cpf informado pelo usuário: ' + cpf_usuario + '.'
    end

    assinatura_logada = wait { get_element signature_textview }
    valida_assinatura = assinatura_logada.attribute(attribute).tr('Assinatura ', '')
    assinatura_usuario = opts.fetch(:signature)

    if assinatura_usuario != valida_assinatura
      raise 'Assinatura logada: ' + valida_assinatura\
            + ' é diferente da assinatura informada pelo usuário: ' + assinatura_usuario + '.'
    end
  end

  def select_address(opts = {})
    begin
      wait(10) { (get_element btn_info_assinante).click }
    rescue Appium::Core::Wait::TimeoutError
      nil
    end
    address_list_displayed?
    adr = if opts.fetch(:address).is_a? Array
            opts.fetch(:address).map {|a| a.tr('* ', '') }
          else
            opts.fetch(:address).tr('* ', '')
          end
    el = find_elements(:id, address_list).select do |e|
      adr.include? e.text.tr('* ', '')
    end
    raise 'Endereco nao encontrado' if el.empty?

    el.first.click
  end

  def select_profile
    who_are_you_displayed?
    touch_first_profile
  end

  def sign_in_token(opts = {})
    select_phone(opts)
  end

  def validate_img_erro_on_screen(element)
    el = wait { get_element(element) }
    raise 'Falha na conexão ! (Carro ou Astronauta)' if el.enabled?
  end

  def different_native_touch_back
    native_touch_back if is_android?
    if btn_cancelar_on_screen?
      touch_btn_cancelar if is_ios?
    end
  end

  def native_touch_back
    driver.back if is_android?
  end

  # rubocop:disable Style/GlobalVars
  def export_user(profile)
    $credential = profile
  end
  # rubocop:enable Style/GlobalVars
end
