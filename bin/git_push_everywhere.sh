#!/bin/bash

for repo in `git remote`;do
	git push $repo --all
done
