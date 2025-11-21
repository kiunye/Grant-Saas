#!/usr/bin/env bash
# exit on error
set -o errexit

# Workaround for asset precompilation failure when RAILS_MASTER_KEY is missing or invalid
if [[ -z "${SECRET_KEY_BASE}" ]]; then
  export SECRET_KEY_BASE=3f8f9f511365fc3922ea9188564dd354caede29c02caa9fa1329b5d7345d95184972fb0df0c19d1744543de0d9cd6edf5533aa5eb5d184327be28637cb004d7d
fi

# Unset RAILS_MASTER_KEY to avoid decryption errors if the key is incorrect
# This forces Rails to rely on environment variables for configuration
unset RAILS_MASTER_KEY

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
bundle exec rails db:seed
