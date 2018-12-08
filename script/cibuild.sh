#!/usr/bin/env bash
set -e # halt script on error

python --version
pip --version
echo -e "[\033[32m OK \033[0m] Found Python."

pip install docutils pygments
echo -e "[\033[32m OK \033[0m] Python packages installed."

bundle install
bundle update
gem install RbST
echo -e "[\033[32m OK \033[0m] Dependencies updated."

bundle exec jekyll build
echo -e "[\033[32m OK \033[0m] Site generated."

pygmentize -S default -f html > _site/css/pygments.css
echo -e "[\033[32m OK \033[0m] Code highlighting CSS generated."
