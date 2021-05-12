#!/bin/bash
bundle exec jekyll clean
JEKYLL_ENV=selfhost bundle exec jekyll build --trace
rsync -avuh --delete ./_site/ /var/www/galenguyer.com/
