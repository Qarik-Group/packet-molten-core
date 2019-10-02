# Packet MoltenCore

This project allows operators to bootstrap a MoltenCore cluster on bare-metal
using the [terraform provider](https://www.terraform.io/docs/providers/packet/index.html) for [packet.com](https://www.packet.com/).

## What is MoltenCore
for more information about MoltenCore please see the following:
Repo: https://github.com/starkandwayne/molten-core
Blog:

## Deploying MoltenCore

Requirements:
- terraform 0.12.x

### Setup a Packet account
Signup at https://app.packet.net/signup

Create a project
for more information about the packet portal: https://support.packet.com/kb/articles/portal

### retrieve your packet project id
select the project you just created
and then browse to project settings.
here you will find your `Project ID`

### retrieve your packet user api key
in the right top corner you will see your profile
in the dropdown menu you will see a link `API Keys`
create an api key here.

### edit vars.tf
copy vars.tf.example to vars.tf
`cp vars.tf.example vars.tf`

fill in your api and project id

choose a `packet_facility` location
you can find all the locations listed here https://support.packet.com/kb/articles/data-centers
(this is the geographic location of the datacenter where the server will be hosted)

select a `node_type` e.g. c1.small.x86
you can find all type of nodes at https://www.packet.com/cloud/servers/
we would recommend:  

choose how many nodes you want `node_count`

### Deploy!!
now we need to verify and deploy our infrastructre
```
terraform init    # to retrieve all the modules
terraform plan    # to verify all variables
terraform apply   # actually deploy a MoltenCore
terraform destroy # *WARNING* this will destroy your deployment
```

## Running MoltenCore
you just deployed MoltenCore on packet and now you want to know what is going on
`./utils/ssh` by default ssh wil go to the first node you can add `./utils/ssh 1` to go the second node

once your in sshed in to a node.
check the documentation in the [MoltenCore](https://github.com/starkandwayne/molten-core) repo for further steps
