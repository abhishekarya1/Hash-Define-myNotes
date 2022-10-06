+++
title = "Virtualization"
date =  2022-09-21T15:57:00+05:30
weight = 6
+++

## Virtualization

**Virtual Machines**: complete simulated computers with an OS, memory, storage, input, output, etc...

**Hypervisor**: Middleware enabling and managing multiple kernels to run on it.

- Native/Bare metal: Run directly on hardware. Ex - Hyper-V, KVM (built-in in Linux).
	
- Hosted: Run atop a "guest" OS. Ex - VMWare, Oracle Virtual Box.

Hypervisor is also called a _Virtual Machine Manager_ (VMM).

**OS-level virtualization**: In conventional virtualization, multiple full blown OS run on a single machine. In OS-level virtualization, multiple isolated spaces (often called "_containers_") run on a single OS.

**Container**: Lightweight standalone runtime environment having only parts of the "full" kernel. Ex - Docker, LXC, etc... Kernel is "trimmed down" and contains only libraries and tools required for a specfic use case.

![Container vs VM image](https://i.imgur.com/prJGvDM.png)

**IaaS** (Infrastructure as a Service): Rent pre-configured hardware (aka infrastructure) and do anything you like with it minus the maintainance.

Advantages:
- elasticity
- load balancing