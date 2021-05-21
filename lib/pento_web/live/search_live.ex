defmodule PentoWeb.SearchLive do
  use PentoWeb, :live_view
  alias Pento.Search
  alias Pento.Search.Item

  def mount(_params, _session, socket)do
    {:ok,
    socket
    |>assign_item()
    |>assign_changeset()
  }
  end

  def assign_item(socket) do
    socket
    |> assign(:item, %Item{})
  end

  def assign_changeset(%{assigns: %{item: item}} = socket)do
    socket
    |> assign(:changeset, Search.search_sku_number(item))
  end

  def handle_event(
    "search", %{"item" => item_params},
    %{assigns: %{item: item}} = socket) do
      changeset =
      item
      |> Search.search_sku_number(item_params)
      |> Map.put(:action, :validate)
      {:noreply, socket
    |> assign(:changeset, changeset)
    }
    end


end
