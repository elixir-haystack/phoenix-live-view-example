defmodule App.Articles.Search do
  @moduledoc """
  A module for configuring Haystack search.
  """

  alias App.Articles
  alias Haystack.{Index, Storage}

  @doc """
  Return the Haystack.
  """
  def haystack do
    Haystack.index(Haystack.new(), :articles, fn index ->
      index
      |> Index.ref(Index.Field.term("id"))
      |> Index.field(Index.Field.new("name"))
      |> Index.field(Index.Field.new("body"))
      |> Index.storage(storage())
    end)
  end

  @doc """
  Return the storage.
  """
  def storage do
    Storage.ETS.new(name: :articles, table: :articles, load: &load/0)
  end

  @doc """
  Load the storage.
  """
  def load do
    Task.Supervisor.start_child(App.TaskSupervisor, fn ->
      Haystack.index(haystack(), :articles, fn index ->
        Articles.articles()
        |> Stream.map(&Map.take(&1, ~w{id name body}a))
        |> Enum.each(&Haystack.Index.add(index, [&1]))

        index
      end)
    end)

    []
  end

  @doc """
  Perform a search.
  """
  def search(q) do
    Haystack.index(haystack(), :articles, fn index ->
      Index.search(index, q)
    end)
  end
end
