# Packet MoltenCore

This project allows operators to bootstrap a MoltenCore cluster on bare-metal
using the [terraform provider](https://www.terraform.io/docs/providers/packet/index.html) for [packet.com](https://www.packet.com/).

## What is MoltenCore

A MoltenCore Cluster uses [CoreOS Container Linux](https://coreos.com/os/docs/latest/)
where it has been fully integrated with [BUCC](https://github.com/starkandwayne/bucc).
After bootstrapping the cluster, an operator can directly start using [Concourse](https://concourse-ci.org)
(part of BUCC) pipelines to start deploying things with [BOSH](https://bosh.io).

```
+-------------------------------------+
|           ||           ||           |
+-------------------------------------+
||      ||                           ||
|| BUCC ||                           ||
||      ||    BOSH deployed things   ||
+--------+     e.g. Cloud Foundry    ||
|        |                           ||
|        |                           ||
|        +----------------------------+
|           ||           ||           |
|flannel /28||flannel /28||flannel /28|
| CoreOS Z0 || CoreOS Z1 || CoreOS Z2 |
+-------------------------------------+
```
