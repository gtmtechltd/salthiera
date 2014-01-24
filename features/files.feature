Feature data extraction through files

  In order to extract data from a hierarchy
  As a developer using salthiera
  I want to use the salthiera tool to extract data in various ways

  Scenario: extract basic file
    When I run `salthiera -c ./salthiera_yamltest.conf`
    Then the output should contain 'unique_textfile: unique_text_value1 , unique_text_value2'
    Then the output should contain 'common_textfile: common_text_value1 , common_text_value2'
    Then the output should contain 'override_textfile: override_text_value1 , override_text_value2'
    Then the output should not contain 'override_text_originalvalue1'
    Then the output should not contain 'override_text_originalvalue2'

  Scenario: extract basic file with parameter
    When I run `salthiera -c ./salthiera_yamltest.conf environment=test`
    Then the output should contain 'unique_textfile: unique_text_value1 , unique_text_value2'
    Then the output should contain 'common_textfile: common_text_value3 , common_text_value4'
    Then the output should contain 'override_textfile: override_text_value3 , override_text_value4'
    Then the output should not contain 'common_text_value1'
    Then the output should not contain 'common_text_value2'
    Then the output should not contain 'override_text_value3'
    Then the output should not contain 'override_text_value4'
    Then the output should not contain 'override_text_value5'
    Then the output should not contain 'override_text_value6'

