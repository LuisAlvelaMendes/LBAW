#!/bin/bash

sudo apt-get clean
sudo apt-get autoremove --purge
sudo apt-get autoclean
sudo journalctl --vacuum-time=3d
rm -rf ~/.cache/thumbnails/*