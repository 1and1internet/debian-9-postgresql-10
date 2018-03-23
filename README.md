# PostgreSql 9.6 Debian 9 (Streach) Docker Image

TODO:
* configurability
    * See https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server
    * (select name, setting, unit, sourcefile, context,vartype,min_val, max_val from pg_settings;)
* Memory limits for containers?
* Fix this README
* Fix the testpack test
* Add to image-drone / update webhook / get CI working

## Description

This image provides an instance of [PostgreSql] running on [Debian 9](https://www.debian.org/). This is created specifically to be run under [OpenShift Origin](https://www.openshift.org/) and [Kubernetes](https://kubernetes.io/), as well as any other standard Docker environment.

**Ensure you specify a user id (UID) other than zero. Running as root is not a supported configuration.**

## Current Status: Work In Progress

This image is currently an experimental work in progress.

## Environment Variables
