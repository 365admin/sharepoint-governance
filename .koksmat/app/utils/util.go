package utils

import (
	"os"
	"path"
)

var Output string = ""

func WorkDir(kitchenname string) string {
	if os.Getenv("WORKDIR") != "" {
		return os.Getenv("WORKDIR")
	}
	return path.Join(os.Getenv("KITCHENROOT"), kitchenname, ".koksmat", "workdir")
}
