defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        number: generate_random_number(10),
        score: 0,
        user: Pento.Accounts.get_user_by_session_token(session["user_token"]),
        session_id: session["live_socket_id"],
        time: time(),
        message: "Guess a number."
      )
    }
  end
  def render(assigns) do
    ~L"""
    <h1> Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
      It's <%= @time %>
    </h2>
    <button>Restart</button>
    <h2>
      <%= for n <- 1..10 do %>
      <a href= "#" phx-click="guess" phx-value-number="<%= n %>"><%= n %></a>
      <% end %>
    </h2>
    <pre>
      <%= @user.email %>
      <%= @session_id %>
    </pre>
    """


  end
  def generate_random_number(n) do
    Enum.random(1..n) |> Integer.to_string()

  end

  @spec time :: binary
  def time() do
    DateTime.utc_now |> to_string
  end

  def handle_event("guess", %{"number"=> guess}=_data, socket) do
    message = if guess == socket.assigns.number do
      " You got it Right !"
    else
      "Your Guess: #{guess}. Wrong. Guess again."
    end

    score = if guess == socket.assigns.number do
      socket.assigns.score + 1
    else
      socket.assigns.score - 1
    end

    time = time()
    {
      :noreply,
      assign(
        socket,
        message: message,
        time: time,
        score: score
      )
    }

  end
end
