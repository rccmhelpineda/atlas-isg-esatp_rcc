data "aws_iam_role" "glue" {
  name = var.glue_role_name
}

resource "aws_glue_catalog_database" "db" {
  for_each = { for db in var.glue_database : db.name => db }
  name     = each.value.name
}

locals {
  # HMD-parity names: {env_prefix}-{component}-glco-{short}
  glue_conn_name = {
    for c in var.glue_connections : c.name => "${var.env_prefix}-${var.name}-glco-${c.name}"
  }

  # Keep default job names identical to client HMD: {env_prefix}-{component}-gljo-{job}
  job_name_mapping = {}
}

resource "aws_glue_connection" "conn" {
  for_each = { for c in var.glue_connections : c.name => c }

  name            = local.glue_conn_name[each.key]
  description     = try(each.value.description, null)
  connection_type = try(each.value.connection_type, "JDBC")

  # Client glue_*.tf only set JDBC_CONNECTION_URL. HMD injects SECRET_ID here.
  # Create-time InvalidInputException if JDBC URL is present without SECRET_ID or USERNAME+PASSWORD.
  connection_properties = merge(
    try(each.value.connection_properties, {}),
    var.source_secrets_manager_arn != null && var.source_secrets_manager_arn != "" ? {
      SECRET_ID = var.source_secrets_manager_arn
    } : {}
  )

  dynamic "physical_connection_requirements" {
    for_each = try(each.value.physical_connection_requirements, [])
    content {
      availability_zone      = try(physical_connection_requirements.value.availability_zone, null)
      security_group_id_list = try(physical_connection_requirements.value.security_group_id_list, [])
      subnet_id              = try(physical_connection_requirements.value.subnet_id, null)
    }
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
  connections = [
    for c in try(each.value.connections, []) : lookup(local.glue_conn_name, c, c)
  ]

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
