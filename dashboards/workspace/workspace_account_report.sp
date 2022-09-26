dashboard "workspace_account_report" {
  title         = "Account Report"
  documentation = file("./dashboards/workspace/docs/workspace_account_report.md")
  tags = merge(local.workspace_common_tags, {
    type     = "Report"
    category = "Summary"
  })

  # Analysis
  container {
    text {
      value = "List of accounts across workspaces. Click on the resource to nagivate to the respective Turbot Console."
    }

    card {
      sql   = query.workspace_account_count.sql
      width = 2
    }

    card {
      sql   = query.workspace_aws_count.sql
      width = 2
    }

    card {
      sql   = query.workspace_azure_count.sql
      width = 2
    }

    card {
      sql   = query.workspace_gcp_count.sql
      width = 2
    }

    table {
      column "id" {
        display = "none"
      }

      column "workspace" {
        display = "none"
      }

      column "Account ID" {
        href = <<EOT
{{ .'workspace' }}/apollo/resources/{{.'id' | @uri}}/detail
        EOT
      }
      sql = query.workspace_account_detail.sql

    }
  }
}

query "workspace_aws_count" {
  sql = <<-EOQ
    select
      count(resource_type_uri) as "AWS"
    from
      turbot_resource
    where
      resource_type_uri = 'tmod:@turbot/aws#/resource/types/account'
  EOQ
}

query "workspace_azure_count" {
  sql = <<-EOQ
    select
      count(resource_type_uri) as "Azure"
    from
      turbot_resource
    where
      resource_type_uri = 'tmod:@turbot/azure#/resource/types/subscription'
  EOQ
}

query "workspace_gcp_count" {
  sql = <<-EOQ
    select
      count(resource_type_uri) as "GCP"
    from
      turbot_resource
    where
      resource_type_uri = 'tmod:@turbot/gcp#/resource/types/project'
  EOQ
}

query "workspace_account_detail" {
  sql = <<-EOQ
    select
      id,
      workspace,
      case
        when resource_type_uri = 'tmod:@turbot/aws#/resource/types/account' then data ->> 'Id'
        when resource_type_uri = 'tmod:@turbot/azure#/resource/types/subscription' then data ->> 'subscriptionId'
        when resource_type_uri = 'tmod:@turbot/gcp#/resource/types/project' then data ->> 'projectId'
      end as "Account ID",
      trunk_title as "Trunk Title",
      _ctx ->> 'connection_name' as "Connection Name"
    from
      turbot_resource
    where
      resource_type_uri in (
        'tmod:@turbot/aws#/resource/types/account',
        'tmod:@turbot/azure#/resource/types/subscription',
        'tmod:@turbot/gcp#/resource/types/project'
      )
    order by
      workspace,
      trunk_title;
  EOQ
}
