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
# Hide errors and does -e work?
invalid_command 2>&- | { printf "testing -e\\n"; exit 0; }
invalid_command 2>&- | ( printf "testing -e\\n"; exit 0; )
invalid_command 1>&- 2>&1 || :
{ invalid_command; } 2>&- || printf "testing -e\\n" 
(invalid_command) 2>&- || printf "testing -e\\n"
# Does -f work?
ls -- * 2>&- || printf "testing -f\\n"
# Does parameter substitution work when -u?
echo "${test:-testing -u}"
# Calling env MUST only show exported LC_ALL and IFS
env
(env)
(
    env
)
{ env; }
{
    env
}
# Try a space IFS
IFS=' '
items="a b c"
for x in $items; do
    echo "$x"
done
# Tab and newline IFS
# shellcheck disable=SC2169
IFS=$'\t\n'
for y in $items; do
    echo "$y"
done
# Test LC_ALL settings
# ? false ? ?
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=en_US.UTF-8 grep '[[:alnum:]]' || echo false
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=C grep '[[:alnum:]]' || echo false
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=en_US.UTF-8 grep "$(/usr/bin/printf '\xC3\xA4')" || echo false
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=C grep "$(/usr/bin/printf '\xC3\xA4')" || echo false

test_local()
{
    # Note: local inside subshells are not needed but good for consistency.
    local local_unreachable="x"
}
test_local
printf "%s\\n" "${local_unreachable:-local_ok}"
test_global()
{
    global_reachable="global_ok"
}
test_global
printf "%s\\n" "${global_reachable:-global_not_ok}"
test_sglobal()
(
    # shellcheck disable=SC2030
    sglobal_reachable="x"
)
test_sglobal
# shellcheck disable=SC2031
printf "%s\\n" "${sglobal_reachable:-global_in_subshell_ok}"
# Test read() variables
eof() {
    printf "test1"
    /usr/bin/printf '\x0A'
    printf "unreached"
}
read -r var <<-EOF
$(eof)
EOF
printf "%s\\n" "$var"
# fnmatch trick from etalabs
# $1 intentionally unquoted
# shellcheck disable=SC2254
fnmatch () { case "$2" in $1) return 0 ;; *) return 1 ;; esac ; }
fnmatch 'te?t*' "$var" && { printf "found\\n"; }
printf -- "\\n-------- %s --------\\n" "END"
