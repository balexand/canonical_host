defmodule CanonicalHost.MixProject do
  use Mix.Project

  @version "0.3.0"

  def project do
    [
      app: :canonical_host,
      description: "Plug for redirecting all traffic to a canonical host.",
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/balexand/canonical_host"}
      ],
      docs: [
        extras: ["README.md"],
        source_ref: "v#{@version}",
        source_url: "https://github.com/balexand/canonical_host"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.0"},
      {:ex_doc, "~> 0.29", only: :dev}
    ]
  end
end
