variable "cost_explorer_service_cost_max_cost_units" {
  type        = number
  description = "The maximum difference in cost units allowed for service costs between the current and previous month."
  default     = 10
}

locals {
  cost_variance_common_tags = merge(local.aws_thrifty_common_tags, {
    cost_variance = "true"
  })
}

benchmark "cost_variance" {
  title         = "Cost Variance"
  description   = "Thrifty developers keep an eye on the service usage and the accompanied cost variance over a period of time. They pay close attention to the cost spikes and check if per-service costs have changed more than allowed between this month and last month. By asking the right questions one can often justify the cost or prompt review and optimization."
  documentation = file("./thrifty/docs/cost_variance.md")
  children = [
    control.full_month_cost_changes
  ]

  tags = merge(local.cost_variance_common_tags, {
    type = "Benchmark"
  })
}

control "full_month_cost_changes" {
  title       = "What services have changed in cost over last two months?"
  description = "Compares the cost of services between the last two full months of AWS usage."
  sql         = query.monthly_service_cost_changes.sql
  severity    = "low"

  param "cost_explorer_service_cost_max_cost_units" {
    description = "The maximum difference in cost units allowed for service costs between the current and previous month."
    default     = var.cost_explorer_service_cost_max_cost_units
  }

  tags = merge(local.cost_variance_common_tags, {
    service = "AWS/CostExplorer"
  })
}

