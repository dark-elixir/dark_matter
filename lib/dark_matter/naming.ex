defmodule DarkMatter.Naming do
  @moduledoc """
  `DarkMatter`.
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
  """
  @spec parent_module_for(module()) :: module()
  def parent_module_for(module) do
    module
    |> Module.split()
    |> case do
      [part] ->
        [part]

      [_ | _] = parts ->
        parts
        |> Enum.reverse()
        |> tl()
        |> Enum.reverse()
    end
    |> Module.safe_concat()
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

  def underscore_number(number) do
    "#{number}"
    |> String.reverse()
    |> String.to_charlist()
    |> Enum.chunk_every(3)
    |> Enum.join("_")
    |> String.reverse()
    |> to_string()
  end

  # @doc """
  # Derives the `alias_plural` matter for the given `module`.
  # """
  # @spec alias_plural_for(module()) :: String.t()
  # def alias_plural_for(module) do
  # module
  # |> alias_for()
  # |> plural()
  # end

  # @doc """
  # Derives the `singular` matter for the given `module`.
  # """
  # @spec singular_for(module()) :: String.t()
  # def singular_for(module) do
  # module
  # |> alias_for()
  # |> snake()
  # end

  # @doc """
  # Derives the `plural` matter for the given `module`.
  # """
  # @spec plural_for(module()) :: String.t()
  # def plural_for(module) do
  #   module
  #   |> alias_for()
  # |> snake()
  # |> plural()
  # end

  #   @doc """
  # Derives the `camel_singular` matter for the given `module`.
  # """
  # @spec camel_singular_for(module()) :: String.t()
  # def camel_singular_for(module) do
  #   module
  #   |> singular_for()
  #   |> camel()
  # end

  # @doc """
  # Derives the `camel_plural` matter for the given `module`.
  # """
  # @spec camel_plural_for(module()) :: String.t()
  # def camel_plural_for(module) do
  #   module
  #   |> plural_for()
  #   |> camel()
  # end

  # @doc """
  # Derives the `human_singular` matter for the given `module`.
  # """
  # @spec human_singular_for(module()) :: String.t()
  # def human_singular_for(module) do
  # module
  # |> singular_for()
  # |> numan()
  # end

  # @doc """
  # Derives the `human_plural` matter for the given `module`.
  # """
  # @spec human_plural_for(module()) :: String.t()
  # def human_plural_for(module) do
  #   module
  #   |> plural_for()
  #   |> numan()
  # end

  # @doc """
  # Derives the `pascal_singular` matter for the given `module`.
  # """
  # @spec pascal_singular_for(module()) :: String.t()
  # def pascal_singular_for(module) do
  #   module
  #   |> singular_for()
  #   |> pascal()
  # end

  # @doc """
  # Derives the `pascal_plural` matter for the given `module`.
  # """
  # @spec pascal_plural_for(module()) :: String.t()
  # def pascal_plural_for(module) do
  #   module
  #   |> plural_for()
  #   |> pascal()
  # end

  # def stringify(atom) when is_atom(atom), do: Atom.to_string(atom)
  # def stringify(binary) when is_binary(binary), do: (binary)

  # def atomify(atom) when is_atom(atom), do: atom
  # def atomify(binary) when is_binary(binary), do: String.to_atom(binary)

  # def atomify_safe(atom) when is_atom(atom), do: atom
  # def atomify_safe(binary) when is_binary(binary), do: String.to_existing_atom(binary)

  # def pascal(name) when is_atom(name) or is_binary(name) do
  #   name |> stringify() |> AbsintheUtils.camelize( [lower: false])
  # end

  # def camel(name) when is_atom(name) or is_binary(name) do
  #   name |> stringify() |> AbsintheUtils.camelize( [lower: true])
  # end

  # def snake(name) when is_atom(name) or is_binary(name) do
  #   name |> stringify() |> Macro.underscore( )
  # end

  # def plural(name) when is_atom(name) or is_binary(name) do
  #   name |> stringify() Inflex.pluralize()
  # end

  # def singular(name) when is_atom(name) or is_binary(name) do
  #   name |> stringify() Inflex.singularize()
  # end
end
