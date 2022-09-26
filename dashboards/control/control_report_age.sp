dashboard "turbot_control_report_age" {
  title = "Controls Age Report"
  documentation = file("./dashboards/control/docs/control_report_age.md")
  tags = merge(local.control_common_tags, {
    type     = "Report"
    category = "Control"
  })

  input "control_state" {
    title = "Select a control state:"
    width = 2
    option "alarm" {
      label = "Alarm"
    }
    option "error" {
      label = "Error"
    }
    option "invalid" {
      label = "Invalid"
    }
  }

  container {

    card {
      query   = query.turbot_control_state_count
      width = 2
      type = "alert"
      label = "Count"
      args  = {
        control_state = self.input.control_state.value
      }
    }

    card {
      query   = query.turbot_control_state_24_hours_count
      width = 2
      type = "info"
      label = "< 24 hours"
      args  = {
        control_state = self.input.control_state.value
      }
    }

    card {
      query   = query.turbot_control_state_between_1_30_days
      width = 2
      type = "info"
      label = "1-30 Days"
      args  = {
        control_state = self.input.control_state.value
      }
    }

    card {
      query   = query.turbot_control_state_between_30_90_days
      width = 2
      type = "info"
      label = "30-90 Days"
      args  = {
        control_state = self.input.control_state.value
      }
    }
    
    card {
      query   = query.turbot_control_state_between_90_365_days
      width = 2
      type = "info"
      label = "90-365 Days"
      args  = {
        control_state = self.input.control_state.value
      }
    }

    card {
      query   = query.turbot_control_state_after_1_year
      width = 2
      type = "info"
      label = "> 1 Year"
      args  = {
        control_state = self.input.control_state.value
      }
    }

    table {
      title = "Controls"
      query = query.turbot_control_state_oldest
      args  = {
        control_state = self.input.control_state.value
      }

      column id {
        display = "none"
      }
      column workspace {
        display = "none"
      }

      column "Control Title" {
        href = <<-EOT
          {{ ."workspace" }}/apollo/controls/{{."id" | @uri}}
        EOT
      }
    }

  }
}


query "turbot_control_state_count" {
  param "control_state" {}
  sql = <<-EOQ
    select 
      count(*) as value,
      'Count' as label
    from 
      turbot_control 
    where state=$1;
  EOQ
}

query "turbot_control_state_24_hours_count" {
  param "control_state" {}
  sql = <<-EOQ
    with less_than_24_hours_state_changed as (
      select
        now()::date - update_timestamp::date as days
      from 
        turbot_control
      where 
        update_timestamp > now() - '1 days' :: interval and state=$1
    )
    select
      count(*) as value,
      '< 24 hours' as label
    from 
      less_than_24_hours_state_changed;
  EOQ
}

query "turbot_control_state_between_1_30_days" {
  param "control_state" {}
  sql = <<-EOQ
    with btweeen_1_30_days as (
      select
        now()::date - update_timestamp::date as days
      from 
        turbot_control
      where 
        update_timestamp between symmetric now() - '1 days' :: interval and now() - '30 days' :: interval and state=$1
    )
    select
      count(*) as value,
      '1-30 Days' as label
    from 
      btweeen_1_30_days;
  EOQ
}

query "turbot_control_state_between_30_90_days" {
  param "control_state" {}
  sql = <<-EOQ
    with btweeen_30_90_days as (
      select
        now()::date - update_timestamp::date as days
      from 
        turbot_control
      where 
        update_timestamp between symmetric now() - '30 days' :: interval and now() - '90 days' :: interval and state=$1
    )
    select
      count(*) as value,
      '30-90 Days' as label
    from 
      btweeen_30_90_days;
  EOQ
}

query "turbot_control_state_between_90_365_days" {
  param "control_state" {}
  sql = <<-EOQ
    with btweeen_90_365_days as (
      select
        now()::date - update_timestamp::date as days
      from 
        turbot_control
      where 
        update_timestamp between symmetric (now() - '90 days'::interval) and (now() - '365 days'::interval) and state=$1
    )
    select
      count(*) as value,
      '90-365 Days' as label
    from 
      btweeen_90_365_days;
  EOQ
}

query "turbot_control_state_after_1_year" {
  param "control_state" {}
  sql = <<-EOQ
    with after_1_year as (
      select
        now()::date - update_timestamp::date as days
      from 
        turbot_control
      where 
        update_timestamp <= now() - '1 year' :: interval and state=$1
    )
    select
      count(*) as value,
      '> 1 Year' as label
    from 
      after_1_year;
  EOQ
}

query "turbot_control_state_oldest" {
  param "control_state" {}
  sql = <<-EOQ
    select
      id,
      workspace,
      now()::date - update_timestamp::date as "Age in Days",
      control_type_trunk_title as "Control Title",
      resource_trunk_title as "Resource Title"
    from 
      turbot_control
    where 
      state=$1
    order by
      "Age in Days" desc;
  EOQ
}