defmodule Trending.Printer.DefaultRepoPrinter do
  def default_repo_printer(trends) do
    printer = fn(trend) ->
      IO.puts """
      Repository:   #{trend[:link]}
      Description:  #{trend[:desc]}
      Stars:        Total(#{trend[:stars][:total]}), Today(#{trend[:stars][:today]})
      """
    end

    Enum.each \
      trends,
      fn(trend) -> printer.(trend) end
  end
end
