defmodule Trending.CLITest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  import ExUnit.CaptureIO
  import Trending.CLI

  describe "help message" do
    test "prints help message using --help" do
      assert capture_io(fn ->
        Trending.CLI.main(["--help"])
      end) == help_message() <> "\n"
    end
  end

  describe "trending" do
    test "prints git trend results" do
      use_cassette "trending/repo" do
        trends = capture_io(fn ->
          Trending.CLI.main(["--repo", "--lang=elixir"])
        end)

        assert Regex.match?(~r/Repository/, trends)
        assert Regex.match?(~r/Description/, trends)
        assert Regex.match?(~r/Stars/, trends)
      end
    end
  end

  describe "is_help" do
    test "returns true" do
      args = ["--help"]
      options = OptionParser.parse(args, strict: switches())
      assert is_help(options)
    end

    test "returns true when `--help` is with additional switches" do
      args = ["--repo", "--dev", "--help"]
      options = OptionParser.parse(args, strict: switches())
      assert is_help(options)
    end
  end

  describe "is_valid" do
    test "returns true with `--repo` switch" do
      args = ["--repo"]
      options = OptionParser.parse(args, strict: switches())
      assert is_valid(options)
    end

    test "returns true with `--dev` switch" do
      args = ["--dev"]
      options = OptionParser.parse(args, strict: switches())
      assert is_valid(options)
    end

    test "returns true with `--lang=x` switch" do
      args = ["--lang=elixir"]
      options = OptionParser.parse(args, strict: switches())
      assert is_valid(options)
    end

    test "returns true with `--since=x` switch" do
      args = ["--since=daily"]
      options = OptionParser.parse(args, strict: switches())
      assert is_valid(options)
    end

    test "returns true for `--help` switch" do
      args = ["--help"]
      options = OptionParser.parse(args, strict: switches())
      assert is_valid(options)
    end

    test "returns true for `--version` switch" do
      args = ["--version"]
      options = OptionParser.parse(args, strict: switches())
      assert is_valid(options)
    end
  end

  describe "aliases" do
    test "returns true with `-r` switch" do
      args = ["-r"]
      options = OptionParser.parse(args, strict: switches(), aliases: aliases())
      assert is_valid(options)
    end

    test "returns true with `-d` switch" do
      args = ["-d"]
      options = OptionParser.parse(args, strict: switches(), aliases: aliases())
      assert is_valid(options)
    end

    test "returns true with `-l x` switch" do
      args = ["-l elixir"]
      options = OptionParser.parse(args, strict: switches(), aliases: aliases())
      assert is_valid(options)
    end

    test "returns true with `-s x` switch" do
      args = ["-s daily"]
      options = OptionParser.parse(args, strict: switches(), aliases: aliases())
      assert is_valid(options)
    end
  end
end
