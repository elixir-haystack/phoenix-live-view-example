defmodule AppWeb.SearchLive do
  @moduledoc """
  A LiveView for searching.
  """

  use AppWeb, :live_view

  import Phoenix.HTML.Form

  alias App.Articles

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:q, nil)
      |> assign(:articles, [])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl mt-20 flex flex-col space-y-8 bg-white p-8 shadow-sm">
      <.form :let={f} for={%{}} as={:search} phx-change="search" phx-submit="search">
        <%= search_input(f, :q, value: @q, placeholder: "Search...", autofocus: true, class: "w-full border border-gray-100 text-2xl active:border-0 active:border-gray-200 focus:border-gray-200 focus:ring-0 bg-gray-50") %>
      </.form>
      <div class="flex flex-col space-y-8">
        <div :for={article <- @articles} class="flex flex-col space-y-1">
          <h2 class="text-2xl font-medium text-gray-900">
            <%= article.name %>
          </h2>
          <%= raw(article.body) %>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("search", %{"search" => %{"q" => q}}, socket) do
    articles =
      q
      |> Articles.Search.search()
      |> Enum.map(& &1.ref)
      |> Articles.take()

    {:noreply, assign(socket, :articles, articles)}
  end
end
