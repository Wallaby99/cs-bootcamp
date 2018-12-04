namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.51
    - username: root
    - password: admin@123
    - filename: deploy_war.sh
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 159
        y: 205
        navigate:
          65f7a2d7-9905-dd54-5d22-ea23d302ea2f:
            targetId: 9545729a-8cb3-09d1-c932-35a45be22798
            port: SUCCESS
    results:
      SUCCESS:
        9545729a-8cb3-09d1-c932-35a45be22798:
          x: 422
          y: 163
