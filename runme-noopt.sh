#!/bin/sh
puppet apply --modulepath modules manifests/site.pp --noop --verbose

