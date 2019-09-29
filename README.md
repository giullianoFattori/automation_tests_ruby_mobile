# Test automation with Ruby #
Follow this readme for study automation.

## How this projet it's organized ##
***
```
qa-funcional-tests/
├── Gemfile
├── Gemfile.lock
├── README.md
├── RakeFile
├── config
│   ├── app
│   ├── cucumber.yml
│
├── features
│   ├── android
│   │   ├── screens
│   │   ├── specs
│   │   └── step_definitions
│   ├── api
│   │   └── controller
│   ├── common
│   │   ├── base_screen.rb
│   │   ├── modules
│   │   └── specs
│   ├── ios
│   │   ├── screens
│   │   ├── specs
│   │   └── step_definitions
│   └── support
│       ├── caps
│       │   ├── android.txt
│       │   └── ios.txt
│       ├── env.rb
│       └── hooks.rb
└── screenshots
│   ├── android
│   └── ios
└── reports
    
```
## Obs ##
This project it's organized for Android and iOS devices.
Case not you use MacOS, remove all iOS files.

## Standard project ##
---
Follow this standand below for the best form write your automation tests and the best form to pratice your skills.


### Write Specs ###

- Not use terms with scroll, picker, view, or others
- Correct use Given, When e Then
- The tests must guided for data, not fixed in specs

### Tags ###

Standard tags create and how to use

- Tag `@android` features in Android
- Tag `@ios` features in iOS
- Tag `android-report` generate report for Android
- Tag `ios-report` generate report for iOS

### Arquivos ###

Para adição de novos arquivos de classe, feature, specs ou qualquer outro, o projeto segue alguns padrões, dicas gerais:

- Utilizar o padrão snake\_case para nomenclatura dos arquivos. Exemplo: este\_e\_um\_exemplo.rb, outro_exemplo.feature
- Utilizar nomes para os arquivos em português.

### Classes / Métodos ###

- Toda nova classe que descreva uma screen, deve sempre estender a classe BaseScreen, que contém os comportamentos necessários
- Utilizar CamelCase para nomenclatura declarar novas classes
- Utilizar snake_case para nomenclatura de novos métodos
- Utilizar sempre nomes em português para métodos, elementos de tela e nomes de classes
- Utilizar nomes intuitivos para elementos de tela, como 'email_field', 'cpf_field', 'home_pager', 'onboarding_next_button'.

Exemplo que descreve as dicas acima:

```ruby
class ExampleClassScreen < BaseScreen
	
	identificator(:name_field) { 'id_do_elemento' }
	identificator(:phone_field) { 'id_do_elemento' }
	identificator(:btn_confirm) { 'id_do_elemento' }
	
	def here_a_method
		# Comportamento necessário	
	end
	
	def another_method
		# Comportamento necessário
	end
	
end	
```

### Elementos de tela ###

O projeto está estruturado de forma a facilitar a inclusão de novos elementos de tela, junto as suas principais interações, como tocar (touch), tocar e escrever um texto (enter), checar se o elemento está visível (displayed?) e checar a existência de um elemento (exist?). Não havendo a necessidade de criar novos métodos para cada novo elemento criado dentro de uma classe.

```ruby
class ExampleScreen < BaseScreen

	# Abaixo temos a declaração dos elementos necessários
	identificator(:trait) { 'trait_da_tela' }
	identificator(:name_field) { 'nome_do_campo' }
	identificator(:phone_field) { 'nome_do_campo' } 
	identificator(:btn_confirm) { 'nome_do_campo' }
	
end
```

```ruby
Quando(/^cofirmar a ação$/) do
	page = ExampleScreen.new
	page.enter_name_field('Teste de agora')
	page.enter_phone_field('1199990000')
	page.touch_btn_confirm
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

```ruby
#iOS
class ExampleScreen < BaseScreen

    include ExampleModule
    
	identificator(:name_field) { 'XCNAME_FIELD' }
	identificator(:phone_field) { 'XCPHONE_FIELD' } 
	identificator(:btn_confirm) { 'XCCONFIRM_BUTTON' }

end
```

Chamada:

```ruby
Quando(/^cofirmar a ação$/) do
	page = ExampleScreen.new 
  	page.confirm_action
end
```

## Linter ##
---
Antes de commitar qualquer alteração no projeto, deve ser rodado o comando abaixo na pasta raiz do prjeto:

```
rake lint
```

## Configuração do projeto para executar ##
---
*Não usar sudo para fazer as instalações.*

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

- Configuração variáveis de ambiente

  ```
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/<nome_pacote_jdk_instalado>/Contents/Home
  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH=$PATH:$JAVA_HOME/bin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
  ```
  *Importante: Substituir <nome_pacote_java_instalado> pelo nome do pacote JDK instalado pelo link disponibilizado*

- Xcode
	
    O Xcode deve ser instalado pela própria App Store

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

  [https://github.com/appium/appium-desktop/releases/latest][https://github.com/appium/appium-desktop/releases/latest]



- Instalar Bundler

  ```
  gem install bundler
  ```

Executar o comando abaixo na raiz do projeto (qa-funcional-tests) para instalar as depedências

  ```
  bundle install
  ```

## Realizando o build ##
---
### Android ###



## <a name="capabilities">Capabilities</a> ##
---
Para execução do projeto deve ser criado os arquivos de capabilities no caminho features/support/caps/, seguindo o padrão de nomenclatura **android.txt** (para Android) e **ios.txt** (para iOS) 

### Android ###

*Lembrete: Os Capabilities não devem ser commitado para o repositório, para não atrapalhar a execução no CI (já está no .gitignore)*

```
[caps]
    platformName = "Android"
    deviceName = "Device name e.g Nexus_5 or device ID"
    app = "path to apk e.g ./config/app/app-develop-debug.apk"
    avd = 'nome do emulador ou celular android, ex: 'Galaxy_Nexus_API_28'
    
    # Use automationName with UiAutomator2, because default automator, not recognize any elements on the screen
    automationName = "UiAutomator2"
    language = "pt"
	locale = "BR"
	fullReset = true
    
    # Use autoGrantPermissions with true, for authorize any permissions required of the app or use with false for not authorize
    autoGrantPermissions = true
```

### iOS ###

```
[caps]
    platformName = "iOS"
    platformVersion = "platform version e.g = 12.0"
    deviceName = "device name e.g iPhone 6"
    app = "path to app or ipa e.g ./config/app/MinhaSkySwift.app"
    automationName = "XCUITest"
    autoAcceptAlerts = true
    language = "pt"
	locale = "pt_BR"
	fullReset = true
```

*Para ver os devices e versão disponíveis para iOS, executar o comando: `xcrun simctl list`*

## Executando o projeto ##
---
- Subindo Appium Server
  ```
  appium
  ```

- Executando emulador Android (Fazer a execução na raiz do projeto de QA)
  ```
  emulator -list-avds
  ```
  ```
  rake start_emulator[nome_emulador_obtido]
  ```
  *IMPORTANTE: Antes da execução do emulador deve ser criado um, pelo AndroidStudio é possível (desenvolvedores da plataforma podem ajudar), para ser listado pelo comando `emulator -list-avds` para pegar o nome do emulador e substituir no 2º comando pelo `nome_emulador_obtido`*

- Executando o projeto
  ```
  bundle exec cucumber -p plataforma features/sua_feature.feature
  ```

## Gerar Relatorio ###
---

*Usar o parâmetro 'plataforma-report' na execução*
- Rodar teste ios e gerar relatorio:


  ```
  bundle exec cucumber features/sua_feature.feature -p ios-report
  ```
 - Rodar teste android e gerar relatorio:
 
 
   ```
   bundle exec cucumber features/sua_feature.feature -p android-report
   ```
  
  O relatório será gerado em html e ficará disponível na pasta /reports
