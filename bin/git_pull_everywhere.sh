#!/bin/bash

for repo in `git remote`;do
	git pull $repo $@
done
