#!/bin/bash

echo "After script"

bundle install --gemfile=/vagrant/Gemfile --jobs=4
rbenv rehash
