# Automação testes funcionais de apps externos #
Projeto para utilização e padronização em projetos de automação de testes para mobile, na linguagem Ruby

## Como o projeto está organizado ##
***
```
automation_tests_ruby_mobile/
├── Gemfile
├── Gemfile.lock
├── README.md
├── RakeFile
├── config
│   ├── app
│   └── cucumber.yml
└── features
    ├── android
    │   └── screens
    ├── common
    │   ├── base_screen.rb
    │   ├── environment
    │   ├── modules
    │   ├── specs
    │   └── step_definitions
    ├── ios
    │   └── screens
    └── support
        ├── caps
        └── helpers
    
```

### Elementos de tela ###

O projeto está estruturado de forma a facilitar a inclusão de novos elementos de tela, junto as suas principais interações, como tocar (touch), tocar e escrever um texto (enter), checar se o elemento está visível (displayed?) e checar a existência de um elemento (exist?). Não havendo a necessidade de criar novos métodos para cada novo elemento criado dentro de uma classe.

```ruby
class ExampleScreen < BaseScreen

	# Abaixo temos a declaração dos elementos necessários
	identificator(:name_field) { 'nome_do_campo' }
	identificator(:phone_field) { 'nome_do_campo' } 
	identificator(:btn_confirm) { 'nome_do_campo' }
	
end
```

```ruby
Quando(/^cofirmar a ação$/) do
	@page = ExampleScreen.new
	@page.enter_name_field('Teste de agora')
	@page.enter_phone_field('1199990000')
	@page.touch_btn_confirm
end
```

### Reaproveitamento dos métodos ###

Todos os métodos que forem iguais entre as plataformas devem estar em módulos e incluídos nas screens que fizerem sentido, como no exemplo abaixo:

Modulo:

```ruby
module ExampleModule
	
  def confirm_action
    enter('Outro teste', email_field)
    enter('1199990000', phone_field)
    wait_for_element_then_touch(btn_confirm)
  end
  
end
```

Classes:

```ruby
#Android
class ExampleScreen < BaseScreen

    include ExampleModule
    
	identificator(:name_field) { 'name_android' }
	identificator(:phone_field) { 'phone_android' } 
	identificator(:btn_confirm) { 'button_android' }
	
end
```

Chamada:

```ruby
Quando(/^cofirmar a ação$/) do
	@page = ExampleScreen.new 
  	@page.confirm_action
end
```

## Configuração do projeto para executar ##
---

- Homebrew (Colocar o comando abaixo no terminal)

  ```
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  ```

- Ruby (Seguir os comandos abaixo na ordem)

  ```
  brew install readline
  ```
  ```
  brew install rbenv
  ```
  ```
  rbenv init
  ```
  ```
  RUBY_CONFIGURE_OPTS=--with-readline-dir="$(brew --prefix readline)" rbenv install 2.6.3
  ```
  ```
  rbenv global 2.6.3
  ```

- JDK > 7 (Instalar pelo link abaixo)

	<a href="http://www.oracle.com/technetwork/pt/java/javase/downloads/index.html">http://www.oracle.com/technetwork/pt/java/javase/downloads/index.html</a>&nbsp;

- Android Studio (Instalar Android Studio pelo link abaixo)

	<a href="https://developer.android.com/studio/">https://developer.android.com/studio/</a>&nbsp;

- Xcode
	
  O Xcode deve ser instalado pela própria App Store.

  Após instalar o Xcode, executar o comando abaixo no terminal:

  ```
  xcode-select --install
  ```

- Carthage

  ```
  brew install carthage
  ```
	
- Node

  ```
  brew install node
  ```

- Appium Server

  ```
  npm install -g appium
  ```
  
- Appium Desktop

  https://github.com/appium/appium-desktop/releases/latest


- Instalar Bundler
  ```
  gem install bundler
  ```

Executar o comando abaixo na raiz do projeto (qa-functional-tests) para instalar as dependências.

  ```
  bundle install
  ```

- Capabilities

    Os capabilities já estão no clone, previamente configurados.

  ## Executando o projeto ##
---
- Subindo Appium Server
  ```
  appium
  ```

- Executando o projeto
  ```
  bundle exec cucumber -p <plataforma> -t <teste selecionado>
  ```