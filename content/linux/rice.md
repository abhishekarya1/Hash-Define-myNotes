+++
title = "Desktop Customization"
date =  2023-05-17T21:21:00+05:30
weight = 8
+++

{{<mermaid align="center">}}

graph BT;
A[Kernel] --> B[Display Server]
B --> C(Desktop Environment)
B --> D(Window Manager)
C --> E(User)
D --> E
F[Hardware] --> A

{{< /mermaid >}}



**Desktop Environment** (KDE, GNOME, xfce): includes everything listed below; pre-made GUI served on a golden platter

**Window Manager** (dwm, i3, awesome): we can use window manager _instead_ of a desktop manager since its lightweight and highly customizable

**Display Server** (X, Wayland): communicates directly with the kernel

- X server is old and reliable. Also called "X.org" or "X11".

- In Wayland, the window manager is part of the display server, the function of both is handled by the **Wayland compositor** like [Hyprland](https://hyprland.org/).

**Ricing**: replace default window manager of the distro with any other (often dwm if X11) and other custom tools for theming. Most distros have Wayland nowadays and we just need to enable it to use it.
