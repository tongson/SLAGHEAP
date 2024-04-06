package main

import (
	"flag"
	"fmt"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/push"
	"os"
)

const cJOB = "testjob"
const cNAME = "TestName"
const cHELP = "TestHelp"

func prompgPush(url string) error {
	toggle := prometheus.NewGauge(prometheus.GaugeOpts{
		Name: cNAME,
		Help: cHELP,
	})
	toggle.Set(float64(1))
	return push.New(url, cJOB).
		Collector(toggle).
		Grouping("db", "customers").
		Push()
}

func main() {
	urlPtr := flag.String("url", "", "pushgateway URL")
	flag.Parse()
	if *urlPtr == "" {
                fmt.Fprintln(os.Stderr, "URL must be set")
		os.Exit(1)
	}
	if err := prompgPush(*urlPtr); err != nil {
		errStr := fmt.Errorf("Unable to push: %w", err)
		fmt.Fprintln(os.Stderr, errStr)
		os.Exit(1)
	}
}
