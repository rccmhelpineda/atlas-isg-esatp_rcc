data "aws_iam_role" "glue" {
  name = var.glue_role_name
}

resource "aws_glue_catalog_database" "db" {
  for_each = { for db in var.glue_database : db.name => db }
  name     = each.value.name
}

resource "aws_glue_connection" "conn" {
  for_each = { for c in var.glue_connections : c.name => c }

  name            = each.value.name
  description     = try(each.value.description, null)
  connection_type = try(each.value.connection_type, "JDBC")

  connection_properties = try(each.value.connection_properties, {})

  dynamic "physical_connection_requirements" {
    for_each = try(each.value.physical_connection_requirements, [])
    content {
      availability_zone      = try(physical_connection_requirements.value.availability_zone, null)
      security_group_id_list = try(physical_connection_requirements.value.security_group_id_list, [])
      subnet_id              = try(physical_connection_requirements.value.subnet_id, null)
    }
  }
}

locals {
  # Naming logic to match what Step Functions and orchestrator scripts expect:
  job_name_mapping = {
    "sap_2_s3"  = "isg-esatp-dv-sap_2_s3-glue"
    "s3_to_pg"  = "isg-esatp-dv-s3_to_pg"
    "extract_8" = "isg-esatp-dv-bss_eom_glob_preload_extract-glue_Unconfirmed_Advanced_MSF_Charges"
    "extract_9" = "isg-esatp-dv-bss_eom_glob_preload_extract-glue_DP5_Unconfirmed_Advance_MSF_header"
  }
}

resource "aws_glue_job" "job" {
  for_each = { for j in var.glue_jobs : j.name => j }

  name = lookup(
    local.job_name_mapping,
    each.value.name,
    "isg-esatp-dv-${var.name}-gljo-${each.value.name}"
  )

  description       = try(each.value.description, null)
  role_arn          = data.aws_iam_role.glue.arn
  glue_version      = try(each.value.glue_version, "5.0") == "5.1" ? "5.0" : try(each.value.glue_version, "5.0")
  worker_type       = try(each.value.worker_type, "G.1X")
  number_of_workers = try(each.value.number_of_workers, 2)
  execution_class   = try(each.value.execution_class, "STANDARD")
  connections       = try(each.value.connections, [])

  dynamic "command" {
    for_each = try(each.value.glue_job_command, [])
    content {
      name            = try(command.value.name, "glueetl")
      script_location = command.value.script_location
      python_version  = try(command.value.python_version, "3")
    }
  }

  default_arguments = try(each.value.default_arguments, {})

  dynamic "execution_property" {
    for_each = try([each.value.execution_property], [])
    content {
      max_concurrent_runs = try(execution_property.value.max_concurrent_runs, 1)
    }
  }

  tags = try(each.value.tags, {})
}
