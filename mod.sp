mod "turbot_insights" {
  # hub metadata
  title       = "Turbot Insights"
  description = "Create dashboards and reports for your Turbot resources using Steampipe."
  color       = "#FF9900"
  # documentation = file("./docs/index.md")
  # icon          = "/images/mod/turbot/aws-insights.svg"
  # categories    = ["aws", "dashboard", "public cloud"]

  opengraph {
    title       = "Steampipe Mod for Turbot Insights"
    description = "Create dashboards and reports for your Turbot resources using Steampipe."
    # image       = "/images/mod/turbot/aws-insights-social-graphic.png"
  }

  require {
    steampipe = "0.16.2"
    plugin "turbot" {
      version = "0.9.0"
    }
  }
}
