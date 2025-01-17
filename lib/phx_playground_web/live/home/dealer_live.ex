defmodule PhxPlaygroundWeb.DealerLive do
  use PhxPlaygroundWeb, :live_view

  alias PhxPlaygroundWeb.DealerSelect
  alias PhxPlaygroundWeb.CarSelect

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.live_component id="dealer-select" module={DealerSelect} on_selected_dealer={&set_dealer/1} />
      <.live_component id="car-select" module={CarSelect} dealer="" />
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  defp set_dealer(dealer) do
    send_update(CarSelect, id: "car-select", dealer: dealer)
  end
end
