#!/bin/bash -u
# Script_name     : rtinfo
# Author          : Hector Perez
# Description     : Show info of kernel
# Version         : v1.0

echo ""
echo "### Clock sources: " `cat /sys/devices/system/clocksource/clocksource0/available_clocksource`
echo "    Clock source used: " `cat /sys/devices/system/clocksource/clocksource0/current_clocksource`

echo ""
echo "### Kernel boot params: "
cat /proc/cmdline
echo "worthy of interest: nohz=on (off for ptp) nohz_full=cpulist rcu_nocbs=cpulist rcu_nocb_poll idle=poll \
      processor.max_cstate=1 intel_pstate=disable nosoftlockup mce=ignore_ce threadirqs maxcpus=2 mitigations=off nowatchdog tsc=nowatchdog"
echo "edit file in /etc/default/grub and run sudo update-grub"
echo ""
echo "### Kernel " `uname -r` " configuration"
grep -e "CONFIG_IRQ_FORCED_THREADING=" -e "PREEMPT" -e "CONFIG_HZ=" -e "CONFIG_HIGH_RES_TIMERS=" -e "CONFIG_RT_MUTEXES=" -e "CONFIG_NO_HZ" -e "CONFIG_TASK_ISOLATION=" /boot/config-`uname -r`

echo ""
echo "### Max migration of threads to CPUS (i.e., this implies locks): " `cat /proc/sys/kernel/sched_nr_migrate`

echo ""
echo "### Real-Time Throttling"
echo "Tiempo de CPU total para todos los threads del sistema (en microsegundos)  : " `cat /proc/sys/kernel/sched_rt_period_us` " "

echo "Tiempo de CPU disponible para los threads de tiempo real (en microsegundos): " `cat /proc/sys/kernel/sched_rt_runtime_us` " "

echo ""

read -r -p "   Do you wanna continue and disable Real-Time Throttling? [y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
   then
      echo '-1' | sudo tee /proc/sys/kernel/sched_rt_runtime_us
      echo "Tiempo de CPU disponible para los threads de tiempo real (en microsegundos): " `cat /proc/sys/kernel/sched_rt_runtime_us` " "
fi

echo ""
echo "### Recommendations: Use non-gui shell for better results"

