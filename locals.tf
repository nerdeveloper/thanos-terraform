locals {
  project_name = "interview_test"
  tags = {
    managed-by = "terraform"
  }
  maps_users = [
    {
      userarn  = "arn:aws:iam::193420639370:user/L.agbani@hotmail.co.uk"
      username = "L.agbani@hotmail.co.uk"
      groups   = ["system:masters"]
    },

    ]
  worker_groups = [
    {
      instance_type = "t2.medium"
      # 2CPU, 2GO RAM
      asg_desired_capacity = "3"
      # Desired worker capacity in the autoscaling group.
      asg_max_size = "4"
      # Maximum worker capacity in the autoscaling group.
      asg_min_size = "3"
      # Minimum worker capacity in the autoscaling group.
      autoscaling_enabled = true
      # Sets whether policy and matching tags will be added to allow autoscaling.
      # spot_price           = ""        # "0.01" or any value to use "spot" (cheap but can leave) instances
    },
  ]
}
