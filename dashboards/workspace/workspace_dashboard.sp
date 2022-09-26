dashboard "workspace_dashboard" {
  title         = "Workspace Dashboard"
  documentation = file("./dashboards/workspace/docs/workspace_dashboard.md")
  tags = merge(local.workspace_common_tags, {
    type     = "Dashboard"
    category = "Summary"
  })

  # Analysis
  container {
    title = "Workspace Statistics"

    card {
      sql   = query.workspace_count.sql
      width = 2
      href  = dashboard.workspace_report.url_path
    }

    card {
      sql   = query.workspace_account_count.sql
      width = 2
      href  = dashboard.workspace_account_report.url_path
    }

    # card {
    #   sql   = query.workspace_resource_count.sql
    #   width = 2
    # }

  }

  # Analysis
  container {
    title = "Account Statistics"

    chart {
      type  = "donut"
      title = "Accounts by Provider"
      width = 4

      sql = <<-EOQ
        select
        case
          when resource_type_uri = 'tmod:@turbot/aws#/resource/types/account' then 'AWS'
          when resource_type_uri = 'tmod:@turbot/azure#/resource/types/subscription' then 'Azure'
          when resource_type_uri = 'tmod:@turbot/gcp#/resource/types/project' then 'GCP'
        end as "Account Type",
        count(resource_type_uri)
        from
        turbot_resource
        where
        resource_type_uri in (
        'tmod:@turbot/aws#/resource/types/account',
        'tmod:@turbot/azure#/resource/types/subscription',
        'tmod:@turbot/gcp#/resource/types/project'
        )
        group by
        resource_type_uri
      EOQ
    }

    chart {
      title = "Accounts by Workspace"
      type  = "column"
      width = 8

      legend {
        display  = "auto"
        position = "top"
      }

      axes {
        x {
          title {
            value = "Workspace"
          }
          labels {
            display = "auto"
          }
        }
        y {
          title {
            value = "Total Accounts"
          }
          labels {
            display = "auto"
          }
          # min = 50
          # max = 100
        }
      }

      sql = <<-EOQ
        select
        _ctx ->> 'connection_name' as "Connection Name",
        case
          when resource_type_uri = 'tmod:@turbot/aws#/resource/types/account' then 'AWS'
          when resource_type_uri = 'tmod:@turbot/azure#/resource/types/subscription' then 'Azure'
          when resource_type_uri = 'tmod:@turbot/gcp#/resource/types/project' then 'GCP'
        end as "Account Type",
        count(resource_type_uri)
        from
        turbot_resource
        where
        resource_type_uri in (
        'tmod:@turbot/aws#/resource/types/account',
        'tmod:@turbot/azure#/resource/types/subscription',
        'tmod:@turbot/gcp#/resource/types/project'
        )
        group by
        _ctx,resource_type_uri
        order by count(resource_type_uri) desc
      EOQ
    }
  }
}

query "workspace_count" {
  sql = <<-EOQ
    select
      count(workspace) as "Workspaces"
    from
      turbot_resource
    where
      resource_type_uri = 'tmod:@turbot/turbot#/resource/types/turbot';
  EOQ
}

query "workspace_account_count" {
  sql = <<-EOQ
    select
      count(id) as "Accounts"
    from
      turbot_resource
    where
      resource_type_uri in (
        'tmod:@turbot/aws#/resource/types/account',
        'tmod:@turbot/azure#/resource/types/subscription',
        'tmod:@turbot/gcp#/resource/types/project'
      );
  EOQ
}

# query "workspace_resource_count" {
#   sql = <<-EOQ
#     select
#       count(id) as "Resources"
#     from
#       turbot_resource
#     where 
#       filter = 'resourceTypeId:tmod:@turbot/aws#/resource/types/aws,tmod:@turbot/azure#/resource/types/azure,tmod:@turbot/gcp#/resource/types/gcp,tmod:@turbot/kubernetes#/resource/types/kubernetes,tmod:@turbot/turbot#/resource/types/folder,tmod:@turbot/turbot#/resource/types/file,tmod:@turbot/turbot#/resource/types/smartFolder'
#   EOQ
# }
