#!/bin/bash
# This produces a env-config.js file that called in at the root level of the react application.
# It will try to use server environment variables and if not found will use the env.template file
# There's nginx config that busts the cache on this file to ensure it's reloaded each time to account for config changes.

# Generate environment config file
touch ./env-config.js

# Add assignment
echo "window.env = {" >> ./env-config.js

# Read each line in .env file
# Each line represents key=value pairs
while read -r line || [[ -n "$line" ]];
do
  # Split env variables by character `=`
  if printf '%s\n' "$line" | grep -q -e '='; then
    varname=$(printf '%s\n' "$line" | sed -e 's/=.*//')
    varvalue=$(printf '%s\n' "$line" | sed -e 's/^[^=]*=//')
  fi

  # Read value of current variable if exists as Environment variable
  value=$(printf '%s\n' "${!varname}")
  # Otherwise use value from .env file
  [[ -z $value ]] && value=${varvalue}

  # Append configuration property to JS file
  echo "  $varname: \"$value\"," >> ./env-config.js
done < .env

echo "}" >> ./env-config.js