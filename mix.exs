defmodule DarkMatter.MixProject do
  @moduledoc """
  Mix Project for `DarkMatter`
  """

  use Mix.Project

  @version "1.1.0"
  @name "DarkMatter"
  @hexpm_url "http://hexdocs.pm/dark_matter"
  @github_url "https://github.com/dark-elixir/dark_matter"
  @description "Libraries and utils for general elixir development."

  def project do
    [
      app: :dark_matter,
      version: @version,
      deps: deps(),
      start_permanent: Mix.env() == :prod,
      dialyzer: dialyzer(),

      # Hex
      description: @description,
      package: package(),
      source_url: @github_url,

      # Docs
      name: @name,
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:dark_dev, ">= 1.0.8", only: [:dev, :test], runtime: false},
      {:absinthe, ">= 1.6.4", optional: true},
      {:phoenix, ">= 1.5.0", optional: true},
      {:ecto, ">= 3.0.0", optional: true},
      {:jason, ">= 1.2.2"},
      {:iteraptor, ">= 1.5.0"},
      {:inflex, ">= 2.0.0"},
      {:recase, ">= 0.5.0"},
      {:decimal, ">= 2.0.0"},
      {:numerix, ">= 0.6.0"},
      {:hashids, ">= 2.0.0"},
      {:doctor, ">= 0.0.0"}
    ]
  end

  defp package() do
    [
      maintainers: ["Michael Sitchenko"],
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @github_url}
    ]
  end

  defp docs do
    [
      main: @name,
      source_ref: "v#{@version}",
      canonical: @hexpm_url,
      logo: "guides/images/dark-elixir.png",
      extra_section: "GUIDES",
      source_url: @github_url,
      extras: extras(),
      groups_for_extras: groups_for_extras(),
      groups_for_modules: []
    ]
  end

  def extras() do
    [
      # "guides/introduction/Getting Started.md",
      "README.md"
    ]
  end

  defp groups_for_extras do
    [
      # Introduction: ~r/guides\/introduction\/.?/,
    ]
  end

  defp dialyzer do
    [
      plt_add_deps: :app_tree,
      plt_add_apps: [:absinthe, :phoenix],
      list_unused_filters: true,
      flags: [
        # Useful additions
        :error_handling,
        :no_opaque,
        :race_conditions,
        :underspecs,
        :unmatched_returns,

        # Strict (annoying / low-impact)
        # :overspecs,
        # :specdiffs,

        # Less common / potentially confusing
        # (Can disable without much consequence)
        :no_behaviours,
        :no_contracts,
        :no_fail_call,
        :no_fun_app,
        :no_improper_lists,
        :no_match,
        :no_missing_calls,
        :no_return,
        :no_undefined_callbacks,
        :no_unused,
        :unknown
      ]
    ]
  end
end
