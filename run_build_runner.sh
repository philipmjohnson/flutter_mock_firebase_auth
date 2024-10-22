#!/bin/sh
# Invokes the builder running code generation facility,
# needed for entities using Freezed, JSON Serializable, and Riverpod.
set -x #echo on
dart run build_runner build --delete-conflicting-outputs
