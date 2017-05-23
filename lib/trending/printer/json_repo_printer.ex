defmodule Trending.Printer.JsonRepoPrinter do
  def json_repo_printer(trends) do
    IO.puts Poison.encode!(%{repositories: trends})
  end
end
