#!/usr/bin/env bash
set -e # halt script on error

bundle install
bundle update
echo -e "[\033[32m OK \033[0m] Dependencies updated."

bundle exec jekyll build
echo -e "[\033[32m OK \033[0m] Site generated."
