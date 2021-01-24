# NIC-persist-naming

NIC persist-naming for OpenWrt based on netifd and hotplug. 

**ONLY PCI NIC WILL BE RENAMED**, currently only being tested on KVM based OpenWrt VM.

Following naming scheme from systemd:
	https://www.freedesktop.org/software/systemd/man/systemd.net-naming-scheme.html
Example: 
	DEVPATH: /devices/pci0000:00/0000:00:0a.2/net/eth3 (with dev_port 2)
	NAMING: enp0s10f2d2 (Meanwhile, function 0 of this multiport NIC should be: enp0s10f0 (d0 is omitted))