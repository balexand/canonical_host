# CanonicalHost

[![Package](https://img.shields.io/hexpm/v/canonical_host.svg)](https://hex.pm/packages/canonical_host) [![Documentation](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/canonical_host) ![CI](https://github.com/balexand/canonical_host/actions/workflows/elixir.yml/badge.svg)

Plug for redirecting all traffic to a canonical host.

## Installation

The package can be installed by adding `canonical_host` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:canonical_host, "~> 0.2"}
  ]
end
```

## Usage

```elixir
# config/runtime.exs
config :canonical_host, :default, host: "https://myhost.com"
```

```elixir
# plug pipeline in router.ex or endpoint.ex
plug CanonicalHost
```

### Multiple canonical hosts

```elixir
# config/runtime.exs
config :canonical_host, :one, host: "https://host-one.com"
config :canonical_host, :two, host: "https://host-two.com"
```

```elixir
# one plug pipeline
plug CanonicalHost, config_key: :one

# another plug pipeline
plug CanonicalHost, config_key: :two
```
