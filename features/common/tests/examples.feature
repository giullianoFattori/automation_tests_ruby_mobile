Feature: Teste

  @swipe
  Scenario: Scroll testing
    Given I access home page
    When I am access configuration
    Then I use the scroll method

  @side_swipe
  Scenario: Side scroll testing
    Given I access home page
    When I return to celphone home
    Then I use the side scroll method

  @enter
  Scenario: Enter testing
    Given I access home page
    When I create new deck
    Then the new deck created with success
  