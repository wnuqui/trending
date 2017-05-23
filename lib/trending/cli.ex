defmodule Trending.CLI do
  import Trending, only: [is_option_included: 2]

  alias Trending.Printer.{DefaultDevPrinter, JsonDevPrinter, DefaultRepoPrinter, JsonRepoPrinter}

  @switches [
    repo: :boolean,
    r: :boolean,
    dev: :boolean,
    d: :boolean,
    lang: :string,
    l: :string,
    since: :string,
    s: :string,
    json: :boolean,
    j: :boolean,
    help: :boolean,
    h: :boolean,
    version: :boolean,
    v: :boolean
  ]

  @aliases [
    r: :repo,
    d: :dev,
    l: :lang,
    s: :since,
    j: :json,
    h: :help,
    v: :version
  ]

  @help_message """
  Usage:
  trending --lang [options]

  Options:
    -v, --version         Display the version number
    -h, --help            Display this
    -r, --repo            List trending Github repositories
    -d, --dev             List trending Github developers
    -l, --lang            Filter trend using a programming language
    -s, --since           Filter trend since
    -j, --json            Print trend results in JSON format

  Description:
  CLI to see what the GitHub community is most excited about today.
  """

  @version "0.1.0"

  def main(args) do
    args |> parse_args
  end

  def do_process({options, [], []}) do
    trends = Trending.get_latest options

    cond do
      is_option_included(options, :dev) ->
        print_dev_results(options, trends)
      is_option_included(options, :repo) ->
        print_repo_results(options, trends)
      true ->
        print_repo_results(options, trends)
    end
  end

  def print_dev_results(options, trends) do
    printer =
      cond do
        is_option_included(options, :json) ->
          &JsonDevPrinter.json_dev_printer/1
        true ->
          &DefaultDevPrinter.default_dev_printer/1
      end

    printer.(trends)
  end

  def print_repo_results(options, trends) do
    printer =
      cond do
        is_option_included(options, :json) ->
          &JsonRepoPrinter.json_repo_printer/1
        true ->
          &DefaultRepoPrinter.default_repo_printer/1
      end

    printer.(trends)
  end

  def do_process(:help), do: IO.puts(@help_message)

  def do_process(:version), do: IO.puts("Trending version " <> @version)

  defp parse_args(args) do
    options = OptionParser.parse(args, strict: @switches, aliases: @aliases)

    cond do
      is_help(options) ->  do_process(:help)
      is_version(options) ->  do_process(:version)
      is_valid(options) -> do_process(options)
      true -> :help
    end
  end

  def is_help(options) do
    filter_fn = fn(option) ->
      case Keyword.fetch(option, :help) do
        {:ok, _} -> true
        :error -> false
      end
    end
    Enum.filter(Tuple.to_list(options), filter_fn) |> Enum.empty?() |> Kernel.!()
  end

  def is_version(options) do
    filter_fn = fn(option) ->
      case Keyword.fetch(option, :version) do
        {:ok, _} -> true
        :error -> false
      end
    end
    Enum.filter(Tuple.to_list(options), filter_fn) |> Enum.empty?() |> Kernel.!()
  end

  def is_valid(options) do
    {parsed, _, _} = options
    Enum.empty?(parsed) |> Kernel.!()
  end

  def switches, do: @switches

  def aliases, do: @aliases

  def help_message, do: @help_message
end
