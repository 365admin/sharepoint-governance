// -------------------------------------------------------------------
// Generated by 365admin-publish
// -------------------------------------------------------------------
/*
---
title: App deploy to production
---
*/
package cmds

import (
	"context"

	"github.com/365admin/sharepoint-governance/execution"
	"github.com/365admin/sharepoint-governance/utils"
)

func ProvisionAppdeployproductionPost(ctx context.Context, args []string) (*string, error) {

	result, pwsherr := execution.ExecutePowerShell("john", "*", "sharepoint-governance", "60-provision", "10-app-service.ps1", "")
	if pwsherr != nil {
		return nil, pwsherr
	}
	utils.PrintSkip2FirstAnd2LastLines(string(result))
	return nil, nil

}
