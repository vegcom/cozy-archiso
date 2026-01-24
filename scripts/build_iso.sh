#!/bin/bash
:
pacman -S --noconfirm --needed archiso
mkarchiso -v -r -o iso/ build/
