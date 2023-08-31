#!/bin/bash

# Script_name     : RT_VM_Create
# Author          : Simmat Noé
# Description     : Creates an image for RTOS related to ACRN Hypervisor
# Version         : v1.0


remote_user="acrn"
remote_host="193.144.198.30"
remote_password="noeacrn23"

remote_directory="~/acrn-work"

command_to_execute="cd ~/acrn-work 
cp ./acrn-hypervisor*.deb ./*acrn-service-vm*.deb /tmp
cp ~/rt_vm.img ~/acrn-work/ 
echo $remote_password | sudo -S apt purge acrn-hypervisor 
echo $remote_password | sudo -S apt install /tmp/acrn-hypervisor*.deb  /tmp/*acrn-service-vm*.deb"

counting_files="$(find ~/acrn-work/MyConfiguration/ -type f -name 'launch_user_vm_id*.sh' | wc -l)"

final_command="sshpass -p "$remote_password" ssh "${remote_user}@${remote_host}" "echo $remote_password | sudo -S ~/acrn-work/launch_user_vm_id${i}.sh""


cd ~/acrn-work/acrn-hypervisor
make clean
debian/debian_build.sh clean && debian/debian_build.sh -c ~/acrn-work/MyConfiguration
cd ~/acrn-work
echo ${remote_user}@${remote_host}:${remote_directory}

cd ~/acrn-work

sshpass -p "$remote_password" scp acrn-hypervisor*.deb ${remote_user}@${remote_host}:$remote_directory
sshpass -p "$remote_password" scp MyConfiguration/launch_user_vm_id*.sh ${remote_user}@${remote_host}:$remote_directory

sshpass -p "$remote_password" ssh "${remote_user}@${remote_host}" "$command_to_execute"
sshpass -p "$remote_password" ssh "${remote_user}@${remote_host}" "echo $remote_password | sudo -S reboot"


sleep 45

for i in $(seq 1 $counting_files)
do
    sshpass -p "$remote_password" ssh "${remote_user}@${remote_host}" "echo $remote_password | sudo chmod -S +x ~/acrn-work/launch_user_vm_id${i}.sh"
    gnome-terminal -- bash -c "sshpass -p "$remote_password" ssh "${remote_user}@${remote_host}" ; exec bash"   
done















