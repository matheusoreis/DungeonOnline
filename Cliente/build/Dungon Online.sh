#!/bin/sh
echo -ne '\033c\033]0;Dungon Online\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Dungon Online.x86_64" "$@"
