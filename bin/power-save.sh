#!/bin/bash

sudo su -c 'echo powersupersave > /sys/module/pcie_aspm/parameters/policy'
