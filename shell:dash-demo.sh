#!/usr/bin/env -S -i dash -efu
# shellcheck disable=SC2096
# dash demo
export LC_ALL=C
LFTAB="$(printf "\\n\\tx")"
export IFS="${LFTAB%x}"
XLFTAB="$(printf '%b_' '\n\t')"
XLFTAB="${XLFTAB%_}"
test "$IFS" = "$XLFTAB"
unset PWD # the only environment variable set by default
invalid_command 2>&- | { printf "testing -e\\n"; exit 0; }
invalid_command 2>&- | ( printf "testing -e\\n"; exit 0; )
invalid_command 1>&- 2>&1 || :
{ invalid_command; } 2>&- || printf "testing -e\\n" 
(invalid_command) 2>&- || printf "testing -e\\n"
ls -- * 2>&- || printf "testing -f\\n"
echo "${test:-testing -u}"
env
(env)
(
    env
)
{ env; }
{
    env
}
IFS=' '
items="a b c"
for x in $items; do
    echo "$x"
done
# shellcheck disable=SC2169
IFS=$'\t\n'
for y in $items; do
    echo "$y"
done
# ? false ? ?
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=en_US.UTF-8 grep '[[:alnum:]]' || echo false
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=C grep '[[:alnum:]]' || echo false
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=en_US.UTF-8 grep "$(/usr/bin/printf '\xC3\xA4')" || echo false
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=C grep "$(/usr/bin/printf '\xC3\xA4')" || echo false

eof() {
    printf "test1"
    /usr/bin/printf '\x0A'
    printf "unreached"
}
read -r var <<-EOF
$(eof)
EOF
printf "%s\\n" "$var"
# $1 intentionally unquoted
# shellcheck disable=SC2254
fnmatch () { case "$2" in $1) return 0 ;; *) return 1 ;; esac ; }
fnmatch 'te?t*' "$var" && { printf "found\\n"; }
printf -- "\\n-------- %s --------" "END"
