# Work with AWS KEY_PAIR via terraform

A terraform module for making KEY_PAIR.


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
  profile                 = "default"
  shared_credentials_file = pathexpand("/Users/captain/.aws/credentials")
}

module "key_pair" {
  source = "../../modules/key_pair"

  enable_key_pair = true
  key_name        = "test"
  public_key      = file("/Users/captain/.ssh/id_rsa.pub")

}
```

## Module Input Variables
----------------------
- `name` - Name to be used on all resources (`default = TEST`)
- `enable_key_pair` - Enable aws key_pair (`default = ""`)
- `key_name` - (Optional) The name for the key pair. (`default = ""`)
- `public_key` - (Required) The public key material. (`default = ""`)
- `key_name_prefix` - (Optional) Creates a unique name beginning with the specified prefix. Conflicts with key_name. (`default = key-`)

## Module Output Variables
----------------------


## Authors

Created and maintained by [Vitaliy Natarov](https://github.com/SebastianUA). An email: [vitaliy.natarov@yahoo.com](vitaliy.natarov@yahoo.com).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/SebastianUA/terraform/blob/master/LICENSE) for full details.
