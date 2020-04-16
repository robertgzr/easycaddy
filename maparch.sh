#!/bin/sh
set -e

case "$1" in
    linux/amd64) arch="amd64" ;;
    linux/386) arch="i386" ;;
    linux/arm64) arch="aarch64" ;;
    linux/arm/v7) arch="armv7hf" ;;
    *) printf "%s is unsupported!\n" "$1"; exit 1 ;;
esac

printf "%s" $arch
