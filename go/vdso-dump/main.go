package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"strconv"
	"strings"
)

func main() {
	var (
		output = flag.String("output", "", "the file to write vdso info")
		pid    = flag.Int("pid", 0, "the memory of which process id to read")
	)
	flag.Parse()

	if len(*output) == 0 {
		log.Fatal("please set output file")
	}

	outputFile, err := os.Create(*output)
	if err != nil {
		log.Fatal(err)
	}
	defer outputFile.Close()

	mapFile := "/proc/self/maps"
	memFile := "/proc/self/mem"
	if *pid > 0 {
		mapFile = fmt.Sprintf("/proc/%d/maps", *pid)
		memFile = fmt.Sprintf("/proc/%d/mem", *pid)
	}

	mapFileH, err := os.Open(mapFile)
	if err != nil {
		log.Fatal(err)
	}

	bufReader := bufio.NewReader(mapFileH)
	var vdsoSectionLine string
	for {
		line, err := bufReader.ReadString('\n')
		if err != nil {
			if err == io.EOF {
				break
			}
			log.Fatal(err)
		}
		line = strings.Trim(line, "\n")
		if strings.HasSuffix(line, "[vdso]") {
			vdsoSectionLine = line
			break
		}
	}
	if len(vdsoSectionLine) == 0 {
		log.Fatal("can't find vdso module")
	}

	addrs := strings.Split(strings.SplitN(vdsoSectionLine, " ", 2)[0], "-")
	vdsoStartAddr, _ := strconv.ParseInt(addrs[0], 16, 64)
	vdsoEndAddr, _ := strconv.ParseInt(addrs[1], 16, 64)

	memFileH, err := os.Open(memFile)
	if err != nil {
		log.Fatal(err)
	}

	if _, err = memFileH.Seek(vdsoStartAddr, 0); err != nil {
		log.Fatal(err)
	}

	buf := make([]byte, vdsoEndAddr-vdsoStartAddr)
	if _, err = io.ReadFull(memFileH, buf); err != nil {
		log.Fatal(err)
	}

	if _, err = outputFile.Write(buf); err != nil {
		log.Fatal(err)
	}
}
