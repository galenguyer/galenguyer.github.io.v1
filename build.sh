#!/bin/bash
JEKYLL_ENV=selfhost bundle exec jekyll build --trace
rsync -avuP ./_site/ /var/www/galenguyer.com/
