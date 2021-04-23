case Code.ensure_compiled(Phoenix) do
  {:module, _module} ->
    defmodule DarkMatter.Namings.PhoenixNaming do
      @moduledoc """
      Conveniences for inflecting and working with names in Phoenix.
      """

      @doc """
      Delegates to `Phoenix.Naming.resource_name/1`.
      """
      @spec resource_name(any()) :: String.t()
      defdelegate resource_name(alias), to: Phoenix.Naming

      @doc """
      Delegates to `Phoenix.Naming.resource_name/2`.
      """
      @spec resource_name(any(), String.t()) :: String.t()
      defdelegate resource_name(alias, suffix), to: Phoenix.Naming

      @doc """
      Delegates to `Phoenix.Naming.unsuffix/2`.
      """
      @spec unsuffix(String.t(), String.t()) :: String.t()
      defdelegate unsuffix(value, suffix), to: Phoenix.Naming

      @doc """
      Delegates to `Phoenix.Naming.underscore/1`.
      """
      @spec underscore(String.t()) :: String.t()
      defdelegate underscore(value), to: Phoenix.Naming

      @doc """
      Delegates to `Phoenix.Naming.camelize/1`.
      """
      @spec camelize(String.t()) :: String.t()
      defdelegate camelize(value), to: Phoenix.Naming

      @doc """
      Delegates to `Phoenix.Naming.camelize/1`.
      """
      @spec camelize(String.t(), :lower) :: String.t()
      defdelegate camelize(value, opt), to: Phoenix.Naming

      @doc """
      Delegates to `Phoenix.Naming.humanize/1`.
      """
      @spec humanize(atom() | String.t()) :: String.t()
      defdelegate humanize(value), to: Phoenix.Naming
    end

  _any ->
    defmodule DarkMatter.Namings.PhoenixNaming do
      @moduledoc """
      Conveniences for inflecting and working with names in Phoenix.
      """

      @doc """
      Extracts the resource name from an alias.
      ## Examples

          iex> DarkMatter.Namings.PhoenixNaming.resource_name(MyApp.User)
          "user"

          iex> DarkMatter.Namings.PhoenixNaming.resource_name(MyApp.UserView, "View")
          "user"
      """
      @spec resource_name(String.Chars.t(), String.t()) :: String.t()
      def resource_name(alias, suffix \\ "") do
        alias
        |> to_string()
        |> Module.split()
        |> List.last()
        |> unsuffix(suffix)
        |> underscore()
      end

      @doc """
      Removes the given suffix from the name if it exists.
      ## Examples

          iex> DarkMatter.Namings.PhoenixNaming.unsuffix("MyApp.User", "View")
          "MyApp.User"

          iex> DarkMatter.Namings.PhoenixNaming.unsuffix("MyApp.UserView", "View")
          "MyApp.User"
      """
      @spec unsuffix(String.t(), String.t()) :: String.t()
      def unsuffix(value, suffix) do
        string = to_string(value)
        suffix_size = byte_size(suffix)
        prefix_size = byte_size(string) - suffix_size

        case string do
          <<prefix::binary-size(prefix_size), ^suffix::binary>> -> prefix
          _any -> string
        end
      end

      @doc """
      Converts a string to underscore case.
      ## Examples

          iex> DarkMatter.Namings.PhoenixNaming.underscore("MyApp")
          "my_app"

      In general, `underscore` can be thought of as the reverse of
      `camelize`, however, in some cases formatting may be lost:
          DarkMatter.Namings.PhoenixNaming.underscore "SAPExample"  #=> "sap_example"
          DarkMatter.Namings.PhoenixNaming.camelize   "sap_example" #=> "SapExample"
      """
      @spec underscore(String.t()) :: String.t()
      def underscore(value), do: Macro.underscore(value)

      defp to_lower_char(char) when char in ?A..?Z, do: char + 32
      defp to_lower_char(char), do: char

      @doc """
      Converts a string to camel case.
      Takes an optional `:lower` flag to return lowerCamelCase.
      ## Examples

          iex> DarkMatter.Namings.PhoenixNaming.camelize("my_app")
          "MyApp"

          iex> DarkMatter.Namings.PhoenixNaming.camelize("my_app", :lower)
          "myApp"

      In general, `camelize` can be thought of as the reverse of
      `underscore`, however, in some cases formatting may be lost:
          DarkMatter.Namings.PhoenixNaming.underscore "SAPExample"  #=> "sap_example"
          DarkMatter.Namings.PhoenixNaming.camelize   "sap_example" #=> "SapExample"
      """
      @spec camelize(String.t()) :: String.t()
      def camelize(value) do
        Macro.camelize(value)
      end

      @spec camelize(String.t(), :lower) :: String.t()
      def camelize("", :lower) do
        ""
      end

      def camelize(<<?_, t::binary>>, :lower) do
        camelize(t, :lower)
      end

      def camelize(<<h, _t::binary>> = value, :lower) do
        <<_first, rest::binary>> = camelize(value)
        <<to_lower_char(h)>> <> rest
      end

      @doc """
      Converts an attribute/form field into its humanize version.
      ## Examples

          iex> DarkMatter.Namings.PhoenixNaming.humanize(:username)
          "Username"

          iex> DarkMatter.Namings.PhoenixNaming.humanize(:created_at)
          "Created at"

          iex> DarkMatter.Namings.PhoenixNaming.humanize("user_id")
          "User"
      """
      @spec humanize(atom | String.t()) :: String.t()
      def humanize(atom) when is_atom(atom) do
        humanize(Atom.to_string(atom))
      end

      def humanize(bin) when is_binary(bin) do
        bin
        |> String.replace_trailing("_id", "")
        |> String.replace("_", " ")
        |> String.capitalize()
      end
    end
end
