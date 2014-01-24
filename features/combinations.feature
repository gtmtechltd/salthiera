Feature combine hierarchies in various ways

  In order to extract data from a hierarchy
  As a developer using salthiera
  I want to use the salthiera tool to extract data in various ways

  Scenario: combine basic yaml
    When I run `salthiera -c ./salthiera_yamltest.conf`
    Then the output should contain 'low_yaml_key: low_yaml_value_in_common'
    Then the output should contain 'middle_yaml_key: middle_yaml_value_in_common'
    Then the output should contain 'high_yaml_key: high_yaml_value_in_override'
    Then the output should not contain 'high_yaml_key: high_yaml_value_in_common'

  Scenario: combine basic yaml with parameter
    When I run `salthiera -c ./salthiera_yamltest.conf environment=test`
    Then the output should contain 'low_yaml_key: low_yaml_value_in_common'
    Then the output should contain 'middle_yaml_key: middle_yaml_value_in_test'
    Then the output should contain 'high_yaml_key: high_yaml_value_in_override'
    Then the output should not contain 'middle_yaml_key: middle_yaml_value_in_common'
    Then the output should not contain 'high_yaml_key: override_yaml_value_in_common'
    Then the output should not contain 'high_yaml_key: override_yaml_value_in_test'

  Scenario: combine basic eyaml
    When I run `salthiera -c ./salthiera_eyamltest.conf`
    Then the output should contain 'low_eyaml_key: low_eyaml_value_in_common'
    Then the output should contain 'middle_eyaml_key: middle_eyaml_value_in_common'
    Then the output should contain 'high_eyaml_key: high_eyaml_value_in_override'
    Then the output should not contain 'high_eyaml_key: high_eyaml_value_in_common'

  Scenario: combine basic eyaml with parameter
    When I run `salthiera -c ./salthiera_eyamltest.conf environment=test`
    Then the output should contain 'low_eyaml_key: low_eyaml_value_in_common'
    Then the output should contain 'middle_eyaml_key: middle_eyaml_value_in_test'
    Then the output should contain 'high_eyaml_key: high_eyaml_value_in_override'
    Then the output should not contain 'middle_eyaml_key: middle_eyaml_value_in_common'
    Then the output should not contain 'high_eyaml_key: override_eyaml_value_in_common'
    Then the output should not contain 'high_eyaml_key: override_eyaml_value_in_test'

  Scenario: combine basic text files
    When I run `salthiera -c ./salthiera_filestest.conf`
    Then the output should contain 'low_textfile: low_textfile_value_in_common1'
    Then the output should contain 'middle_textfile: middle_textfile_value_in_common1'
    Then the output should contain 'high_textfile: high_textfile_value_in_override1'
    Then the output should not contain 'high_textfile: high_textfile_value_in_common1'

  Scenario: combine basic text files with parameter
    When I run `salthiera -c ./salthiera_filestest.conf environment=test`
    Then the output should contain 'low_textfile: low_textfile_value_in_common1'
    Then the output should contain 'middle_textfile: middle_textfile_value_in_test1'
    Then the output should contain 'high_textfile: high_textfile_value_in_override1'
    Then the output should not contain 'middle_textfile: middle_eyaml_value_in_common1'
    Then the output should not contain 'high_textfile: override_eyaml_value_in_common1'
    Then the output should not contain 'high_textfile: override_eyaml_value_in_test1'

  Scenario: combine basic binary files
    When I run `salthiera -c ./salthiera_filestest.conf`
    Then the output should contain 'low_binaryfile: !binary |'
    And the output should contain 'yIUePibX17zsI2LF8UPOmjyKHkIICGiEE0WQIGLj3AykE8ilVKgQRBDwnboC'  #low-binaryfile-in-common
    Then the output should contain 'middle_binaryfile: !binary |'
    And the output should contain 'u0KiEABA3PYcvhwGqy0N7W9em657zFYAwOLgh8y799uDQ47nAxBu5HRXe/nt'  #middle-binaryfile-in-common
    Then the output should contain 'high_binaryfile: !binary |' #high-override
    And the output should contain 'cURYMpdZLfcAnswdARARnIUU8yU4GBF5nx7bK3eQPEy+VIEKAhUNycF3G8SN'  #high-binaryfile-in-override
    Then the output should not contain 'high_binaryfile: !binary |'
    And the output should not contain 'v3FlDXcEIeRSk1w2SEUgYUbojiaUCswmEzANVS4gmlFlby9u/jUeZzkCYe7T'  #high-binaryfile-in-common

  Scenario: combine basic binary files with parameter
    When I run `salthiera -c ./salthiera_filestest.conf environment=test`
    Then the output should contain 'low_binaryfile: !binary |'
    And the output should contain 'yIUePibX17zsI2LF8UPOmjyKHkIICGiEE0WQIGLj3AykE8ilVKgQRBDwnboC'      #low-binaryfile-in-common
    Then the output should contain 'middle_binaryfile: !binary |'
    And the output should contain 'qrKBipCPUcGZGZOIMFPpU5LRd7NVkeg/IZMP3uDwSmR0OWwgBQCFiEsnij3u'      #middle-binaryfile-in-test
    Then the output should contain 'high_binaryfile: !binary |'
    And the output should contain 'cURYMpdZLfcAnswdARARnIUU8yU4GBF5nx7bK3eQPEy+VIEKAhUNycF3G8SN'      #high-binaryfile-in-common
    Then the output should not contain 'middle_binaryfile: !binary |'
    And the output should not contain 'u0KiEABA3PYcvhwGqy0N7W9em657zFYAwOLgh8y799uDQ47nAxBu5HRXe/nt'  #middle-binaryfile-in-common
    Then the output should not contain 'high_binaryfile: !binary |'
    And the output should not contain 'v3FlDXcEIeRSk1w2SEUgYUbojiaUCswmEzANVS4gmlFlby9u/jUeZzkCYe7T'  #high-binaryfile-in-common
    Then the output should not contain 'high_binaryfile: !binary |'
    And the output should not contain 'aVywdQ3AMtn31AnfO9tioym+6DlxVw+PZOEHXVubj0KsTrIAAAAASUVORK5C'  #high-binaryfile-in-test

