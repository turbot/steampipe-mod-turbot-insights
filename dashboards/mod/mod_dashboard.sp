dashboard "mod_dashboard" {
  title         = "Mods Dashboard"
  documentation = file("./dashboards/mod/docs/mod_dashboard.md")
  tags          = merge(local.mod_common_tags, {
    type     = "Dashboard"
    category = "Summary"
  })

  container {
    title = "Mods Summary"
    #    card {
    #      sql   = query.installed_mods_count.sql
    #      width = 2
    #      href  = dashboard.mod_installed_mods_report.url_path
    #    }
    #    card {
    #      sql   = query.mod_auto_update.sql
    #      width = 2
    #      href  = dashboard.mod_auto_update_dashboard.url_path
    #    }
    card {
      width = 2
      sql   = query.mod_installed_controls_error.sql
      type  = "alert"
      href  = dashboard.mod_mod_installed_errors_report.url_path
    }
    card {
      width = 2
      sql   = query.type_installed_controls_error.sql
      type  = "alert"
      href  = dashboard.mod_type_installed_errors_report.url_path
    }

    container {
      chart {
        type  = "donut"
        sql   = query.installed_mods_by_platform.sql
        title = "Mods by Cloud Platform"
        width = 4
      }
      chart {
        title = "Mods by Workspace"
        type  = "bar"
        width = 8

        legend {
          display  = "auto"
          position = "top"
        }

        axes {
          x {
            title {
              value = "Mods"
            }
            labels {
              display = "auto"
            }
          }
          y {
            title {
              value = "Workspace"
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
          when title like '@turbot/aws%' then 'AWS'
          when title like '@turbot/azure%' then 'Azure'
          when title like '@turbot/gcp%' then 'GCP'
          when title like '@turbot/turbot%' then 'Turbot'
        end as "Mod Platform",
        count(title)
        from
        turbot_resource
        where
        resource_type_uri =  'tmod:@turbot/turbot#/resource/types/mod'
        group by
        "Connection Name",title
        order by count(title) desc
      EOQ
      }

    }
    #    card {
    #      sql   = query.installed_aws_mods_count.sql
    #      width = 2
    #      href  = dashboard.mod_installed_mods_report.url_path
    #    }
    #    card {
    #      sql   = query.installed_azure_mods_count.sql
    #      width = 2
    #      href  = dashboard.mod_installed_mods_report.url_path
    #    }
    #    card {
    #      sql   = query.installed_gcp_mods_count.sql
    #      width = 2
    #      href  = dashboard.mod_installed_mods_report.url_path
    #    }

  }


}

#query "installed_mods_count" {
#  title = "Count of Installed Mods"
#  sql   = <<EOQ
#  select count(*) as "Installed Mods"
#  from turbot_resource
#  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self';
#EOQ
#}

query "installed_mods_by_platform" {
  sql = <<EOQ
      select count(title) as "Installed Mods",
      case
      when title like '@turbot/aws%' then 'AWS'
      when title like '@turbot/azure%' then 'Azure'
      when title like '@turbot/gcp%' then 'GCP'
      when title like '@turbot/turbot%' then 'Turbot'
      end as "Mod Platform"
        from turbot_resource
        where resource_type_uri = 'tmod:@turbot/turbot#/resource/types/mod'
      group by "Mod Platform"
EOQ
}

query "installed_aws_mods_count" {
  title = "Count of Installed Mods"
  sql   = <<EOQ
  select count(*) as "AWS Installed Mods"
  from turbot_resource
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self'
  and substring(title from 9 for 3) like 'aws';
EOQ
}

query "installed_azure_mods_count" {
  title = "Count of Installed Mods"
  sql   = <<EOQ
  select count(*) as "Azure Installed Mods"
  from turbot_resource
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self'
  and substring(title from 9 for 5) like 'azure';
EOQ
}

query "installed_gcp_mods_count" {
  title = "Count of Installed Mods"
  sql   = <<EOQ
  select count(*) as "GCP Installed Mods"
  from turbot_resource
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self'
  and substring(title from 9 for 3) like 'gcp';
EOQ
}


query "mod_auto_update" {
  sql = <<EOQ
select count(*) as "Workspaces with Auto Update Enabled"
  from turbot_policy_setting
  where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modAutoUpdate" level:self'
EOQ
}
