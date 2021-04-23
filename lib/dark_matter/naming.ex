defmodule DarkMatter.Naming do
  @moduledoc """
  DarkMatter naming conventions.
  """
  @moduledoc since: "1.0.0"

  alias DarkMatter.Inflections

  defstruct [
    :module,
    :base_module,
    :parent_module,
    :alias,
    :alias_plural,
    :singular,
    :plural,
    :camel_plural,
    :camel_singular,
    :human_plural,
    :human_singular,
    :title_plural,
    :title_singular,
    :pascal_plural,
    :pascal_singular
  ]

  @type t() :: %__MODULE__{
          module: module(),
          base_module: module(),
          parent_module: module(),
          alias: String.t(),
          alias_plural: String.t(),
          singular: String.t(),
          plural: String.t(),
          camel_plural: String.t(),
          camel_singular: String.t(),
          human_plural: String.t(),
          human_singular: String.t(),
          title_plural: String.t(),
          title_singular: String.t(),
          pascal_plural: String.t(),
          pascal_singular: String.t()
        }

  @doc """
  Definition for reflected `DarkPhoenix.Schema`.

  ## Examples

      iex> cast(DarkMatter)
      %DarkMatter.Naming{
        alias: "DarkMatter",
        alias_plural: "DarkMatters",
        base_module: DarkMatter,
        camel_plural: "darkMatters",
        camel_singular: "darkMatter",
        human_plural: "Darkmatters",
        human_singular: "Darkmatter",
        title_plural: "Dark Matters",
        title_singular: "Dark Matter",
        module: DarkMatter,
        parent_module: DarkMatter,
        pascal_plural: "DarkMatters",
        pascal_singular: "DarkMatter",
        plural: "dark_matters",
        singular: "dark_matter"
      }

      iex> cast(DarkMatter.Inflections)
      %DarkMatter.Naming{
        alias: "Inflections",
        alias_plural: "Inflections",
        base_module: DarkMatter,
        camel_plural: "inflections",
        camel_singular: "inflection",
        human_plural: "Inflections",
        human_singular: "Inflections",
        module: DarkMatter.Inflections,
        parent_module: DarkMatter,
        pascal_plural: "Inflections",
        pascal_singular: "Inflections",
        plural: "inflections",
        singular: "inflections",
        title_plural: "Inflections",
        title_singular: "Inflections"
      }

      iex> cast(Ecto.Changeset)
      %DarkMatter.Naming{
        alias: "Changeset",
        alias_plural: "Changesets",
        base_module: Ecto,
        camel_plural: "changesets",
        camel_singular: "changeset",
        human_plural: "Changesets",
        human_singular: "Changeset",
        title_plural: "Changesets",
        title_singular: "Changeset",
        module: Ecto.Changeset,
        parent_module: Ecto,
        pascal_plural: "Changesets",
        pascal_singular: "Changeset",
        plural: "changesets",
        singular: "changeset"
      }
  """
  @spec cast(module()) :: t()
  def cast(module) when is_atom(module) do
    module_alias = alias_for(module)

    %__MODULE__{
      module: module,
      alias: alias_for(module),
      base_module: base_module_for(module),
      parent_module: parent_module_for(module),
      alias_plural: Inflections.binary(module_alias, [:plural]),
      singular: Inflections.binary(module_alias, [:underscore]),
      plural: Inflections.binary(module_alias, [:underscore, :plural]),
      camel_singular: Inflections.binary(module_alias, [:singular, :absinthe_camel]),
      camel_plural: Inflections.binary(module_alias, [:plural, :absinthe_camel]),
      human_singular: Inflections.binary(module_alias, [:human]),
      human_plural: Inflections.binary(module_alias, [:plural, :human]),
      title_singular: Inflections.binary(module_alias, [:title]),
      title_plural: Inflections.binary(module_alias, [:plural, :title]),
      pascal_singular: Inflections.binary(module_alias, [:underscore, :absinthe_pascal]),
      pascal_plural: Inflections.binary(module_alias, [:underscore, :plural, :absinthe_pascal])
    }
  end

  @doc """
  Derives the ` de` matter for the given `module`.

  ## Examples

      iex> base_module_for(DarkMatter)
      DarkMatter

      iex> base_module_for(DarkMatter.Inflections)
      DarkMatter

      iex> base_module_for(DarkMatter.Decimals.Arithmetic)
      DarkMatter
  """
  @spec base_module_for(module()) :: module()
  def base_module_for(module) do
    module
    |> Module.split()
    |> hd()
    |> List.wrap()
    |> Module.safe_concat()
  end

  @doc """
  Derives the `parent_module` matter for the given `module`.

  ## Examples

      iex> parent_module_for(DarkMatter)
      DarkMatter

      iex> parent_module_for(DarkMatter.Inflections)
      DarkMatter

      iex> parent_module_for(DarkMatter.Decimals.Arithmetic)
      DarkMatter.Decimals
  """
  @spec parent_module_for(module()) :: module()
  def parent_module_for(module) do
    case Module.split(module) do
      [part] ->
        Module.safe_concat([part])

      [_hd | _tl] = parts ->
        parts
        |> Enum.reverse()
        |> tl()
        |> Enum.reverse()
        |> Module.safe_concat()
    end
  end

  @doc """
  Derives the `alias` matter for the given `module`.

  ## Examples

      iex> alias_for(DarkMatter)
      "DarkMatter"

      iex> alias_for(DarkMatter.Inflections)
      "Inflections"
  """
  @spec alias_for(module()) :: String.t()
  def alias_for(module) do
    module
    |> Module.split()
    |> Enum.reverse()
    |> hd()
  end

  @doc """
  Turn a `number` into a snake cased elixir numeric.

  ## Examples

      iex> underscore_number(1)
      "1"

      iex> underscore_number(100)
      "100"

      iex> underscore_number(1000)
      "1_000"

      iex> underscore_number(100000)
      "100_000"

      iex> underscore_number(100000000)
      "100_000_000"
  """
  @spec underscore_number(number() | String.t()) :: String.t()
  def underscore_number(number) when is_number(number) or is_binary(number) do
    "#{number}"
    |> String.reverse()
    |> String.to_charlist()
    |> Enum.chunk_every(3)
    |> Enum.join("_")
    |> String.reverse()
    |> to_string()
  end
end
