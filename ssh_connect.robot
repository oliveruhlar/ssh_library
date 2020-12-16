*** Settings ***
Library  OperatingSystem
Library  Process
Library  Collections
Library  SSHLibrary

Suite Setup    Start vms
Suite Teardown  Teardown vms
*** Variables ***


*** Test Cases ***
Connect to VMs
    Open Connection  192.168.56.2  alias=vm1
    ${output}=  Wait Until Keyword Succeeds   2min   10s  Login With Public Key  oliveruhlar  w_rsa
    Should Contain  ${output}  Welcome
    Open Connection  192.168.56.3  alias=vm2
    ${output}=  Wait Until Keyword Succeeds   2min   10s  Login With Public Key  oliveruhlar  vm_u2_rsa
    Should Contain  ${output}  Welcome

NIC before setting IPs
    Switch Connection  vm1
    ${stdout_vm1}	${stderr}=	Execute Command	 ip addr  return_stderr=True
    Should Be Empty	${stderr}
    Log  ${stdout_vm1}
    Switch Connection  vm2
    ${stdout_vm2}	${stderr}=	Execute Command	 ip addr  return_stderr=True
    Should Be Empty	${stderr}
    Log  ${stdout_vm2}

Ping before setting IPs
    Switch Connection  vm1
    ${stdout_vm1}	${stderr}=	Execute Command	 ping -c 3 10.2.0.24  return_stderr=True
    Should Be Empty	${stderr}
    Should Contain X Times  ${stdout_vm1}  100% packet loss  1
    Log  ${stdout_vm1}
    Switch Connection  vm2
    ${stdout_vm2}	${stderr}=	Execute Command	 ping -c 3 10.2.0.23  return_stderr=True
    Should Be Empty	${stderr}
    Should Contain X Times  ${stdout_vm2}  100% packet loss  1
    Log  ${stdout_vm2}

Set IPs
    Switch Connection  vm1
    ${stdout_vm1}	${stderr}=	Execute Command	 sudo ifconfig enp0s9 10.2.0.23 up  return_stderr=True
    Should Be Empty	${stderr}
    Log  ${stdout_vm1}
    Switch Connection  vm2
    ${stdout_vm2}	${stderr}=	Execute Command	 sudo ifconfig enp0s9 10.2.0.24 up  return_stderr=True
    Should Be Empty	${stderr}
    Log  ${stdout_vm2}

Ping after setting IPs
    Switch Connection  vm1
    ${stdout_vm1}	${stderr}=	Execute Command	 ping -c 3 10.2.0.24  return_stderr=True
    Should Be Empty	${stderr}
    Should Contain X Times  ${stdout_vm1}  3 received  1
    Log  ${stdout_vm1}
    Switch Connection  vm2
    ${stdout_vm2}	${stderr}=	Execute Command	 ping -c 3 10.2.0.23  return_stderr=True
    Should Be Empty	${stderr}
    Should Contain X Times  ${stdout_vm2}  3received  1
    Log  ${stdout_vm2}

NIC after setting IPs
    Switch Connection  vm1
    ${stdout_vm1}	${stderr}=	Execute Command	 ip addr  return_stderr=True
    Should Be Empty	${stderr}
    Should Contain  ${stdout_vm1}  10.2.0.23
    Log  ${stdout_vm1}
    Switch Connection  vm2
    ${stdout_vm2}	${stderr}=	Execute Command	 ip addr  return_stderr=True
    Should Be Empty	${stderr}
    Should Contain  ${stdout_vm2}  10.2.0.24

    Log  ${stdout_vm2}
*** Keywords ***
Start vms
    Start process     C:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe  startvm  ubuntu_1  {c0382caa-6ce6-4fd3-aab4-77ea96bff7f7}  --type  headless
    Start process     C:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe  startvm  ubuntu_2  {c0382caa-6ce6-4fd3-aab4-77ea96bff7f7}  --type  headless
Teardown vms
    Close All Connections 
    Start process     C:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe  controlvm  ubuntu_1  poweroff
    Start process     C:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe  controlvm  ubuntu_2  poweroff
