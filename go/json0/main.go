package main

import (
	"fmt"
	json "github.com/tidwall/gjson"
	lib "github.com/tongson/gl"
	"os"
)

const cCURSOR = "/var/run/json0.cursor"

func main() {
	var journalctl = lib.RunArgs{
		Exe: "/usr/bin/journalctl",
		Args: []string{
			"--output=json-seq",
			fmt.Sprintf("--cursor-file=%s", cCURSOR),
		},
	}
	if ret, stdout, stderr, goerr := journalctl.Run(); !ret {
		fmt.Fprintf(os.Stderr, "stdout: %s\nstderr: %s\nerror: %s\n", stdout, stderr, goerr)
		os.Exit(1)
	} else {
		json.ForEachLine(stdout, func(line json.Result) bool {
			id := json.Get(line.String(), "SYSLOG_IDENTIFIER")
			if id.String() == "sudo" {
				message := json.Get(line.String(), "MESSAGE")
				fmt.Println(message)
			}
			return true
		})
	}
}
