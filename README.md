# CanonicalHost

[![Package](https://img.shields.io/hexpm/v/canonical_host.svg)](https://hex.pm/packages/canonical_host) [![Documentation](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/canonical_host) ![CI](https://github.com/balexand/canonical_host/actions/workflows/elixir.yml/badge.svg)

Plug for redirecting all traffic to a canonical host.

## Installation

The package can be installed by adding `canonical_host` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:canonical_host, "~> 1.0"}
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

## Alternatives

### [`plug_canonical_host`](https://hex.pm/packages/plug_canonical_host)

I chose to create a new library instead of using this library for the following reasons:

1. Has awkward configuration. It is not convenient to configure at runtime. Instead, the [README](https://github.com/remi/plug_canonical_host/blob/master/README.md) suggests that you write your own function plug and then call both `PlugCanonicalHost.init/1` and `PlugCanonicalHost.call/2` in your function plug.
2. Redirects HTTP requests with methods other than `GET`. Consider a case where an API client sends a `POST` request to your app at the non-canonical domain. `PlugCanonicalHost` will cause the request to not be handled but will return an HTTP `301` response which would make the client believe that the request succeeded.
3. Tries to redirect with the same scheme (HTTP/HTTPS) and port number as the original request. I'd prefer to always redirect to the canonical scheme/host/port and save the user a possible extra redirect.
