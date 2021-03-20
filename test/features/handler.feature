Feature: Personal greeting
  In to be greeted
  As a lambda user
  I need to be able to see my name

  Scenario: Greeting Joe
    Given my name is "Joe"
    When invoke the lambda
    Then I should see "Hello Joe!"