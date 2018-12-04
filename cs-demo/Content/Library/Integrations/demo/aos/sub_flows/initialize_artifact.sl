namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.51
    - username: root
    - password: admin@123
    - artifact_url:
        required: false
    - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - url: '${artifact_url}'
            - artifact_name: filename
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - url: '${script_url}'
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script
    - delete_script:
        do:
          Integrations.demo.aos.tools.delete_file: []
        navigate:
          - SUCCESS: has_failed
          - FAILURE: on_failure
    - has_failed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "str(command_return_code == '0')"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_artifact_given:
        x: 347
        y: 146
      copy_artifact:
        x: 108
        y: 260
      copy_script:
        x: 424
        y: 288
      execute_script:
        x: 99
        y: 440
      delete_script:
        x: 344
        y: 466
      has_failed:
        x: 551
        y: 505
        navigate:
          c12a1237-2397-0b9a-efc1-6fa31a6f1421:
            targetId: dbccbcdb-4a04-6a45-19e6-bffb0ab2c276
            port: 'TRUE'
          1ce19490-f6b5-fa45-d8eb-c4ef0682e430:
            targetId: c43ad8b0-fb5d-80aa-9477-21f8399017fa
            port: 'FALSE'
    results:
      SUCCESS:
        dbccbcdb-4a04-6a45-19e6-bffb0ab2c276:
          x: 696
          y: 405
      FAILURE:
        c43ad8b0-fb5d-80aa-9477-21f8399017fa:
          x: 684
          y: 540
