defmodule CanonicalHost do
  @moduledoc """
  See [README](readme.html) for usage.
  """

  @behaviour Plug

  @impl true
  def init(opts) do
    opts = Keyword.validate!(opts, [:config_key])

    [config_key: Keyword.get(opts, :config_key, :default)]
  end

  @impl true
  def call(%Plug.Conn{method: "GET"} = conn, config_key: config_key) do
    case Application.get_env(:canonical_host, config_key) do
      nil ->
        conn

      opts ->
        opts = Keyword.validate!(opts, [:additional_hosts, :host, :scheme])
        do_call(conn, Keyword.get(opts, :host), opts)
    end
  end

  def call(conn, _), do: conn

  defp do_call(conn, nil = _host, _opts), do: conn
  defp do_call(%Plug.Conn{host: host} = conn, host, _opts), do: conn

  defp do_call(conn, host, opts) do
    additional_hosts = Keyword.get(opts, :additional_hosts, [])
    scheme = Keyword.get(opts, :scheme, "https")

    if conn.host in additional_hosts do
      conn
    else
      location = "#{scheme}://#{host}#{conn.request_path}#{query_suffix(conn.query_string)}"

      conn
      |> Phoenix.Controller.redirect(external: location)
      |> Plug.Conn.halt()
    end
  end

  defp query_suffix(""), do: ""
  defp query_suffix(query_string), do: "?#{query_string}"
end
