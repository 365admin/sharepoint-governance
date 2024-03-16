package magicapp

import (
	"github.com/spf13/cobra"

	"github.com/365admin/sharepoint-governance/cmds"
	"github.com/365admin/sharepoint-governance/utils"
)

func RegisterCmds() {
	RootCmd.PersistentFlags().StringVarP(&utils.Output, "output", "o", "", "Output format (json, yaml, xml, etc.)")

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
	pageCmd := &cobra.Command{
		Use:   "page",
		Short: "SharePoint Pages",
		Long:  `Describe the main purpose of this kitchen`,
	}
	PageInfoPostCmd := &cobra.Command{
		Use:   "info  url",
		Short: "Page Info",
		Long:  `Get information about a SharePoint page and the site it is located on`,
		Args:  cobra.MinimumNArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()

			cmds.PageInfoPost(ctx, args)
		},
	}
	pageCmd.AddCommand(PageInfoPostCmd)

	RootCmd.AddCommand(pageCmd)
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
}
