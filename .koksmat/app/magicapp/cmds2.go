package magicapp

import (
	"os"

	"github.com/spf13/cobra"

	"github.com/365admin/sharepoint-governance/cmds"
)

func RegisterCmds() {
	magicCmd := &cobra.Command{
		Use:   "magic",
		Short: "Magic Buttons",
		Long:  `Describe the main purpose of this kitchen`,
	}

	RootCmd.AddCommand(magicCmd)
	setupCmd := &cobra.Command{
		Use:   "setup",
		Short: "Setup",
		Long:  `Describe the main purpose of this kitchen`,
	}

	RootCmd.AddCommand(setupCmd)
	tasksCmd := &cobra.Command{
		Use:   "tasks",
		Short: "Tasks",
		Long:  `Describe the main purpose of this kitchen`,
	}

	RootCmd.AddCommand(tasksCmd)
	sharepointCmd := &cobra.Command{
		Use:   "sharepoint",
		Short: "SharePoint",
		Long:  `Describe the main purpose of this kitchen`,
	}
	SharepointPageinfoPostCmd := &cobra.Command{
		Use:   "pageinfo",
		Short: "Page Info",
		Long:  ``,
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()
			body, err := os.ReadFile(args[0])
			if err != nil {
				panic(err)
			}

			cmds.SharepointPageinfoPost(ctx, body, args)
		},
	}
	sharepointCmd.AddCommand(SharepointPageinfoPostCmd)

	RootCmd.AddCommand(sharepointCmd)
	buildCmd := &cobra.Command{
		Use:   "build",
		Short: "Build",
		Long:  `Describe the main purpose of this kitchen`,
	}

	RootCmd.AddCommand(buildCmd)
	provisionCmd := &cobra.Command{
		Use:   "provision",
		Short: "Provision",
		Long:  `Describe the main purpose of this kitchen`,
	}

	RootCmd.AddCommand(provisionCmd)
	decommissionCmd := &cobra.Command{
		Use:   "decommission",
		Short: "Decommision",
		Long:  `Describe the main purpose of this kitchen`,
	}

	RootCmd.AddCommand(decommissionCmd)
}
