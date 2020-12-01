defmodule DarkMatter.Modules do
  @moduledoc """
  Utils for working with modules.
  """
  @moduledoc since: "1.0.5"

  import DarkMatter.Mfas, only: [is_mfa: 1]

  alias DarkMatter.Structs

  @type t() :: module()

  defguard is_module(module) when is_atom(module)

  @doc """
  Determine if a given module contains a `defstruct` definition.

  ## Examples

      iex> defines_struct?(IO.Stream)
      true

      iex> defines_struct?(IO)
      false

      iex> defines_struct?(nil)
      ** (FunctionClauseError) no function clause matching in DarkMatter.Modules.defines_struct?/1
  """
  @spec defines_struct?(t()) :: boolean()
  def defines_struct?(module) when is_atom(module) and module not in [nil] do
    exports?({module, :__struct__, 0}) and exports?({module, :__struct__, 1})
  end

  @doc """
  Determine if a given module contains a `defstruct` definition.

  ## Examples

      iex> exports?({Kernel, :+, 2})
      true

      iex> exports?({Kernel, :*, 0})
      false

      iex> exports?({Kernel, :/, -100})
      ** (FunctionClauseError) no function clause matching in DarkMatter.Modules.exports?/1

      iex> exports?(nil)
      ** (FunctionClauseError) no function clause matching in DarkMatter.Modules.exports?/1
  """
  @spec exports?(mfa()) :: boolean()
  def exports?({module, fun, arity} = mfa) when is_mfa(mfa) do
    if Code.ensure_loaded?(module) do
      Kernel.function_exported?(module, fun, arity)
    else
      {fun, arity} in module.__info__(:functions)
    end
  end

  @doc """
  Determine keys for a given `module` or raises `ArgumentError`.

  ## Examples

      iex> struct_keys!(IO.Stream)
      [:device, :line_or_bytes, :raw]

      iex> struct_keys!(IO)
      ** (ArgumentError) Expected `defstruct` definition for: `IO`

      iex> struct_keys!(nil)
      ** (FunctionClauseError) no function clause matching in DarkMatter.Modules.struct_keys!/1
  """
  @spec struct_keys!(t()) :: [atom()]
  def struct_keys!(module) when is_atom(module) and module not in [nil] do
    unless defines_struct?(module) do
      raise ArgumentError,
        message: "Expected `defstruct` definition for: `#{inspect(module)}`"
    end

    Structs.keys(module.__struct__())
  end

  @doc """
  Loads all accessible modules, and returns list of loaded modules
  """
  def load_all do
    Enum.flat_map(:code.get_path(), &load_dir/1)
  end

  def load_dir(dir) when is_binary(dir) do
    dir
    |> File.ls!()
    |> Stream.filter(&beam_file?/1)
    |> Stream.map(&beam_to_module/1)
    |> Enum.map(fn module ->
      :ok = load_path(module, "#{dir}/#{module}")
      module
    end)
  end

  def beam_file?(path) when is_binary(path) do
    String.ends_with?(path, ".beam")
  end

  def beam_to_module(path) when is_binary(path) do
    ~r/(\.beam)$/
    |> Regex.replace(path, fn _, _ -> "" end)
    |> String.to_atom()
  end

  def load_path(module, path) when is_atom(module) and is_binary(path) do
    with {:module, ^module} <- do_load_path(module, path) do
      :ok
    end
  end

  defp do_load_path(module, path) when is_atom(module) and is_binary(path) do
    if Code.ensure_loaded?(module) do
      {:module, module}
    else
      path
      |> String.to_charlist()
      |> :code.load_abs()
    end
  end
end
