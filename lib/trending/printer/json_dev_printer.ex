defmodule Trending.Printer.JsonDevPrinter do
  def json_dev_printer(trends) do
    IO.puts Poison.encode!(%{developers: trends})
  end
end
