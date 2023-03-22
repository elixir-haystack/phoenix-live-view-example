defmodule App.Articles.Article do
  @moduledoc """
  A module for articles.
  """

  defstruct ~w{id slug name body}a

  def build(filename, attrs, body) do
    slug = filename |> Path.rootname() |> Path.split() |> List.last()

    struct!(__MODULE__, Map.to_list(attrs) ++ [slug: slug, body: body])
  end
end
