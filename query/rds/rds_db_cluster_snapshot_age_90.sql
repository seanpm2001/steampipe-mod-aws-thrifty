select
  arn as resource,
  case
    when create_time > current_timestamp - ($1 || ' days')::interval then 'ok'
    else 'alarm'
  end as status,
  db_cluster_snapshot_identifier || ' created on ' || create_time || '.' as reason,
  region,
  account_id
from
  aws_rds_db_cluster_snapshot;
