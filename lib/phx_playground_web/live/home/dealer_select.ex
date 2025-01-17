defmodule PhxPlaygroundWeb.DealerSelect do
  @moduledoc false
  use PhxPlaygroundWeb, :live_component

  attr(:id, :string, required: true)
  attr(:on_select_dealer, :any, required: true)

  def render(assigns) do
    ~H"""
    <div id={@id}>
      <.form for={@form} id={"#{@id}-form"} phx-change="dealer-selected" phx-auto-recover="recover" phx-target={@myself}>
        <.input field={@form[:dealer]} type="select" name="dealer-selection" prompt="Select Dealer" options={@options} />
      </.form>
    </div>
    """
  end
        # <.input type="hidden" field={@form[:dealer]} name="dealer" />

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:options, [:dave, :matt, :tony])
      |> assign(:form, to_form(%{"dealer" => ""}))
    {:ok, socket}
  end

  @impl true
  def handle_event("dealer-selected", selection, socket) do
    socket.assigns.on_selected_dealer.(selection["dealer-selection"])
    socket = assign(socket, :form, to_form(%{"dealer" => selection["dealer-selection"]}))
    {:noreply, socket}
  end

  def handle_event("recover", params, socket) do
    socket = assign(socket, :form, to_form(%{"dealer" => params["dealer-selection"]}))
    {:noreply, socket}
  end

  # def handle_event("recover", params, socket) do
  #   IO.inspect(params, label: "DealerSelect recovery")
  #   socket.assigns.on_selected_dealer.(params["dealer-selection"])
  #   {:noreply, socket}
  # end
end
