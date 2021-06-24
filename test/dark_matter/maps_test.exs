defmodule DarkMatter.MapsTest do
  @moduledoc """
  Test for DarkMatter.Maps
  """

  use ExUnit.Case, async: true
  doctest DarkMatter.Maps, import: true

  alias DarkMatter.Maps

  @atom_keyed_map %{atom_key: :atom_val, nested_atom: %{nested_atom_2: :nested_atom_val}}
  @mixed_keyed_map %{atom_key: "string_val", nested_atom: %{"nested_atom_2" => "mixed"}}
  @string_keyed_map %{"string_key" => "string_val", "nested" => %{"nested2" => "nested3"}}

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

  describe ".iget/2" do
    test "with valid map and atom key" do
      assert Maps.iget(@atom_keyed_map, :atom_key) == :atom_val
    end

    test "with valid map and string key" do
      assert Maps.iget(@string_keyed_map, :string_key) == "string_val"
    end

    test "with valid map and atom keys" do
      assert Maps.iget(@atom_keyed_map, [:nested_atom, :nested_atom_2]) == :nested_atom_val
    end

    test "with valid map and string keys" do
      assert Maps.iget(@string_keyed_map, [:nested, :nested2]) == "nested3"
    end

    test "with valid map and mixed keys" do
      assert Maps.iget(@mixed_keyed_map, [:nested_atom, :nested_atom_2]) == "mixed"
    end

    test "with nil map it raises" do
      assert_raise FunctionClauseError,
                   "no function clause matching in DarkMatter.Maps.iget/2",
                   fn ->
                     Maps.iget(nil, :any)
                   end
    end

    test "with valid map and string key accessor" do
      assert_raise FunctionClauseError, fn ->
        assert Maps.iget(%{}, "string_key")
      end
    end

    test "with valid map and empty list accessor" do
      assert_raise FunctionClauseError, fn ->
        Maps.iget(%{}, [])
      end
    end
  end

  describe ".iget/3" do
    test "with valid map and default" do
      assert Maps.iget(%{}, :missing, "found") == "found"
    end

    test "with valid map and partial success and default" do
      assert Maps.iget(%{found: %{none: :none}}, [:found, :any], "found") == "found"
    end

    test "with valid map and empty list accessor" do
      assert_raise FunctionClauseError, fn ->
        Maps.iget(%{}, [], :default)
      end
    end
  end
end
