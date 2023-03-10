# Directory Structure
## This implements a brand new environment  Infrastructure

 * Implements a brand new infrastructure infrastructure: GCP (buckets, cluster, databases etc.)
 * terraform state is stored in the app.terraform.io backend separately for the env
     * See the `env` workspaces
 * terraform code is stored in the `infrastructure` directory separately for the env
     * See the `env` directory
 * common (env) - most definitions are handled by terraform modules, to allow the test, staging env to closely match to production

* we have split modules into sub directories eg GCP resources are in (gcp-compute directory) we have iam under (iam ) and so on 
