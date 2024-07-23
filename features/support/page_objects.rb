# Pagina que garante que toda nova screen criada funcione em qualquer parte do projeto, sem precisar instanciar novamente as classes

module PageObjects
    def homePage
        HomePageScreen.new
    end

    def configPage
        ConfigPageScreen.new
    end
end