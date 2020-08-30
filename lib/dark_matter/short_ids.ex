defmodule DarkMatter.ShortIds do
  @moduledoc """
  Generates a unique `short_id` for use in abreviated non-uuid id aliases.

  The alphabet is truncated based on the reasoning found here:
  https://fiznool.com/blog/2014/11/16/short-id-generation-in-javascript/
  """
  @moduledoc since: "1.0.0"

  @type options() :: [
          {:alphabet, binary()}
          | {:salt, binary()}
          | {:min_len, pos_integer()}
        ]

  @type key() :: pos_integer()
  @type keys() :: [pos_integer()]
  @type cipher() :: String.t()

  @default_options [
    alphabet: "ABDEGJKMNPQRVWXYZ23456789",
    min_len: 3
  ]

  @doc """
  Encodes a given `cipher` to a unique short-id

    ## Examples

      iex> encode(5)
      "NY6"

      iex> encode([5, 38, 12345])
      "RZJRXKW936"
  """
  @spec encode(key() | keys(), options()) :: cipher()
  def encode(key, opts \\ @default_options) when is_integer(key) or is_list(key) do
    opts
    |> Hashids.new()
    |> Hashids.encode(key)
  end

  @doc """
  Decodes a given `key` from a unique short-id

    ## Examples

      iex> decode("NY6")
      {:ok, [5]}
  """
  @spec decode(cipher(), options()) :: {:ok, keys()} | :error
  def decode(cipher, opts \\ @default_options) when is_binary(cipher) do
    opts
    |> Hashids.new()
    |> Hashids.decode(cipher)
    |> case do
      {:ok, keys} when is_list(keys) -> {:ok, keys}
      {:error, :invalid_input_data} -> :error
    end
  end

  @doc """
  Handles parsing the response

    ## Examples

      iex> decode_singular_cipher("NY6")
      {:ok, 5}

      iex> decode_singular_cipher("")
      :error

      iex> decode_singular_cipher("RZJRXKW936")
      :error
  """
  @spec decode_singular_cipher(cipher(), options()) :: {:ok, key()} | :error
  def decode_singular_cipher(cipher, opts \\ @default_options) when is_binary(cipher) do
    case decode(cipher, opts) do
      {:ok, [id]} -> {:ok, id}
      {:ok, ids} when is_list(ids) -> :error
      _ -> :error
    end
  end

  @doc """
  Handles parsing the response and raising an error in the event of failure

    ## Examples

      iex> decode_singular_cipher!("NY6")
      5

      iex> decode_singular_cipher!("")
      ** (ArgumentError) ShortIds: invalid cipher: #{inspect("")}
  """
  @spec decode_singular_cipher!(cipher()) :: key()
  def decode_singular_cipher!(cipher) when is_binary(cipher) do
    case decode_singular_cipher(cipher) do
      {:ok, id} -> id
      :error -> raise ArgumentError, "ShortIds: invalid cipher: #{inspect(cipher)}"
    end
  end
end
