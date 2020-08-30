defmodule DarkMatter.EnumsTest.TestEctoStruct do
  @moduledoc false
  defstruct [:id, :name, :__meta__]
end

defmodule DarkMatter.EnumsTest do
  @moduledoc """
  Test for DarkMatter.Enums
  """

  use ExUnit.Case, async: true

  alias __MODULE__.TestEctoStruct
  alias DarkMatter.Enums

  describe ".jsonify/1" do
    @cases [
      {nil, nil},
      {1, 1},
      {1.5, 1.5},
      {[], []},
      {%{}, %{}},
      {%{date: ~D[2020-01-01]}, %{date: "2020-01-01"}},
      {%{datetime: ~U[2020-05-14 21:01:03.007183Z]}, %{datetime: "2020-05-14T21:01:03.007183Z"}},
      {%{decimal_normal: Decimal.new("1.2345")}, %{decimal_normal: "1.2345"}},
      {%{decimal_scientific: Decimal.new("1e3")}, %{decimal_scientific: "1000"}},
      {%TestEctoStruct{}, %{id: nil, name: nil}},
      {%{nested: %TestEctoStruct{}}, %{nested: %{id: nil, name: nil}}},
      {{1, 2}, [1, 2]},
      {[{"a", "b"}, {:a, "b"}], %{:a => "b", "a" => "b"}},

      # NOTE: the case below inserts `1` at the `0` index
      {[{}, %{}, [1, abc: 23]], [[], %{}, [1, [:abc, 23]]]}
    ]
    for {given, expected} <- @cases do
      test "with #{inspect(given)} it returns #{inspect(expected)}" do
        assert Enums.jsonify(unquote(Macro.escape(given))) == unquote(Macro.escape(expected))
      end

      test "with #{inspect(given)} it is encodable" do
        assert {:ok, _} = Jason.encode(Enums.jsonify(unquote(Macro.escape(given))))
      end
    end
  end

  describe ".stringify/1" do
    @cases [
      {nil, nil},
      {1, 1},
      {1.5, 1.5},
      {[], []},
      {%{}, %{}},
      {%{date: ~D[2020-01-01]}, %{"date" => "2020-01-01"}},
      {%{datetime: ~U[2020-05-14 21:01:03.007183Z]},
       %{"datetime" => "2020-05-14T21:01:03.007183Z"}},
      {%{decimal_normal: Decimal.new("1.2345")}, %{"decimal_normal" => "1.2345"}},
      {%{decimal_scientific: Decimal.new("1e3")}, %{"decimal_scientific" => "1000"}},
      {%TestEctoStruct{}, %{"id" => nil, "name" => nil}},
      {%{nested: %TestEctoStruct{}}, %{"nested" => %{"id" => nil, "name" => nil}}},
      {{1, 2}, [1, 2]},

      # NOTE: Overwriting keys
      {[{"a", "a"}, {:a, "b"}], %{"a" => "a"}},

      # NOTE: the case below inserts `1` at the `0` index
      {[{}, %{}, [1, abc: 23]], [[], %{}, [1, ["abc", 23]]]}
    ]
    for {given, expected} <- @cases do
      test "with #{inspect(given)} it returns #{inspect(expected)}" do
        assert Enums.stringify(unquote(Macro.escape(given))) == unquote(Macro.escape(expected))
      end

      test "with #{inspect(given)} it is encodable" do
        assert {:ok, _} = Jason.encode(Enums.stringify(unquote(Macro.escape(given))))
      end
    end
  end
end
