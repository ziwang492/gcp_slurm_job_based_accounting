# gcp_slurm_job_based_accounting


Go to project_runbook/ then run terraform init / plan and apply

After applying, update ```projects/customer-sample/locations/us/connections/slurm-accounting-instance``` to your federated location

```
SELECT
  *
FROM
  EXTERNAL_QUERY("projects/customer-sample/locations/us/connections/slurm-accounting-instance",
    "SELECT * FROM slurm_accounting.edafarm_job_table")
```
