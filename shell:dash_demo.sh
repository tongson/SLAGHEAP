#!/usr/bin/env -S -i dash -efu
# dash demo
export LC_ALL=C
export IFS=$'\t\n'
unset PWD # the only environment variable set by default
invalid_command 2>&- | { printf "testing -e\\n"; exit 0; }
invalid_command 2>&- | ( printf "testing -e\\n"; exit 0; )
invalid_command 1>&- 2>&1 || :
{ invalid_command; } 2>&- || printf "testing -e\\n" 
(invalid_command) 2>&- || printf "testing -e\\n"
ls * 2>&- || printf "testing -f\\n"
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
IFS=$' '
items="a b c"
for x in $items; do
    echo "$x"
done
IFS=$'\t\n'
for y in $items; do
    echo "$y"
done
# ? false ? ?
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=en_US.iso88591 grep '[[:alnum:]]' || echo false
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=C grep '[[:alnum:]]' || echo false
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=en_US.iso88591 grep "$(/usr/bin/printf '\xC3\xA4')" || echo false
/usr/bin/printf '\xC3\xA4' |
    LC_ALL=C grep "$(/usr/bin/printf '\xC3\xA4')" || echo false

eof() {
    printf 'test'
    echo $'\004'
    printf "unreached"
}
read var <<-EOF
$(eof)
EOF
printf %s "$var"
printf -- "\\n-------- %s --------" "END"
