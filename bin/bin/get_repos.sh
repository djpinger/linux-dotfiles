#!/bin/bash
find ~/g -path '*/.git/config' -execdir git remote get-url origin \; | sort -n | uniq | grep -v '^ssh'
