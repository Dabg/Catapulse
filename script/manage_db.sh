#!/bin/sh

export DBIC_MIGRATION_SCHEMA_CLASS=Catapulse::Schema

dbic-migration -Ilib $@
