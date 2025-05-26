#!/bin/sh
echo -ne '\033c\033]0;Dodge_the_creeps\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Dodge_the_creeps.x86_64" "$@"
