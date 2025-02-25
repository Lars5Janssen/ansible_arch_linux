#!/bin/bash
mkdir ~/logs/fontcache --parents
DATE="$(date -u +%Y-%m-%d-%H-%M-%S)"
fc-cache -fv ~/.fonts/ >> ~/logs/fontcache/fc-"$DATE" 2>&1
