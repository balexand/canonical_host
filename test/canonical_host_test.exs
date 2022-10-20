defmodule CanonicalHostTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Phoenix.ConnTest, only: [redirected_to: 1]

  test "host matches canonical host doesn't redirect" do
    conn = conn(:get, "/") |> CanonicalHost.call(CanonicalHost.init("https://www.example.com/"))

    refute conn.halted
  end

  test "POST doesn't redirect" do
    conn = conn(:post, "/") |> CanonicalHost.call(CanonicalHost.init("http://canonical.com"))

    refute conn.halted
  end

  test "disabled when passed nil" do
    conn = conn(:get, "/") |> CanonicalHost.call(CanonicalHost.init(nil))

    refute conn.halted
  end

  test "redirects to http with no query string" do
    conn = conn(:get, "/") |> CanonicalHost.call(CanonicalHost.init("http://canonical.com"))

    assert conn.halted
    assert redirected_to(conn) == "http://canonical.com/"
  end

  test "redirects to https with query string" do
    conn =
      conn(:get, "/my/path?a=b&c=d")
      |> CanonicalHost.call(CanonicalHost.init("https://canonical.com"))

    assert conn.halted
    assert redirected_to(conn) == "https://canonical.com/my/path?a=b&c=d"
  end
end
