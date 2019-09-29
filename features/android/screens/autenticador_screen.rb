class AutenticadorScreen < BaseScreen
  include AutenticadorModule

  identificator(:trait) { 'et_cpf' }
  identificator(:cpf_field) { 'editText' }
  identificator(:cpf_field_titular) { 'et_cpf' }
  identificator(:btn_enter) { 'bt_enter' }
  identificator(:btn_login) { 'btn_login' }
  identificator(:btn_wrong_number) { 'bt_not_my_number' }
  identificator(:btn_correct_number) { 'bt_my_number' }
  identificator(:address_list) { 'tv_label' }
  identificator(:home_number) { 'tv_label' }
  identificator(:btn_continue) { 'bt_next' }
  identificator(:btn_continuar) { 'btn_finish' }
  identificator(:btn_proximo) { [:uiautomator, 'new UiSelector().textContains("Próximo")'] }
  identificator(:who_are_you) { [:uiautomator, 'new UiSelector().text("Quem é você?")'] }
  identificator(:text_restart) { [:uiautomator, 'new UiSelector().text("Você quer continuar da etapa de onde parou?")'] }
  identificator(:first_profile) { [:id, 'icon'] }
  identificator(:txt_algo_errado) { [uiautomator, 'new UiSelector().textContains("Eita, algo deu errado")'] }
  identificator(:img_carrinho) { 'iv_error' }
  identificator(:txt_cpf_message) { 'android:id/message' }
  identificator(:wrong_cpf_msg) { 'txtErrorMessage' }
  identificator(:btn_entrar) { [:xpath, "//*[@text='ENTRAR']"] }
  identificator(:tv_cpf_invalido) { 'error_message' }
  identificator(:dont_have_sky) { 'bt_subscribe' }
  identificator(:txt_gps_message) { 'com.android.packageinstaller:id/permission_message' }
  identificator(:btn_subscribe) { 'bt_subscribe' }
  identificator(:email_field) { 'editText' }
  identificator(:email_label) { 'et_email' }
  identificator(:phone_number_field) { 'editText' }
  identificator(:btn_mail_next) { 'btn_next' }
  identificator(:btn_send_sms) { 'btn_send_sms' }
  identificator(:sms_code) { 'token_component' }
  identificator(:btn_popup_sms) { [:uiautomator, 'new UiSelector().textStartsWith("Continuar")'] }
  identificator(:btn_info_assinante) { [:uiautomator, 'new UiSelector().textContains("perguntas")'] }
  identificator(:btn_cancelar) { [:uiautomator, 'new UiSelector().textStartsWith("Cancelar")'] }
  identificator(:cpf_textview) { 'tv_cpf' }
  identificator(:signature_textview) { 'signature' }
  identificator(:choose_signature) { [:uiautomator, "new UiSelector().textContains(\"#{@account}\")"] }
  identificator(:txt_choose_signature) { [:uiautomator, 'new UiSelector().textContains("Escolha a assinatura que deseja acessar")'] }
  identificator(:btn_continuar_minha_sky) { [:uiautomator, 'new UiSelector().textStartsWith("CONTINUAR PARA MINHA SKY")'] }
  identificator(:txt_error_msg_astronauta) { [:uiautomator, 'new UiSelector().textContains("Ops! Sistema fora do ar")'] }
  identificator(:txt_error_msg_carro) { [:uiautomator, 'new UiSelector().textContains("Eita, algo deu errado")'] }

  def select_radio_signature
    wait { find_elements(:id, radio_signature)[0].click }
  end

  def select_home_number(opts = {})
    home_number_displayed?
    el = find_elements(:id, address_list).select {|e| opts.fetch(:number).eql? e.text }
    el.first.click
  end

  # rubocop:disable LineLength
  def message_localizacao_displayed
    msg_location_pop_up = 'Libere o acesso ao GPS para efetuar o login, receber promoções exclusivas, descontos e novidades da programação da sua região'
    elemento = wait { find_element(:id, txt_gps_message) }
    elementotxt = elemento.attribute('text')
    if elementotxt != msg_location_pop_up
      raise Selenium::WebDriver::Error::NoSuchElementError, "The element #{elemento} was not found"
    end
  end
  # rubocop:enable LineLength

  def insert_sms_code(opts = {})
    i = 3
    while i.positive?
      begin
        wait_true(25) { @displayed = get_element(sms_code).displayed? }
      rescue Appium::Core::Wait::TimeoutError
        @displayed = false
      end
      break unless @displayed

      wait_true(5) { enter_sms_code opts.fetch(:smscode) }
      i -= 1
    end
    touch_btn_popup_sms
  end
end
