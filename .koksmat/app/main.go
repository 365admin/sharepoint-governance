package main

import (
	"runtime/debug"
	"strings"

	"github.com/365admin/sharepoint-governance/magicapp"
)

func main() {
	info, _ := debug.ReadBuildInfo()

	// split info.Main.Path by / and get the last element
	s1 := strings.Split(info.Main.Path, "/")
	name := s1[len(s1)-1]
	description := `---
title: sharepoint-governance
description: Describe the main purpose of this kitchen
---

# sharepoint-governance
`
	magicapp.Setup(".env")
	magicapp.RegisterServeCmd("sharepoint-governance", description, "0.0.1", 8080)
	magicapp.RegisterCmds()
	magicapp.RegisterServiceCmd()
	magicapp.Execute(name, "sharepoint-governance", "")
}
