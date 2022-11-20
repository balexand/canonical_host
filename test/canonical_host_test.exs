defmodule CanonicalHostTest do
  use ExUnit.Case
  use Plug.Test

  import Phoenix.ConnTest, only: [redirected_to: 1]

  setup do
    Application.put_env(:canonical_host, :https_canonical, host: "canonical.com")
    Application.put_env(:canonical_host, :http_canonical, host: "canonical.com", scheme: "http")
    Application.put_env(:canonical_host, :nil_host, host: nil)

    :ok
  end

  test "host matches canonical doesn't redirect" do
    Application.put_env(:canonical_host, :default, host: "www.example.com")
    conn = conn(:get, "/") |> CanonicalHost.call(CanonicalHost.init([]))

    refute conn.halted
  end

  test "POST doesn't redirect" do
    Application.put_env(:canonical_host, :default, host: "canonical.com")
    conn = conn(:post, "/") |> CanonicalHost.call(CanonicalHost.init([]))

    refute conn.halted
  end

  test "additional_hosts option" do
    Application.put_env(:canonical_host, :default,
      host: "canonical.com",
      additional_hosts: ["www.example.com"]
    )

    conn = conn(:get, "/my/path?a=b&c=d") |> CanonicalHost.call(CanonicalHost.init([]))

    refute conn.halted
  end

  test "disabled when not configured" do
    Application.delete_env(:canonical_host, :default)
    conn = conn(:get, "/") |> CanonicalHost.call(CanonicalHost.init([]))

    refute conn.halted

    Application.put_env(:canonical_host, :default, host: nil)
    conn = conn(:get, "/") |> CanonicalHost.call(CanonicalHost.init([]))

    refute conn.halted
  end

  test "redirects to http with no query string" do
    Application.put_env(:canonical_host, :default, host: "canonical.com", scheme: "http")
    conn = conn(:get, "/") |> CanonicalHost.call(CanonicalHost.init([]))

    assert conn.halted
    assert redirected_to(conn) == "http://canonical.com/"
  end

  test "redirects to https with query string" do
    Application.put_env(:canonical_host, :default, host: "canonical.com")
    conn = conn(:get, "/my/path?a=b&c=d") |> CanonicalHost.call(CanonicalHost.init([]))

    assert conn.halted
    assert redirected_to(conn) == "https://canonical.com/my/path?a=b&c=d"
  end

  test "with custom config key" do
    Application.put_env(:canonical_host, :default, host: "www.example.com")
    Application.put_env(:canonical_host, :custom, host: "custom.com")

    conn = conn(:get, "/") |> CanonicalHost.call(CanonicalHost.init(config_key: :custom))

    assert conn.halted
    assert redirected_to(conn) == "https://custom.com/"
  end
end
