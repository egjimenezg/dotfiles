#!/usr/bin/env bash
# install asdf plugins

plugins=(
  "awscli"
  "elixir"
  "erlang"
  "python"
  "packer"
  "terraform"
  "postgres"
  "jq"
  "nodejs"
)

for plugin in "${plugins[@]}"; do
  asdf plugin add "$plugin" || true
done
