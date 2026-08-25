# wtpl

`wtpl` renders a Kubernetes manifest after applying its environment-specific
`wander-env` / `wander-deployment-env` values, per-container image overrides,
and optional runtime overrides.

The standalone CLI is useful for inspecting exactly what an environment will
apply without starting Tilt:

```bash
bin/wtpl \
  --env staging \
  --file manifests/gke/paymentdb/cluster.yaml \
  --images '{"database":"example/image:tag"}' \
  --extra-overrides '{"metadata":{"labels":{"canary":"blue"}}}'
```

`--env` and `--file` are required. `--images`, `--extra-overrides`, and `--out`
are optional. JSON inputs must be objects. When `--out` is provided, the CLI
writes the rendered YAML atomically.

The Tilt extension has no stable checkout-path variable analogous to Python's
`__file__`, so the extension retains the same renderer instead of invoking this
script by an unsafe relative path. Keep the two render programs in parity.
