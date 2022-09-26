dashboard "mod_type_installed_errors_report" {
  title = "Type Installed Errors Report"
  tags  = merge(local.mod_common_tags, {
    type     = "Report"
    category = "Installation Errors"
  })
  container {
    text {
      value = "These types have some problem that prevents them from installing or updating properly. These should be resolved as soon as possible."
    }
    card {
      title = "Number of Type Installed Errors"
      sql   = query.type_installed_controls_error.sql
      width = "2"
    }
  }
  container {
    table {
      title = "Types in Error"
      query = query.type_installed_controls_error_list
      column "Type Installed Name" {
        href = <<EOT
{{ ."Workspace URL" }}/apollo/controls/{{.'control_id' | @uri}}
        EOT
      }
      column "control_id" {
        display = "none"
      }
      column "Workspace URL" {
        display = "none"
      }
      column "resource_id" {
        display = "none"
      }
    }
  }
}

query "type_installed_controls_error" {
  title = "Mod Installed Control Errors"
  sql   = <<EOQ
select count(*) as "Type Installed Errors"
from turbot_control
where  filter = 'state:error controlTypeId:"tmod:@turbot/turbot#/control/types/controlInstalled" level:self';
EOQ
}

query "type_installed_controls_error_list" {
  title = "Type Installed Control Errors List"
  sql   = <<EOQ
with controls_list as (select id                      as control_id,
                              state                   as control_state,
                              reason                  as control_reason,
                              details #>> '{0,value}' as control_details,
                              resource_id             as resource_id,
                              substring(workspace from 'https://([a-z]+)(.)') as "Workspace",
                              workspace               as "Workspace URL"
                       from turbot_control
                       where state like 'error'
                         and filter =
                             'controlTypeId:"tmod:@turbot/turbot#/control/types/controlInstalled" level:self'),
     mods_resources as (select substr(title, 9) as type_name,
                               title            as type_title,
                               id               as resource_id
                        from turbot_resource
                        where filter =
                              'resourceTypeId:"tmod:@turbot/turbot#/resource/types/actionType","tmod:@turbot/turbot#/resource/types/policyType","tmod:@turbot/turbot#/resource/types/resourceType","tmod:@turbot/turbot#/resource/types/controlType" level:self')
select mr.type_name as "Type Name",
       con.control_id,
       con.control_reason as "Reason",
       con.control_details as "Detail",
       mr.resource_id,
       con."Workspace",
       con."Workspace URL"
from controls_list con
         left join mods_resources mr on con.resource_id = mr.resource_id;
EOQ
}