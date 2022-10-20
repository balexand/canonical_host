defmodule CanonicalHost do
  @behaviour Plug

  @impl true
  def init(nil), do: %{host: nil, scheme: nil}

  def init(canonical_scheme_and_host) do
    uri = URI.parse(canonical_scheme_and_host)

    %{host: uri.host, scheme: uri.scheme}
  end

  @impl true
  def call(conn, %{host: nil}), do: conn
  def call(%Plug.Conn{host: host} = conn, %{host: host}), do: conn
  def call(%Plug.Conn{method: method} = conn, %{}) when method != "GET", do: conn

  def call(conn, %{host: host, scheme: scheme}) do
    location = "#{scheme}://#{host}#{conn.request_path}#{query_suffix(conn.query_string)}"

    conn
    |> Phoenix.Controller.redirect(external: location)
    |> Plug.Conn.halt()
  end

  defp query_suffix(""), do: ""
  defp query_suffix(query_string), do: "?#{query_string}"
end
