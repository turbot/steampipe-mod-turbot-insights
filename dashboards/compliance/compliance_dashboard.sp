dashboard "compliance_dashboard" {

  title         = "Compliance Dashboard"
  documentation = file("./dashboards/compliance/docs/compliance_dashboard.md")

  tags = merge(local.workspace_common_tags, {
    type     = "Dashboard"
    category = "Summary"
  })

  container {
    title = "Alerts by Section"

    chart {
      type  = "donut"
      title = "AWS CIS v1.4"
      width = 4

      sql = <<-EOQ
        select
          case
          when control_type_uri like 'tmod:@turbot/aws-cisv1-4#/control/types/r01%' then 'Section 1'
          when control_type_uri like 'tmod:@turbot/aws-cisv1-4#/control/types/r02%' then 'Section 2'
          when control_type_uri like 'tmod:@turbot/aws-cisv1-4#/control/types/r03%' then 'Section 3'
          when control_type_uri like 'tmod:@turbot/aws-cisv1-4#/control/types/r04%' then 'Section 4'
          when control_type_uri like 'tmod:@turbot/aws-cisv1-4#/control/types/r05%' then 'Section 5'
          end as section,
          sum(case when state in ('alarm', 'error', 'invalid') then 1 else 0 end) as alert
        from
          turbot_control as c
        where
          control_type_uri like 'tmod:@turbot/aws-cisv1-4#/%' and state in ('alarm', 'error', 'invalid') 
        group by
          section
  EOQ
    }

    chart {
      type  = "donut"
      title = "Azure CIS v1.0"
      width = 4

      sql = <<-EOQ
        select
          case
          when control_type_uri like 'tmod:@turbot/azure-cisv1#/control/types/r01%' then 'Section 1'
          when control_type_uri like 'tmod:@turbot/azure-cisv1#/control/types/r02%' then 'Section 2'
          when control_type_uri like 'tmod:@turbot/azure-cisv1#/control/types/r03%' then 'Section 3'
          when control_type_uri like 'tmod:@turbot/azure-cisv1#/control/types/r04%' then 'Section 4'
          when control_type_uri like 'tmod:@turbot/azure-cisv1#/control/types/r05%' then 'Section 5'
          when control_type_uri like 'tmod:@turbot/azure-cisv1#/control/types/r06%' then 'Section 6'
          when control_type_uri like 'tmod:@turbot/azure-cisv1#/control/types/r07%' then 'Section 7'
          when control_type_uri like 'tmod:@turbot/azure-cisv1#/control/types/r08%' then 'Section 8'
          when control_type_uri like 'tmod:@turbot/azure-cisv1#/control/types/r09%' then 'Section 9'
          end as section,
          sum(case when state in ('alarm', 'error', 'invalid') then 1 else 0 end) as alert
        from
          turbot_control as c
        where
          control_type_uri like 'tmod:@turbot/azure-cisv1#/%' and state in ('alarm', 'error', 'invalid') 
        group by
          section
  EOQ
    }

    chart {
      type  = "donut"
      title = "GCP CIS v1.0"
      width = 4

      sql = <<-EOQ
        select
          case
          when control_type_uri like 'tmod:@turbot/gcp-cisv1#/control/types/r01%' then 'Section 1'
          when control_type_uri like 'tmod:@turbot/gcp-cisv1#/control/types/r02%' then 'Section 2'
          when control_type_uri like 'tmod:@turbot/gcp-cisv1#/control/types/r03%' then 'Section 3'
          when control_type_uri like 'tmod:@turbot/gcp-cisv1#/control/types/r04%' then 'Section 4'
          when control_type_uri like 'tmod:@turbot/gcp-cisv1#/control/types/r05%' then 'Section 5'
          when control_type_uri like 'tmod:@turbot/gcp-cisv1#/control/types/r06%' then 'Section 6'
          when control_type_uri like 'tmod:@turbot/gcp-cisv1#/control/types/r07%' then 'Section 7'
          end as section,
          sum(case when state in ('alarm', 'error', 'invalid') then 1 else 0 end) as alert
        from
          turbot_control as c
        where
          control_type_uri like 'tmod:@turbot/gcp-cisv1#/%' and state in ('alarm', 'error', 'invalid') 
        group by
          section
    EOQ
    }

  }

  container {
    title = "Alerts by Service"

    chart {
      type  = "donut"
      title = "AWS HIPAA"
      width = 4

      sql = <<-EOQ
        select
          case
          when control_type_trunk_title like 'AWS > HIPAA > Account%' then 'Account'
          when control_type_trunk_title like 'AWS > HIPAA > ACM%' then 'ACM'
          when control_type_trunk_title like 'AWS > HIPAA > API Gateway%' then 'API Gateway'
          when control_type_trunk_title like 'AWS > HIPAA > Backup%' then 'Backup'
          when control_type_trunk_title like 'AWS > HIPAA > CloudFront%' then 'CloudFront'
          when control_type_trunk_title like 'AWS > HIPAA > CloudTrail%' then 'CloudTrail'
          when control_type_trunk_title like 'AWS > HIPAA > CloudWatch%' then 'CloudWatch'
          when control_type_trunk_title like 'AWS > HIPAA > CodeBuild%' then 'CodeBuild'
          when control_type_trunk_title like 'AWS > HIPAA > DAX%' then 'DAX'
          when control_type_trunk_title like 'AWS > HIPAA > DMS%' then 'DMS'
          when control_type_trunk_title like 'AWS > HIPAA > DynamoDB%' then 'DynamoDB'
          when control_type_trunk_title like 'AWS > HIPAA > EC2%' then 'EC2'
          when control_type_trunk_title like 'AWS > HIPAA > EFS%' then 'EFS'
          when control_type_trunk_title like 'AWS > HIPAA > EKS%' then 'EKS'
          when control_type_trunk_title like 'AWS > HIPAA > ElastiCache%' then 'ElastiCache'
          when control_type_trunk_title like 'AWS > HIPAA > Elasticsearch%' then 'Elasticsearch'
          when control_type_trunk_title like 'AWS > HIPAA > EMR%' then 'EMR'
          when control_type_trunk_title like 'AWS > HIPAA > FSx%' then 'FSx'
          when control_type_trunk_title like 'AWS > HIPAA > GuardDuty%' then 'GuardDuty'
          when control_type_trunk_title like 'AWS > HIPAA > IAM%' then 'IAM'
          when control_type_trunk_title like 'AWS > HIPAA > KMS%' then 'KMS'
          when control_type_trunk_title like 'AWS > HIPAA > Lambda%' then 'Lambda'
          when control_type_trunk_title like 'AWS > HIPAA > Logs%' then 'Logs'
          when control_type_trunk_title like 'AWS > HIPAA > RDS%' then 'RDS'
          when control_type_trunk_title like 'AWS > HIPAA > Redshift%' then 'Redshift'
          when control_type_trunk_title like 'AWS > HIPAA > Region%' then 'Region'
          when control_type_trunk_title like 'AWS > HIPAA > S3%' then 'S3'
          when control_type_trunk_title like 'AWS > HIPAA > SageMaker%' then 'SageMaker'
          when control_type_trunk_title like 'AWS > HIPAA > Secrets%' then 'Secrets Manager'
          when control_type_trunk_title like 'AWS > HIPAA > SNS%' then 'SNS'
          when control_type_trunk_title like 'AWS > HIPAA > SSM%' then 'SSM'
          when control_type_trunk_title like 'AWS > HIPAA > VPC%' then 'VPC'
          when control_type_trunk_title like 'AWS > HIPAA > WAFV2%' then 'WAFV2'          
          end as service,
          sum(case when state in ('alarm', 'error', 'invalid') then 1 else 0 end) as alert
        from
          turbot_control as c
        where
          filter = 'controlCategoryId:"tmod:@turbot/turbot#/control/categories/complianceHipaa" state:alarm,invalid,error'
        group by
          service
  EOQ
    }

    chart {
      type  = "donut"
      title = "AWS NIST 800-53"
      width = 4

      sql = <<-EOQ
        select
          case
          when control_type_trunk_title like 'AWS > NIST 800-53 > Account%' then 'Account'
          when control_type_trunk_title like 'AWS > NIST 800-53 > ACM%' then 'ACM'
          when control_type_trunk_title like 'AWS > NIST 800-53 > API Gateway%' then 'API Gateway'
          when control_type_trunk_title like 'AWS > NIST 800-53 > CloudTrail%' then 'CloudTrail'
          when control_type_trunk_title like 'AWS > NIST 800-53 > CloudWatch%' then 'CloudWatch'
          when control_type_trunk_title like 'AWS > NIST 800-53 > CodeBuild%' then 'CodeBuild'
          when control_type_trunk_title like 'AWS > NIST 800-53 > DMS%' then 'DMS'
          when control_type_trunk_title like 'AWS > NIST 800-53 > DynamoDB%' then 'DynamoDB'
          when control_type_trunk_title like 'AWS > NIST 800-53 > EC2%' then 'EC2'
          when control_type_trunk_title like 'AWS > NIST 800-53 > ECS%' then 'ECS'
          when control_type_trunk_title like 'AWS > NIST 800-53 > EFS%' then 'EFS'
          when control_type_trunk_title like 'AWS > NIST 800-53 > ElastiCache%' then 'ElastiCache'
          when control_type_trunk_title like 'AWS > NIST 800-53 > Elasticsearch%' then 'Elasticsearch'
          when control_type_trunk_title like 'AWS > NIST 800-53 > EMR%' then 'EMR'
          when control_type_trunk_title like 'AWS > NIST 800-53 > GuardDuty%' then 'GuardDuty'
          when control_type_trunk_title like 'AWS > NIST 800-53 > IAM%' then 'IAM'
          when control_type_trunk_title like 'AWS > NIST 800-53 > KMS%' then 'KMS'
          when control_type_trunk_title like 'AWS > NIST 800-53 > Lambda%' then 'Lambda'
          when control_type_trunk_title like 'AWS > NIST 800-53 > Logs%' then 'Logs'
          when control_type_trunk_title like 'AWS > NIST 800-53 > RDS%' then 'RDS'
          when control_type_trunk_title like 'AWS > NIST 800-53 > Redshift%' then 'Redshift'
          when control_type_trunk_title like 'AWS > NIST 800-53 > Region%' then 'Region'
          when control_type_trunk_title like 'AWS > NIST 800-53 > S3%' then 'S3'
          when control_type_trunk_title like 'AWS > NIST 800-53 > SageMaker%' then 'SageMaker'
          when control_type_trunk_title like 'AWS > NIST 800-53 > Secrets%' then 'Secrets Manager'
          when control_type_trunk_title like 'AWS > NIST 800-53 > SNS%' then 'SNS'
          when control_type_trunk_title like 'AWS > NIST 800-53 > SSM%' then 'SSM'
          when control_type_trunk_title like 'AWS > NIST 800-53 > VPC%' then 'VPC'
          when control_type_trunk_title like 'AWS > NIST 800-53 > WAF%' then 'WAF'          
          end as service,
          sum(case when state in ('alarm', 'error', 'invalid') then 1 else 0 end) as alert
        from
          turbot_control as c
        where
          filter = 'controlCategoryId:"tmod:@turbot/turbot#/control/categories/complianceNist80053" state:alarm,invalid,error'
        group by
          service
  EOQ
    }

    chart {
      type  = "donut"
      title = "AWS PCI v3.2.1"
      width = 4

      sql = <<-EOQ
        select
          case
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > Auto Scaling%' then 'Auto Scaling'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > CloudTrail%' then 'CloudTrail'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > CloudWatch%' then 'CloudWatch'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > CodeBuild%' then 'CodeBuild'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > Config%' then 'Config'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > DMS%' then 'DMS'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > EC2%' then 'EC2'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > Elasticsearch%' then 'Elasticsearch'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > ELBV2%' then 'ELBV2'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > GuardDuty%' then 'GuardDuty'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > IAM%' then 'IAM'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > KMS%' then 'KMS'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > Lambda%' then 'Lambda'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > RDS%' then 'RDS'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > Redshift%' then 'Redshift'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > S3%' then 'S3'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > SageMaker%' then 'SageMaker'
          when control_type_trunk_title like 'AWS > PCI v3.2.1 > SSM%' then 'SSM'
          end as service,
          sum(case when state in ('alarm', 'error', 'invalid') then 1 else 0 end) as alert
        from
          turbot_control as c
        where
          filter = 'controlCategoryId:"tmod:@turbot/turbot#/control/categories/compliancePci" state:alarm,invalid,error'
        group by
          service
  EOQ
    }

  }
}
