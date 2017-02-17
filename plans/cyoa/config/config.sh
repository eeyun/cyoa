#!/bin/bash
# General Flask app settings
export DEBUG="{{cfg.flash.debug}}"
export SECRET_KEY="{{cfg.flask.key}}"
{{#if bind.has_database ~}}
export DATABASE_URL="postgresql://{{cfg.database.username}}:{{cfg.database.password}}@{{bind.database.members[0].sys.ip}}:5432/cyoa"
{{else ~}}
export DATABASE_URL="postgresql://{{cfg.database.username}}:{{cfg.database.password}}@localhost/cyoa"
{{/if ~}}

# Redis connection
{{#if bind.has_redis ~}}
{{~#each bind.redis.members}}
{{~#if leader}}
export REDIS_SERVER="{{sys.ip}}"
{{/if ~}}
{{/each ~}}
export REDIS_PORT="{{cfg.redis.port}}"
export REDIS_DB="{{cfg.redis.database}}"
{{else ~}}
export REDIS_SERVER="{{cfg.redis.ip}}"
export REDIS_PORT="{{cfg.redis.port}}"
export REDIS_DB="{{cfg.redis.database}}"
{{/if ~}}

# Twilio API credentials
export TWILIO_ACCOUNT_SID="{{cfg.twilio.sid}}"
export TWILIO_AUTH_TOKEN="{{cfg.twilio.token}}"
export TWILIO_NUMBER="{{cfg.twilio.number}}"
