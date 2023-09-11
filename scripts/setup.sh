#!/bin/bash

cd $(git rev-parse --show-toplevel)

read -p "Enter your Youtube API key: " YOUTUBE_API_KEY

if [ ! -f .env ]; then
  cp .env.example .env
fi

sed -i '' "s/ENV_VAR_YOUTUBE_API_KEY=.*/ENV_VAR_YOUTUBE_API_KEY=$YOUTUBE_API_KEY/" .env

echo "Setup complete!"
