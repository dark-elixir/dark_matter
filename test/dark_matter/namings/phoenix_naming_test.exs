defmodule DarkMatter.Namings.PhoenixNamingTest do
  @moduledoc """
  Test for `DarkMatter.Namings.PhoenixNaming`.
  """

  use ExUnit.Case, async: true
  alias DarkMatter.Namings.PhoenixNaming

  doctest PhoenixNaming

  test "underscore/1 converts Strings to underscore" do
    assert PhoenixNaming.underscore("FooBar") == "foo_bar"
    assert PhoenixNaming.underscore("Foobar") == "foobar"
    assert PhoenixNaming.underscore("APIWorld") == "api_world"
    assert PhoenixNaming.underscore("ErlangVM") == "erlang_vm"
    assert PhoenixNaming.underscore("API.V1.User") == "api/v1/user"
    assert PhoenixNaming.underscore("") == ""
    assert PhoenixNaming.underscore("FooBar1") == "foo_bar1"
    assert PhoenixNaming.underscore("fooBar1") == "foo_bar1"
  end

  test "camelize/1 converts Strings to camel case" do
    assert PhoenixNaming.camelize("foo_bar") == "FooBar"
    assert PhoenixNaming.camelize("foo__bar") == "FooBar"
    assert PhoenixNaming.camelize("foobar") == "Foobar"
    assert PhoenixNaming.camelize("_foobar") == "Foobar"
    assert PhoenixNaming.camelize("__foobar") == "Foobar"
    assert PhoenixNaming.camelize("_FooBar") == "FooBar"
    assert PhoenixNaming.camelize("foobar_") == "Foobar"
    assert PhoenixNaming.camelize("foobar_1") == "Foobar1"
    assert PhoenixNaming.camelize("") == ""
    assert PhoenixNaming.camelize("_foo_bar") == "FooBar"
    assert PhoenixNaming.camelize("foo_bar_1") == "FooBar1"
  end

  test "camelize/2 converts Strings to lower camel case" do
    assert PhoenixNaming.camelize("foo_bar", :lower) == "fooBar"
    assert PhoenixNaming.camelize("foo__bar", :lower) == "fooBar"
    assert PhoenixNaming.camelize("foobar", :lower) == "foobar"
    assert PhoenixNaming.camelize("_foobar", :lower) == "foobar"
    assert PhoenixNaming.camelize("__foobar", :lower) == "foobar"
    assert PhoenixNaming.camelize("_FooBar", :lower) == "fooBar"
    assert PhoenixNaming.camelize("foobar_", :lower) == "foobar"
    assert PhoenixNaming.camelize("foobar_1", :lower) == "foobar1"
    assert PhoenixNaming.camelize("", :lower) == ""
    assert PhoenixNaming.camelize("_foo_bar", :lower) == "fooBar"
    assert PhoenixNaming.camelize("foo_bar_1", :lower) == "fooBar1"
  end
end
