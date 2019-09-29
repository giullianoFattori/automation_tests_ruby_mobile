#language: pt
@funcional
Funcionalidade: Autenticador

  Descrição:
  - Feature para realizar todos os tipos de autenticação

  @android @done @dev @ITRGR-732
  Cenário: Realizar login com usuário pós pago, utilizando credenciais válidas
    Dado que estou na tela de autenticação
    Quando fizer autenticação com um usuário "valido pos pago"
    E selecionar meu perfil
    Então devo visualizar a area logada

  @android @done @dev @ITRGR-731
  Cenário: Realizar login com usuário pré pago, utilizando credenciais válidas
    Dado que estou na tela de autenticação
    Quando fizer autenticação com um usuário "valido pre pago"
    E selecionar meu perfil
    Então devo visualizar a area logada

  @done @android @ios @pre @ITRGR-728
  Cenário: Realizar login com Cliente PayTV
    Dado que autentico pelo login com um usuário "valido pos pago"
    Então visualizo a area logada e com meus dados

  @inativo @android @ios @dev @pre @ITRGR-729
  Cenário: Realizar login simplificado com cliente Paytv
    Dado que autentico pelo login simplificado com um usuário "valido simplificado"
    Então visualizo a area logada e com meus dados

  @done @android @ios @dev @pre @ITRGR-771
  Cenário: Autenticação SMS Token (Continuar de onde parou)
    Dado que estou na área de login
    E informo cpf, email e telefone do cliente "valido pos pago"
    E na tela de validacao de código eu encerro o app
    Quando iniciar o app novamente com o mesmo cliente "valido pos pago"
    E seleciono a opção de continuar de onde parei
    Entao visualizo a tela de onde encerrei a autenticacao anteriormente
