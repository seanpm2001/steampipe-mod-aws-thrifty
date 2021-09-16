locals {
  cloudtrail_common_tags = merge(local.thrifty_common_tags, {
    service = "cloudtrail"
  })
}

benchmark "cloudtrail" {
  title         = "CloudTrail Checks"
  description   = "Thrifty developers know that multiple active CloudTrail Trails can add significant costs. Be thrifty and eliminate the extra trails. One trail to rule them all."
  documentation = file("./controls/docs/cloudtrail.md")
  tags          = local.cloudtrail_common_tags
  children = [
    control.cloudtrail_trail_global_multiple,
    control.cloudtrail_trail_regional_multiple
  ]
}

control "cloudtrail_trail_global_multiple" {
  title = "Are there redundant global CloudTrail trails?"
  description   = "Your first cloudtrail in each account is free, additional trails are expensive."
  sql           = query.cloudtrail_trail_global_multiple.sql
  severity      = "low"
  tags = merge(local.cloudtrail_common_tags, {
    class = "managed"
  })
}

control "cloudtrail_trail_regional_multiple" {
  title         = "Are there redundant regional CloudTrail trails?"
  description   = "Your first cloudtrail in each region is free, additional trails are expensive."
  sql           = query.cloudtrail_trail_regional_multiple.sql
  severity      = "low"
  tags = merge(local.cloudtrail_common_tags, {
    class = "managed"
  })
}
