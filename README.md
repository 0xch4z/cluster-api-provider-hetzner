# Cluster API Provider Hetzner (fork)

A [Cluster API](https://cluster-api.sigs.k8s.io/) infrastructure provider for [Hetzner](https://www.hetzner.com/), enabling declarative Kubernetes cluster lifecycle management on Hetzner Cloud and Hetzner Bare Metal.

This is a fork of [syself/cluster-api-provider-hetzner](https://github.com/syself/cluster-api-provider-hetzner) with the following additions:

- **Cluster API v1beta2** (CAPI v1.12)
- **Kubernetes 1.35** support
- **Talos Linux** support via the `hcloud-talos` cluster template flavor

## Cluster Template Flavors

| Flavor | Control Plane | Workers | OS | Bootstrap |
|--------|--------------|---------|-----|-----------|
| `hcloud-talos` | HCloud | HCloud | Talos Linux | CABPT/CACPPT |

## Talos Usage

The `hcloud-talos` flavor requires:

1. A Talos Linux snapshot in your Hetzner Cloud account (see [terraform-hcloud-talos-image](https://github.com/hcloud-talos/terraform-hcloud-talos-image))
2. The [Talos bootstrap provider (CABPT)](https://github.com/siderolabs/cluster-api-bootstrap-provider-talos) and [control plane provider (CACPPT)](https://github.com/siderolabs/cluster-api-control-plane-provider-talos) installed in your management cluster

```bash
export HCLOUD_CONTROL_PLANE_MACHINE_TYPE=cpx41
export HCLOUD_WORKER_MACHINE_TYPE=cpx41
export SSH_KEY_NAME=<your-ssh-key>
export HCLOUD_REGION=<desired-region>
export TALOS_VERSION=v1.12.6
export TALOS_IMAGE_NAME=talos-v1.12.6
clusterctl generate cluster my-cluster \
  --flavor hcloud-talos \
  --kubernetes-version v1.35.3 \
  --control-plane-machine-count 1 \
  --worker-machine-count 1 \
  > my-cluster.yaml
```

## Compatibility

| Component | Version |
|-----------|---------|
| Cluster API | v1.12.x (v1beta2) |
| Kubernetes | 1.29 - 1.35 |
| Talos Linux | v1.12.x |

## Local development

```bash
./hack/local-install.sh && clusterctl init \
  --infrastructure hetzner \
  --bootstrap talos \
  --control-plane talos
```

## Upstream

This fork is based on the `v1.2.x-v1beta2` branch of the upstream project. The original upstream `main` is preserved as the `main-upstream` branch.

For upstream documentation, see [caph.syself.com](https://caph.syself.com).

## License

Apache License 2.0 -- see [LICENSE](LICENSE) and [NOTICE](NOTICE).

Originally created by [Syself](https://syself.com) and the CAPH community.
