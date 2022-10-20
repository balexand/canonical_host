defmodule CanonicalHost do
  @behaviour Plug

  @impl true
  def init(opts) do
    [config_key: opts |> Keyword.validate!([:config_key]) |> Keyword.get(:config_key, :default)]
  end

  @impl true
  def call(%Plug.Conn{method: method} = conn, _) when method != "GET", do: conn

  def call(conn, config_key: config_key) do
    case Application.get_env(:canonical_host, config_key) do
      nil -> conn
      opts -> do_call(conn, Keyword.get(opts, :host), Keyword.get(opts, :scheme, "https"))
    end
  end

  defp do_call(conn, nil, _scheme), do: conn
  defp do_call(%Plug.Conn{host: host} = conn, host, _scheme), do: conn

  defp do_call(conn, host, scheme) do
    location = "#{scheme}://#{host}#{conn.request_path}#{query_suffix(conn.query_string)}"

    conn
    |> Phoenix.Controller.redirect(external: location)
    |> Plug.Conn.halt()
  end

  defp query_suffix(""), do: ""
  defp query_suffix(query_string), do: "?#{query_string}"
end
