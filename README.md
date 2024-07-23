# Automação de Testes Funcionais de Apps Externos

Este projeto visa a padronização e a facilitação da automação de testes para aplicativos móveis utilizando Ruby, Appium e Cucumber.

## Estrutura do Projeto

A estrutura do projeto está organizada da seguinte forma:

C:.
  ├───config
  │ └───app
  │ └───android
  └───features
  ├───android
  │ └───screens
  ├───common
  │ ├───environment
  │ ├───modules
  │ ├───specs
  │ └───step_definitions
  ├───ios
  │ └───screens
  ├───screenshots
  │ └───android
  └───support
  ├───caps
  └───helpers

### Elementos de Tela

A estrutura do projeto facilita a inclusão de novos elementos de tela, junto com suas principais interações, como tocar (touch), tocar e escrever um texto (enter), checar se o elemento está visível (displayed?) e checar a existência de um elemento (exist?). Isso elimina a necessidade de criar novos métodos para cada novo elemento.

```ruby
class ExampleScreen < BaseScreen

  # Declaração dos elementos necessários
  identificator(:name_field) { 'nome_do_campo' }
  identificator(:phone_field) { 'nome_do_campo' }
  identificator(:btn_confirm) { 'nome_do_campo' }
  
end
```

### Exemplo de uso em um teste:

```ruby
Quando(/^confirmar a ação$/) do
  @page_exemplo.enter_name_field('Teste de agora')
  @page_exemplo.enter_phone_field('1199990000')
  @page_exemplo.touch_btn_confirm
end
```
## Reaproveitamento de Métodos
Métodos comuns entre plataformas devem ser colocados em módulos e incluídos nas classes de tela correspondentes.

## Módulo:
- Toda módulo criada deve ser chamado pela sua respectiva classe. O módulo compoem as ações de uma classe de elementos.

[Aqui](features\android\screens\home_screen.rb) tem um exemplo de classe e [aqui](features\common\modules\example_module.rb) um exemplo git pullde modulo.
```ruby
module ExampleModule
  
  def confirm_action
    enter('Outro teste', email_field)
    enter('1199990000', phone_field)
    wait_for_element_then_touch(btn_confirm)
  end
end
```

### Classes:
 - Toda classe criada deve ser chamada no arquivo [page_objects.rb](features\support\page_objects.rb). Exemplo Abaixo:
 ```ruby
    def homePage
        HomePageScreen.new
    end

    def configPage
        ConfigPageScreen.new
    end
```

- Exemplo de como criar uma nova classe e seus elementos. Para mais exemplo, [acesse aqui.](features\android\screens\home_screen.rb)
```ruby
# Android
class ExampleScreen < BaseScreen

  include ExampleModule
  
  identificator(:name_field) { 'name_android' }
  identificator(:phone_field) { 'phone_android' }
  identificator(:btn_confirm) { 'button_android' }
  
end
```

### Chamada no Teste:
```ruby
Quando(/^confirmar a ação$/) do
  @page_exemplo.confirm_action
end
```
# Configuração do Projeto para Execução
## Pré-requisitos
### Homebrew
Instale o Homebrew executando o comando abaixo no terminal:

```sh
/bin/ba```sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.```sh)"
```
### Ruby
Instale o Ruby seguindo os comandos abaixo na ordem:

```sh
brew install readline
brew install rbenv
rbenv init
RUBY_CONFIGURE_OPTS=--with-readline-dir="$(brew --prefix readline)" rbenv install 3.1.2
rbenv global 3.1.2
```

### JDK (Java Development Kit)
Instale a versão necessária do JDK (Java 11 ou superior) a partir do [site oficial da Oracle](https://www.oracle.com/java/technologies/downloads/?er=221886) ou utilize o OpenJDK via Homebrew:

```sh
brew install openjdk@11
```

### Android Studio
Instale o Android Studio a partir do [site oficial](https://developer.android.com/studio/).

### Xcode
Instale o Xcode pela App Store. Após a instalação, execute o comando abaixo no terminal:

```sh
xcode-select --install
```
### Carthage
```sh
brew install carthage
```
### Node.js

```sh
brew install node
```
### Appium Server
Instale o Appium Server:

```sh
npm install -g appium
```
### Appium Desktop
Baixe a versão mais recente do Appium Desktop [aqui](https://github.com/appium/appium-inspector/releases/tag/v2024.6.1).

## Bundler
Instale o Bundler:

```sh
gem install bundler
```
### Instalação de Dependências
Na raiz do projeto, execute o comando abaixo para instalar as dependências:

```sh
bundle install
```
Configuração de Capabilities
Os capabilities já estão configurados no clone do repositório.

Executando o Projeto
Subindo o Appium Server
Inicie o servidor Appium:

```sh
appium
```

Este comando inicia o servidor Appium, que é necessário para controlar e interagir com dispositivos móveis durante os testes.

### Executando os Testes
Execute os testes com o Cucumber:

```sh
bundle exec cucumber -p <plataforma> -t <teste_selecionado>
```
 - `<plataforma>`: Especifica a plataforma para a qual os testes serão executados (por exemplo, android ou ios).
- `<teste_selecionado>`: Tag ou conjunto de tags que identificam quais testes serão executados.

## Comandos Úteis
Definir o Caminho Base para o Appium
```sh
appium --base-path /wd/hub
```
Este comando inicia o servidor Appium com um caminho base especificado. Isso é útil para configurar o servidor para uma URL específica, facilitando a integração com outras ferramentas.

### Extrair Informações do APK
```sh
aapt dump badging <caminho.apk> | grep package
```
- `<caminho.apk>`: Caminho para o arquivo APK do aplicativo.

Este comando extrai e exibe informações de badging do APK, incluindo o nome do pacote do aplicativo.

### Identificar a Atividade Inicial do APK
```sh
aapt dump badging <caminho.apk> | grep launchable-activity
```
- ```<caminho.apk>```: Caminho para o arquivo APK do aplicativo.

Este comando extrai e exibe a atividade inicial do APK, que é necessária para iniciar o aplicativo corretamente durante os testes.

### Instalar Aplicativo no Dispositivo via ADB
```sh
adb install <caminho_do_app>
```
  - ```<caminho_do_app>```: Caminho para o arquivo APK do aplicativo.

Este comando instala o aplicativo especificado no dispositivo conectado via Android Debug Bridge (ADB).

### Remover Informações do Gemfile.lock

Antes de executar bundle install, remova informações desatualizadas do ```Gemfile.lock``` para evitar conflitos de dependências.

#### Subindo o Appium Server com CORS Permitido
```sh
appium --base-path /wd/hub --allow-cors
```
Este comando inicia o servidor Appium com CORS (Cross-Origin Resource ```sharing) permitido, necessário para utilizar o Inspector Web do Appium.

### Configuração Adicional para o Inspector Web do Appium
Para que o Inspector Web do Appium funcione corretamente, é necessário permitir CORS, conforme mostrado acima:

```sh
appium --base-path /wd/hub --allow-cors
```
Isso permite que o Inspector Web interaja com o servidor Appium a partir de diferentes origens.
