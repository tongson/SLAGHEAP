#!/usr/bin/env -S -i mrsh -efu
# shellcheck disable=SC2096
# mrsh demo
export LC_ALL=C
export PATH=/usr/bin
LFTAB="$(printf "\\n\\tx")"
export IFS="${LFTAB%x}"
XLFTAB="$(printf '%b_' '\n\t')"
XLFTAB="${XLFTAB%_}"
test "$IFS" = "$XLFTAB"
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
# Test LC_ALL settings
# false false ? ?
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=en_US.UTF-8 grep '[[:alnum:]]' || echo false
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=C grep '[[:alnum:]]' || echo false
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=en_US.UTF-8 grep "$(/usr/bin/printf '\xC3\xA4')" || echo false
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=C grep "$(/usr/bin/printf '\xC3\xA4')" || echo false

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
