Feature data extraction through yaml

  In order to extract data from a hierarchy
  As a developer using salthiera
  I want to use the salthiera tool to extract data in various ways

  Scenario: extract basic yaml
    When I run `salthiera -c ./salthiera_yamltest.conf`
    Then the output should contain 'unique_key: unique_value'
    Then the output should contain 'common_key: common_value1'
    Then the output should contain 'override_key: override_value2'
    Then the output should not contain 'override_key: override_value1'

  Scenario: extract basic yaml with parameter
    When I run `salthiera -c ./salthiera_yamltest.conf environment=test`
    Then the output should contain 'unique_key: unique_value'
    Then the output should contain 'common_key: common_value2'
    Then the output should contain 'override_key: override_value2'
    Then the output should not contain 'common_key: common_value1'
    Then the output should not contain 'override_key: override_value1'
    Then the output should not contain 'override_key: override_value3'

