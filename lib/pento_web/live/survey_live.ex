defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias Pento.{Catalog, Accounts, Survey}

  @impl true
  # we grab the token from the session arguement
  # px.gen.auth built the code that generated a secure token to the session,
  # session is availabel to any alive_view as the second argument in the mount function
  # we use the token so we can fetch a user


  def mount(_params, %{"user_token" => token} = _session, socket) do
    {:ok,
    socket
    |> assign_user(token)
    |> assign_demographic()
    |> assign_products()
  }
  end

  def assign_products(%{assigns: %{current_user: current_user}}=socket) do
    assign(socket, :products, list_products(current_user))
  end

  defp list_products(user) do
    Catalog.list_products_with_user_ratings(user)
  end

  def assign_demographic(%{assigns: %{current_user: current_user}}= socket ) do
    assign(socket, :demographic, Survey.get_demographic_by_user(current_user))
  end
  def assign_user(socket, token)do
    IO.puts "Assign User with socket.private:"
    IO.inspect socket.private
    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(token)
    end)
  end

  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

  def handle_info({:created_rating, updated_product, product_index}, socket) do
    {:noreply, handle_rating_created(socket, updated_product, product_index)}
  end

  def handle_rating_created(
    %{assigns: %{products: products}}= socket, updated_product, product_index
  )do
    socket
    |> put_flash(:info, "Rating, submitted successfully")
    |> assign(:products, List.replace_at(products, product_index, updated_product))
  end

  def handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created Successfully")
    |> assign(:demographic, demographic)
  end
end
