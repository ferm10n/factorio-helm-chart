# factorio server helm chart

setup the configuration in a `values.custom.yaml` and do:

```sh
helm upgrade --install -f values.custom.yaml factorio oci://ghcr.io/ferm10n/factorio-helm-chart/charts/factorio
```

TIP: The factorio server will try to load the latest save it can find, or generate one if it can't find it, and it also saves the loaded map on exit. You'll probably want to scale the deployment to 0, then upload the save with filebrowser so you can control what the latest save is after you scale it back up to 1.

see [values.schema.json](chart/values.schema.json) for all configuration options

- NodePorts are used, this is mainly intended for a single machine cluster
  - ports are different because of NodePort range limitations. Connect your factorio game client to something like `factorio.mysite.com:31088`
    - this port is configurable
  - connect to the game server on port `31088`
  - connect to rcon (?) on port `30261`

PRs welcome! I'm relatively new to helm charts so I'm eager to learn more.

## values.custom.yaml

helm values you will want to set:
```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/ferm10n/factorio-helm-chart/refs/heads/main/chart/values.schema.json#
factorio:
  image:
    tag: 2.0.15 # or whatever the latest is
  persistence:
    storageClass: local-path # or whatever makes sense in your cluster. this one is supported by k3s
dydns: # config for dydns
  env:
    - name: DYDNS_HOST
      value: factorio # subdomain
    - name: DYDNS_DOMAIN
      value: mysite.com
  secretEnv:
    DYDNS_PASSWORD: insertapitokenhere
```

## helm chart features

- dydns cronjob
  - by default uses a command that works with namecheap domains (maybe others too, idk)
    - command based on: https://gist.github.com/dalhundal/89159b3f032588586e91
  - configurable command, image, and schedule
    - default schedule is every 6 hours
  - disable by removing `dydns` values
  - also runs on chart install/upgrade
    - disable by setting `dydns.hooks.enabled` to `false`
- filebrowser
  - Easily deploy mods and upload and download saves through a web interface
  - No authentication, so I made it not normally accessible. Access with `kubectl port-forward ...` or use the vscode task
  - disable by setting `filebrowser.enabled` to `false`
- persistent storage
  - can use an existing PVC (with `factorio.persistence.pvcName`), or allow the chart to create one, given a `storageClass`
  - allocates 2Gi by default when creating the PVC

## project features

- [.vscode/tasks.json](.vscode/tasks.json)
- commonly used templates in [_helpers.tpl](chart/templates/_helpers.tpl)
- automatically publish chart to github container registry
