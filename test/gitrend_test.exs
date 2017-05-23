defmodule TrendingTest do
  use ExUnit.Case

  import Trending, only: [compose_url: 1]

  describe "compose_url" do
    test "--repo switch" do
      actual = compose_url [repo: true]
      expected = "https://github.com/trending"
      assert actual == expected
    end

    test "--dev switch" do
      actual = compose_url [dev: true]
      expected = "https://github.com/trending/developers"
      assert actual == expected
    end

    test "--dev and lang switches" do
      actual = compose_url [dev: true, lang: "elixir"]
      expected = "https://github.com/trending/developers/elixir"
      assert actual == expected
    end

    test "all switches" do
      actual = compose_url [dev: true, lang: "elixir", since: "daily"]
      expected = "https://github.com/trending/developers/elixir?since=daily"
      assert actual == expected
    end
  end
end
