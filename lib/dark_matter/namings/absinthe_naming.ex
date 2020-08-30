defmodule DarkMatter.Namings.AbsintheNaming do
  @moduledoc """
  Adapter for `Absinthe.Utils`.
  """

  case Code.ensure_compiled(Absinthe) do
    {:module, _module} ->
      defdelegate camelize(word), to: Absinthe.Utils
      defdelegate camelize(word, opts), to: Absinthe.Utils

    _ ->
      @doc """
      Camelize a word, respecting underscore prefixes.

      ## Examples

      With an uppercase first letter:

      ```
      iex> camelize("foo_bar")
      "FooBar"
      iex> camelize("foo")
      "Foo"
      iex> camelize("__foo_bar")
      "__FooBar"
      iex> camelize("__foo")
      "__Foo"
      iex> camelize("_foo")
      "_Foo"
      ```

      With a lowercase first letter:
      ```
      iex> camelize("foo_bar", lower: true)
      "fooBar"
      iex> camelize("foo", lower: true)
      "foo"
      iex> camelize("__foo_bar", lower: true)
      "__fooBar"
      iex> camelize("__foo", lower: true)
      "__foo"
      iex> camelize("_foo", lower: true)
      "_foo"

      ```
      """
      @spec camelize(binary, Keyword.t()) :: binary
      def camelize(word, opts \\ [])

      def camelize("_" <> word, opts) do
        "_" <> camelize(word, opts)
      end

      def camelize(word, opts) do
        case opts |> Enum.into(%{}) do
          %{lower: true} ->
            {first, rest} = String.split_at(Macro.camelize(word), 1)
            String.downcase(first) <> rest

          _ ->
            Macro.camelize(word)
        end
      end
  end
end
