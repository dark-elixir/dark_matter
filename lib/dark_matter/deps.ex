defmodule DarkMatter.Deps do
  @moduledoc """
  Utils for working with deps.
  """
  @moduledoc since: "1.1.0"

  @doc """
  Check if a given `dependency` has a version matching the `semversion`.

  ## Examples

      iex> version_match?(:dark_matter, ">= 0.0.0")
      true

      iex> version_match?(:dark_matter, "<= 0.0.0")
      false
  """
  @spec version_match?(atom(), String.t()) :: boolean()
  def version_match?(dependency, semversion) when is_atom(dependency) and is_binary(semversion) do
    case Application.spec(dependency, :vsn) do
      nil -> false
      version when is_list(version) -> Version.match?("#{version}", semversion)
    end
  end
end
