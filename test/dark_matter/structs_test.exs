defmodule StructWithDefaults do
  @moduledoc false
  defstruct string: "string1", integer: 1, boolean: false
end

defmodule StructWithSomeDefaults do
  @moduledoc false
  defstruct [:empty, string: "string2", integer: 2, boolean: true]
end

defmodule StructWithSomeDefaultsAndMeta do
  @moduledoc false
  defstruct [:empty, :_metalike_, __meta__: %{}, string: "string3", integer: 3, boolean: true]
end

defmodule StructWithoutDefaults do
  @moduledoc false
  defstruct [:key1, :key2]
end

defmodule DarkMatter.StructsTest do
  @moduledoc """
  Test for `DarkMatter.Structs`
  """

  use ExUnit.Case, async: true
  doctest DarkMatter.Structs, import: true

  alias DarkMatter.Structs

  describe ".defaults/1" do
    test "given a struct with defaults" do
      assert Structs.defaults(StructWithDefaults) == %{
               string: "string1",
               integer: 1,
               boolean: false
             }
    end

    test "given a struct with some defaults" do
      assert Structs.defaults(StructWithSomeDefaults) == %{
               string: "string2",
               integer: 2,
               boolean: true
             }
    end

    test "given a struct some defaults and meta keys" do
      assert Structs.defaults(StructWithSomeDefaultsAndMeta) == %{
               string: "string3",
               integer: 3,
               boolean: true
             }
    end

    test "given a struct without defaults" do
      assert Structs.defaults(StructWithoutDefaults) == %{}
    end
  end
end
