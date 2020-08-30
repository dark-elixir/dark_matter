defmodule DarkMatter.MapsTest do
  @moduledoc """
  Test for DarkMatter.Maps
  """

  use ExUnit.Case, async: true
  doctest DarkMatter.Maps, import: true

  alias DarkMatter.Maps

  describe ".compact/1" do
    test "with struct" do
      params = %URI{}
      assert Maps.compact(params) == %{}
    end

    test "with empty map" do
      params = %{}
      assert Maps.compact(params) == %{}
    end

    test "with nil valued string map" do
      params = %{"empty" => nil}
      assert Maps.compact(params) == %{}
    end

    test "with nil valued atom map" do
      params = %{empty: nil}
      assert Maps.compact(params) == %{}
    end
  end

  describe ".access_in/2" do
    test "given a valid :acc and atom key" do
      acc = %{key: :valid}
      key = :key
      assert Maps.access_in(acc, key) == :valid
    end

    test "given a valid :acc and string key" do
      acc = %{"key" => :valid}
      key = "key"
      assert Maps.access_in(acc, key) == :valid
    end

    test "given a valid :acc and keys with atom keys" do
      acc = %{key1: %{key2: :valid}}
      keys = [:key1, :key2]
      assert Maps.access_in(acc, keys) == :valid
    end

    test "given a valid :acc and keys with atom and string keys" do
      acc = %{key1: %{"key2" => :valid}}
      keys = [:key1, "key2"]
      assert Maps.access_in(acc, keys) == :valid
    end
  end

  describe ".sorted_keys/1" do
    test "given an empty map" do
      map = %{}
      assert Maps.sorted_keys(map) == []
    end

    test "given a valid :map with atom keys" do
      map = %{key: :atom}
      assert Maps.sorted_keys(map) == [:key]
    end

    test "given a valid :map with string keys" do
      map = %{"key" => :string}
      assert Maps.sorted_keys(map) == ["key"]
    end

    test "given a valid :map with atom and string keys" do
      map = %{:key1 => :atom, "key2" => :string}
      assert Maps.sorted_keys(map) == [:key1, "key2"]
    end

    test "given a valid :map with atom keys and sortable" do
      map = %{c: :atom, a: :atom, b: :atom}
      assert Maps.sorted_keys(map) == [:a, :b, :c]
    end
  end
end
