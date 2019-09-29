class AutenticadorScreen < BaseScreen
  include AutenticadorModule

  # request another name id
  identificator(:trait) { 'btn_login' }
  identificator(:cpf_field) { [:class, 'XCUIElementTypeTextField'] }
  identificator(:cpf_field_titular) { [:class, 'XCUIElementTypeTextField'] }
  identificator(:btn_enter) { [:name, 'btn_enter'] }
  identificator(:btn_login) { [:name, 'btn_login'] }
  identificator(:btn_wrong_number) { 'bt_not_my_number' }
  identificator(:btn_correct_number) { 'bt_my_number' }
  identificator(:address_list) { 'question_cell' }
  identificator(:home_number) { 'question_cell' }
  identificator(:btn_continue) { 'bt_next' }
  identificator(:btn_continuar) { [:name, 'CONTINUAR'] }
  identificator(:btn_proximo) { [:predicate, "label CONTAINS 'Próximo'"] }
  identificator(:wrong_cpf_msg) { [:predicate, "name CONTAINS 'CPF não encontrado'"] }
  identificator(:text_restart) { [:predicate, "name CONTAINS 'Você quer continuar da etapa de onde parou?'"] }
  identificator(:email_field) { [:predicate, "value CONTAINS 'mail' and type == 'XCUIElementTypeTextField'"] }
  identificator(:email_label) { [:predicate, "value CONTAINS 'email' and type == 'XCUIElementTypeTextField'"] }
  identificator(:phone_number_field) { [:predicate, "type == 'XCUIElementTypeTextField' and not (value contains 'mail')"] }
  identificator(:btn_action) { [:name, 'sms_new_phone_btn_send_sms'] }
  identificator(:btn_mail_next) { [:name, 'sms_new_phone_btn_send_sms'] }
  identificator(:btn_send_sms) { [:name, 'sms_new_phone_btn_send_sms'] }
  identificator(:sms_code) { [:name, 'sms_check_token_view_token_box'] }
  identificator(:btn_popup_sms) { [:uiautomator, "name CONTAINS 'CONTINUAR'"] }
  identificator(:btn_info_assinante) { [:predicate, "name CONTAINS 'perguntas sobre'"] }
  identificator(:txt_error_msg_carro) { [:predicate, "name CONTAINS 'Eita, algo deu errado'"] }
  identificator(:txt_error_msg_astronauta) { [:predicate, "name CONTAINS 'Ops! Sistema fora do ar'"] }

  # request another id
  identificator(:who_are_you) { [:predicate, 'name == "Quem é você?" AND visible == 1'] }
  identificator(:who_are_you_view) { [:class, 'XCUIElementTypeCollectionView'] }
  identificator(:first_profile) { [:class, 'XCUIElementTypeCell', 1] }

  identificator(:tv_cpf_invalido) { [:predicate, 'name CONTAINS "CPF inválido"'] }
  identificator(:txt_cpf_message) { [:name, 'Não encontramos o CPF no nosso sistema.Informe o CPF do titular da assinatura SKY.'] }
  identificator(:txt_gps_message) { [:name, 'Libere o acesso ao GPS para efetuar o login, receber promoções exclusivas, descontos e novidades da programação da sua região'] }
  identificator(:cpf_textview) { [:predicate, 'name CONTAINS "CPF: "'] }
  identificator(:signature_textview) { [:predicate, 'name CONTAINS "Assinatura "'] }
  identificator(:choose_signature) { [:predicate, "name == 'Assinatura: #{@account}'"] }
  identificator(:txt_choose_signature) { [:name, 'Escolha a assinatura que deseja acessar:'] }
  identificator(:btn_continuar_minha_sky) { [:name, 'CONTINUAR PARA MINHA SKY'] }
  identificator(:btn_cancelar) { 'CANCELAR' }

  def select_radio_signature
    wait { find_elements(:id, radio_signature)[0].click }
  end

  def select_home_number(opts = {})
    home_number_displayed?
    el = find_elements(:id, home_number).select {|e| opts.fetch(:number).eql? e.text }.first
    if el.nil?
      raise 'Numero nao encontrado'
    else
      el.click
    end
  end

  def message_localizacao_displayed
    txt_gps_message_displayed?
  end

  def insert_sms_code(opts = {})
    i = 3
    while i.positive?
      begin
        wait_true(5) { !(count_element_on_screen sms_code).empty? }
      rescue Appium::Core::Wait::TimeoutError
        nil
      end
      accepted = accept_alert_if_present 2
      break if accepted

      enter_sms_code opts.fetch(:smscode)
      i -= 1
    end
    accept_alert_if_present 15 unless accepted
  end

  def handle_allow_gps
    wait(5) { @gps_permit = find_elements :name, 'Permitir' }
    @gps_permit[0].click unless @gps_permit.empty?
  end
end
