defmodule Trending.Repo do
  def fetch_latest_repo_trend(url) do
    html = HTTPoison.get!(url).body

    repos =
      Floki.find(html, "div.explore-content > ol.repo-list")
      |> hd()
      |> elem(2)

    Enum.map \
      repos,
      fn(repo) -> get_repo_summary(repo) end
  end

  def get_repo_summary(repo) do
    repo = repo |> elem(2)
    link ="http://github.com" <> get_repo_link(repo)
    desc = get_repo_desc(repo)
    [total, today] = get_repo_stars(repo)

    %{link: link,
      desc: desc,
      stars: %{total: total, today: today}}
  end

  def get_repo_link(repo) do
    Enum.at(repo, 0)
    |> elem(2)
    |> hd()
    |> elem(2)
    |> hd()
    |> elem(1)
    |> hd()
    |> elem(1)
  end

  def get_repo_desc(repo) do
    get_desc = fn section ->
      cond do
        length(section) == 1 -> section |> hd()
        true ->
          cond do
            is_tuple(hd(section)) -> section |> tl() |> hd()
            true -> section |> hd()
          end
      end
    end

    section = Enum.at(repo, 2) |> elem(2) # section of repo's description

    case section do
      section when length(hd(section)) > 0 ->
        hd(section) |> elem(1) |> get_desc.() |> String.trim()
      _ -> "" # trending repo has no description
    end
  end

  def get_repo_stars(repo) do
    stars = Enum.at(repo, 3) |> elem(2)

    [total_pos, today_pos] =
      case length(stars) do
        7 -> [2, 6]
        6 -> [2, 6]
        _ -> [3, 4]
      end

    total = stars
    |> Enum.at(total_pos)
    |> elem(2)
    |> Enum.at(1)
    |> String.trim()
    |> (&Regex.scan(~r/^\d{1,3}(,\d{3})*(\.\d+)?/, &1)).()
    |> hd()
    |> hd()

    today =
      case Enum.at(stars, today_pos) do
        nil -> 0
          _ ->
              stars
              |> Enum.at(today_pos)
              |> elem(2)
              |> tl()
              |> hd()
              |> String.trim()
              |> (&Regex.scan(~r/^\d{1,3}(,\d{3})*(\.\d+)?/, &1)).()
              |> hd()
              |> hd()
      end

    [total, today]
  end
end
