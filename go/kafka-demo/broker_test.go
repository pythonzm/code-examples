package main

import (
	"fmt"
	"testing"

	"kafka_demo/common"
)

func TestNewAsyncProducer(t *testing.T) {
	cli := common.NewAsyncProducer()
	fmt.Println(cli)
}
