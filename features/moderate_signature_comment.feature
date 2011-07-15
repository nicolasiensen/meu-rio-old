Feature: Moderate a signature comment
  In order to filter inadequate comments 
  As an admin
  I want to moderate a signature comment

  Scenario: Petition Signatures index
    Given I am logged in to the admin section
    And 2 petition signatures exist
    When I follow "Moderate Petition Comments"
    Then I should see a list of petition signatures

  Scenario: See comment accepted
    Given I am logged in to the admin section
    And 1 petition signatures exist
    And the first comment is accepted
    When I follow "Moderate Petition Comments"
    Then I should see the first signature having "Comment Accepted" as "Yes"

  Scenario: See comment rejected
    Given I am logged in to the admin section
    And 1 petition signatures exist
    And the first comment is rejected
    When I follow "Moderate Petition Comments"
    Then I should see the first signature having "Comment Accepted" as "No"

  Scenario: Accept comment
    Given I am logged in to the admin section
    And 1 petition signatures exist
    When I follow "Moderate Petition Comments"
    And I click "Yes"
    Then the comment should be accepted

  Scenario: Reject comment
    Given I am logged in to the admin section
    And 1 petition signatures exist
    When I follow "Moderate Petition Comments"
    And I click "No"
    Then the comment should be rejected
