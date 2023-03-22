defmodule AppWeb.SearchLive do
  @moduledoc """
  A LiveView for searching.
  """

  use AppWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <p>Search</p>
    """
  end
end
