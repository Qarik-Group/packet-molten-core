# Packet MoltenCore

This project allows operators to bootstrap a MoltenCore cluster on bare-metal
using the [terraform provider](https://www.terraform.io/docs/providers/packet/index.html) for [packet.com](https://www.packet.com/).

## What is MoltenCore
MoltenCore allows running containerized container platforms on bare-metal in a
BOSH native way, using a highly available scale out architecture.
The main repo can be found on [github](https://github.com/starkandwayne/molten-core).

## Deploying MoltenCore
This project uses terraform to provision bare-metal servers.

### Install Terraform
It has been tested successfully with **terraform 0.12.x**
Follow the instructions [here](https://learn.hashicorp.com/terraform/getting-started/install.html)
to install terraform on your system.

### Clone the project
The packet-molten-core repo contains the terraform we need for the task at hand.
Go ahead and clone the repo, we will also copy the vars template which we need
in further steps:

```
git clone https://github.com/starkandwayne/packet-molten-core
cd packet-molten-core
cp terraform.tfvars.example terraform.tfvars
```

### Setup a Packet account
Create a Packet account by signing-up [here](https://app.packet.net/signup).

#### Create a project
Your serves will be created in a project, please refer to [this support article](https://support.packet.com/kb/articles/portal)
on how to setup a project.

#### Retrieve your packet project id
select the project you just created and then browse to project settings.
here you will find your **Project ID**

1. copy your **Project ID** and fill it in your `terraform.tfvars` file

#### Retrieve your packet user api key
in the right top corner you will see your profile
in the dropdown menu you will see a link **API Keys**
create an api key here.

1. copy your **API Key** and fill it in your `terraform.tfvars` file

### *Optionally* customize the defaults
With your **Project ID** and **API Key** filled in you should be go to go,
however you might want the change the following defaults:

**packet_facility:** the geographic location of the server datacenter full list [here](https://support.packet.com/kb/articles/data-centers).

**node_type:** the type of server to use, available types [here](https://www.packet.com/cloud/servers/)

**node_count:** number of nodes you want, best to use odd numbers when deploying cf or k8s to keep quorum

### Deploy
Now we can go ahead and deploy our cluster
```
terraform init    # to retrieve all the modules
terraform plan    # to verify all variables
terraform apply   # actually deploy a MoltenCore
```

## Using MoltenCore
All management interactions with your MoltenCore cluster are performed from the
first node (zone zero, `z0` for short). This node also hosts the embedded [BUCC](https://github.com/starkandwayne/bucc).
Use the helper script (`./utils/ssh`) to access `node-z0` by default it wil go to `z0`
other nodes can be reached by passing a number (eg. `./utils/ssh 1` to go the second node)

```
./utils/ssh                   # ssh to node-z0
journalctl -f -u bucc.service # wait for BUCC to be deployed
mc shell                      # start interactive shell for interacting with BUCC
```

For more things to do with your cluster refer to the [molten-core repo](https://github.com/starkandwayne/molten-core).

## Cleanup
Terraform can be used to delete your MoltenCore cluster.
To do so run the following command:
```
terraform destroy

```
