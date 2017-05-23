defmodule Trending do
  import Trending.{Repo, Dev}

  def get_latest(options) do
    url = compose_url(options)
    cond do
      is_option_included(options, :repo) ->
        fetch_latest_repo_trend(url)
      is_option_included(options, :dev) ->
        fetch_latest_dev_trend(url)
      true ->
        fetch_latest_repo_trend(url)
    end
  end

  @base_url "https://github.com/trending"
  def compose_url(options) do
    url = @base_url

    url =
      if is_option_included(options, :repo) do
        url
      else
        if is_option_included(options, :dev) do
          url <> "/developers"
        else
          url
        end
      end

    url =
      if is_option_included(options, :lang) do
        {:ok, lang} = Keyword.fetch(options, :lang)
        url <> "/" <> lang
      else
        url
      end

    url =
      if is_option_included(options, :since) do
        {:ok, since} = Keyword.fetch(options, :since)
        url <> "?since=" <> since
      else
        url
      end

    url
  end

  def is_option_included(options, switch) do
    case Keyword.fetch(options, switch) do
      {:ok, _} -> true
      :error -> false
    end
  end
end
