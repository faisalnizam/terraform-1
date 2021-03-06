# Work with AWS SFN via terraform

A terraform module for making SFN.


## Usage
----------------------
Import the module and retrieve with ```terraform get``` or ```terraform get --update```. Adding a module resource to your template, e.g. `main.tf`:

```
#
# MAINTAINER Vitaliy Natarov "vitaliy.natarov@yahoo.com"
#
terraform {
  required_version = "~> 0.13"
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = pathexpand("~/.aws/credentials")
}

module "sfn" {
  source      = "../../modules/sfn"
  name        = "TEST"
  environment = "stage"

  enable_sfn_activity = true
  sfn_activity_name   = ""


  enable_sfn_state_machine     = true
  sfn_state_machine_name       = ""
  sfn_state_machine_role_arn   = "role_arn_here"
  sfn_state_machine_definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "HelloWorld",
  "States": {
    "HelloWorld": {
      "Type": "Task",
      "Resource": "lambda_arn_here",
      "End": true
    }
  }
}
EOF

  tags = merge(map(
    "createdby", "vnatarov"
  ))
}
```

## Module Input Variables
----------------------
- `name` - Name to be used on all resources as prefix (`default = TEST`)
- `environment` - Environment for service (`default = STAGE`)
- `tags` - A list of tag blocks. Each element should have keys named key, value, etc. (`default = ""`)
- `enable_sfn_activity` - Enable sfn activity (`default = ""`)
- `sfn_activity_name` - The name of the activity to create. (`default = ""`)
- `enable_sfn_state_machine` - Enable sfn state machine (`default = ""`)
- `sfn_state_machine_name` - The name of the state machine. (`default = ""`)
- `sfn_state_machine_definition` - (Required) The Amazon States Language definition of the state machine. (`default = null`)
- `sfn_state_machine_role_arn` - (Required) The Amazon Resource Name (ARN) of the IAM role to use for this state machine. (`default = null`)

## Module Output Variables
----------------------


## Authors

Created and maintained by [Vitaliy Natarov](https://github.com/SebastianUA). An email: [vitaliy.natarov@yahoo.com](vitaliy.natarov@yahoo.com).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/SebastianUA/terraform/blob/master/LICENSE) for full details.
