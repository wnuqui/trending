defmodule Trending.Printer.DefaultDevPrinter do
  def default_dev_printer(trends) do
    printer = fn(trend) ->
      IO.puts """
      Developer:    #{trend[:link]}
      Full Name:    #{trend[:full_name]}
      Popular Repo: #{trend[:link]}/#{trend[:repo]}
      """
    end

    Enum.each \
      trends,
      fn(trend) -> printer.(trend) end
  end
end
