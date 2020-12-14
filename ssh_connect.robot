*** Settings ***
Library  OperatingSystem
Library  Process
Library  Collections

Suite Setup    Start vms
Suite Teardown  Teardown vms
*** Variables ***

*** Test Cases ***

*** Keywords ***
Start vms
    Start process     C:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe  startvm  ubuntu_1  {c0382caa-6ce6-4fd3-aab4-77ea96bff7f7}  --type  headless
    Start process     C:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe  startvm  ubuntu_2  {c0382caa-6ce6-4fd3-aab4-77ea96bff7f7}  --type  headless
Teardown vms    
    Start process     C:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe  controlvm  ubuntu_1  poweroff
    Start process     C:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe  controlvm  ubuntu_2  poweroff
