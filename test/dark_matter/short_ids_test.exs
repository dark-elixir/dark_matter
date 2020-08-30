defmodule DarkMatter.ShortIdsTest do
  @moduledoc """
  Test for DarkMatter.ShortIds
  """

  use ExUnit.Case, async: true
  doctest DarkMatter.ShortIds, import: true

  alias DarkMatter.ShortIds

  @cases %{
    singlar: %{
      "PRX" => {1, [1]},
      "3WY" => {123, [123]},
      "Q9QZ" => {2345, [2345]}
    },
    compound: %{
      "2XRXEWBXY9" => [1235, 1, 235]
    }
  }

  describe ".encode/1" do
    for {cipher, {key, keys}} <- @cases.singlar do
      test "with #{inspect(key)} expect #{inspect(cipher)}" do
        assert ShortIds.encode(unquote(key)) == unquote(cipher)
      end

      test "with #{inspect(keys)} expect #{inspect(cipher)}" do
        assert ShortIds.encode(unquote(keys)) == unquote(cipher)
      end
    end

    for {cipher, keys} <- @cases.compound do
      test "with #{inspect(keys)} expect #{inspect(cipher)}" do
        assert ShortIds.encode(unquote(keys)) == unquote(cipher)
      end
    end
  end

  describe ".decode/1" do
    for {cipher, {_key, keys}} <- @cases.singlar do
      test "with #{inspect(cipher)} expect {:ok, #{inspect(keys)}}" do
        assert ShortIds.decode(unquote(cipher)) == {:ok, unquote(keys)}
      end
    end

    for {cipher, keys} <- @cases.compound do
      test "with #{inspect(cipher)} expect {:ok, #{inspect(keys)}}" do
        assert ShortIds.decode(unquote(cipher)) == {:ok, unquote(keys)}
      end
    end
  end

  describe ".decode_singular_cipher/1" do
    for {cipher, {key, keys}} <- @cases.singlar do
      test "with #{inspect(cipher)} expect {:ok, #{inspect(keys)}}" do
        assert ShortIds.decode_singular_cipher(unquote(cipher)) == {:ok, unquote(key)}
      end
    end

    for {cipher, keys} <- @cases.compound do
      test "with #{inspect(cipher)} expect #{inspect(keys)}" do
        assert ShortIds.decode_singular_cipher(unquote(cipher)) == :error
      end
    end
  end

  describe ".decode_singular_cipher!/1" do
    for {cipher, {key, keys}} <- @cases.singlar do
      test "with #{inspect(cipher)} expect #{inspect(keys)}" do
        assert ShortIds.decode_singular_cipher!(unquote(cipher)) == unquote(key)
      end
    end

    for {cipher, _keys} <- @cases.compound do
      test "with #{inspect(cipher)} expect ArgumentError" do
        assert_raise ArgumentError,
                     "ShortIds: invalid cipher: #{inspect(unquote(cipher))}",
                     fn ->
                       ShortIds.decode_singular_cipher!(unquote(cipher))
                     end
      end
    end
  end
end
