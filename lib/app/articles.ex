defmodule App.Articles do
  @moduledoc """
  A module for managing articles.
  """

  alias App.Articles.Article

  use NimblePublisher,
    build: Article,
    from: Application.app_dir(:app, "priv/articles/*.md"),
    as: :articles

  @articles @articles
         |> Enum.reverse()
         |> Enum.with_index(1)
         |> Enum.map(fn {post, id} -> Map.put(post, :id, to_string(id)) end)

  def articles, do: @articles

  def take(ids) do
    Enum.map(ids, fn id ->
      Enum.find(articles(), & &1.id == id)
    end)
  end
end
