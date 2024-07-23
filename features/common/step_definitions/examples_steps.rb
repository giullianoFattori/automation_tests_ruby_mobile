Given('I access home page') do
    homePage.touch_btnStartNow
end

When('I am access configuration') do
    configPage.touch_btnGaveta
    configPage.touch_btnConfig
    
end

Then('I use the scroll method') do
    configPage.swipe_to_element configPage.btnAvacado
end

When('I return to celphone home') do
    configPage.back if configPage.is_android?
end

Then('I use the side scroll method') do
    configPage.swipe_screen 'left'
    configPage.swipe_screen 'right'
end

When('I create new deck') do
    homePage.touch_btnNew
    homePage.touch_btnNewDeck
    homePage.enter_inpDeckName "teste #{rand(123456789)}"
end

Then('the new deck created with success') do
    homePage.accept_alert_if_present
end
