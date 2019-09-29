Dado(/^que estou na tela de autenticação$/) do
  sky = MinhaSkyScreen.new
  home = HomeScreen.new
  home.handle_banner
  sky.touch_navigation
  sky.touch_btn_sign_in

  auth = AutenticadorScreen.new
  auth.check_trait
end

Quando(/^fizer autenticação com um usuário "([^"]*)"$/) do |type_customer|
  @credential = CREDENTIALS[type_customer.tr(' ', '_').to_sym]
  @page.sign_in(@credential)
end

Dado(/^que autentico pelo novo login com um usuário "([^"]*)"$/) do |type_customer|
  step 'que estou na tela de autenticação'
  auth = AutenticadorScreen.new

  @credential = CREDENTIALS[type_customer.tr(' ', '_').to_sym]
  auth.sign_in_novo_login(@credential)
  auth.select_profile
end

Dado(/^que autentico pelo login com um usuário "([^"]*)"$/) do |type_customer|
  step 'que estou na tela de autenticação'
  auth = AutenticadorScreen.new
  @credential = auth.export_user CREDENTIALS[type_customer.tr(' ', '_').to_sym]
  if @credential[:authentication_type] == 'simplificado'
    auth.sign_in_login_simplificado(@credential)

  elsif @credential[:authentication_type] == 'novo'
    auth.sign_in_novo_login(@credential)

  elsif @credential[:authentication_type] == 'legado'
    auth.sign_in(@credential)
  else
    raise "Tipo de login incorreto: #{@credential[:authentication_type]}"
  end
  auth.select_profile
end

Dado(/^que autentico pelo login simplificado com um usuário "([^"]*)"$/) do |type_customer|
  step 'que estou na tela de autenticação'
  auth = AutenticadorScreen.new

  @credential = CREDENTIALS[type_customer.tr(' ', '_').to_sym]
  auth.sign_in_login_simplificado(@credential)
  auth.select_profile
end

Quando(/^selecionar meu perfil$/) do
  auth = AutenticadorScreen.new
  auth.select_profile
end

Então(/^devo visualizar a area logada$/) do
  sky = MinhaSkyScreen.new
  sky.perfil_name_displayed?
end

Então(/^visualizo a area logada e com meus dados$/) do
  sky = MinhaSkyScreen.new
  sky.perfil_name_displayed?

  auth = AutenticadorScreen.new
  auth.valida_dados_login(@credential)
end

E(/^informo CPF de cliente "([^"]*)"$/) do |cliente|
  auth = AutenticadorScreen.new
  @credential = CREDENTIALS[cliente.tr(' ', '_').to_sym]
  auth.enter @credential[:cpf], auth.cpf_field
  auth.touch_btn_proximo
  auth.accept_alert_if_present
  auth.handle_allow_gps if auth.is_ios?
end

Então(/^recebo comunicação de CPF não encontrado$/) do
  auth = AutenticadorScreen.new
  raise 'Mensagem de Erro não exibida' unless auth.wrong_cpf_msg_displayed?
end

Então(/^sou direcionado para área de login$/) do
  auth = AutenticadorScreen.new
  auth.validate_login_screen
end

Quando('informo cpf, email e telefone do cliente {string}') do |cliente|
  step %(informo CPF de cliente "#{cliente}")

  auth = AutenticadorScreen.new
  auth.cancela_popup_continuar_onde_parou
  @credential = CREDENTIALS[cliente.tr(' ', '_').to_sym]
  auth.sign_in_token @credential
end

E('na tela de validacao de código eu encerro o app') do
  auth = AutenticadorScreen.new
  auth.sms_code_displayed?
  close_app
end

Quando('iniciar o app novamente com o mesmo cliente {string}') do |cliente|
  start_driver
  auth = AutenticadorScreen.new
  cartao = PagamentoScreen.new
  auth.accept_alert_if_present
  cartao.dismiss_alert
  auth.different_native_touch_back
  step 'que estou na tela de autenticação'
  step %(informo CPF de cliente "#{cliente}")
end

E('seleciono a opção de continuar de onde parei') do
  auth = AutenticadorScreen.new
  auth.text_restart_displayed?
  alert_accept
end

Entao('visualizo a tela de onde encerrei a autenticacao anteriormente') do
  auth = AutenticadorScreen.new
  auth.sms_code_displayed?
end

Dado(/^que estou logado com usuario "([^"]*)" na tela do Play$/) do |usuario|
  steps %(
  Dado que autentico pelo login com um usuário "#{usuario}"
  E devo ter acesso ao skyplay
  )
end
