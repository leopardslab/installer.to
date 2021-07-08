package main

import (
	"fmt"
	"os"
	"os/exec"
	"runtime"
)

func execute() {

	//arrCommandStr := strings.Fields(cmdString)
	//tool := arrCommandStr[0]

	task := fmt.Sprint("curl https://installer.to/", os.Args[1], " | bash")
	//task := "ls"

	cmd := exec.Command("bash", "-c", task)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
}

func main() {
	if runtime.GOOS == "windows" {
		fmt.Println("Can't Execute this on a windows machine")
	} else {
		execute()
	}
}
