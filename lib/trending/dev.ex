defmodule Trending.Dev do
  def fetch_latest_dev_trend(url) do
    html = HTTPoison.get!(url).body

    devs = Floki.find(html, "div.explore-content > ol.user-leaderboard-list") |> hd() |> elem(2)

    Enum.map \
      devs,
      fn(dev) -> get_dev_summary(dev |> elem(2)) end
  end

  def get_dev_summary(dev) do
    link = get_dev_link(Enum.at(dev, 1))
    full_name = get_dev_full_name(Enum.at(dev, 3))
    repo = get_dev_repo(Enum.at(dev, 3))

    %{link: link, full_name: full_name, repo: repo}
  end

  def get_dev_link(link) do
    link = elem(link, 1) |> hd() |> elem(1)
    "http://github.com" <> link
  end

  def get_dev_full_name(repo) do
    name = elem(repo, 2)
    |> Enum.at(0)
    |> elem(2)
    |> hd()
    |> elem(2)
    |> Enum.at(1)

    case name do
      nil -> nil
        _ ->
          name
          |> elem(2)
          |> hd()
          |> String.trim()
          |> String.replace(~r/^\(|\)$/, "")
    end
  end

  def get_dev_repo(repo) do
    repo_details = elem(repo, 2)

    [_, _, repo_name] = Enum.at(repo_details, 1)
    |> elem(1)
    |> Enum.at(0)
    |> elem(1)
    |> String.split("/")

    repo_name
  end
end
