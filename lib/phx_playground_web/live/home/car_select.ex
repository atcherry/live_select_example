defmodule PhxPlaygroundWeb.CarSelect do
  @moduledoc false
  use PhxPlaygroundWeb, :live_component

  import LiveSelect

  alias PhxPlayground.CarForm

  attr(:id, :string, required: true)

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id}>
      <.form id={"#{@id}-form"} for={@form} phx-change="dealer-car-selected" phx-submit="submit" phx-auto-recover="recover" phx-target={@myself}>
        <.input type="hidden" field={@form[:dealer]} name="dealer" />
        <.inputs_for :let={car} field={@form[:cars]}>
          <label>{car[:make].value}</label>
          <.live_select
            id={"car-select-#{car[:make].value}"}
            field={car[:model]}
            placeholder="Search"
            update_min_len={0}
            phx-target={@myself} />
        </.inputs_for>
        <.button type="submit">Submit</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    IO.inspect("Car Select mount")
    dealers = %{
      "dave" => %{
        "dealer" => "dave",
        "cars" => %{
          "0" => %{"make" => "mazda", "model" => "cx5"},
          "1" => %{"make" => "tesla", "model" => "roadster"},
          "2" => %{"make" => "ford", "model" => "focus"}
        }
      },
      "matt" => %{
        "dealer" => "matt",
        "cars" => %{
          "0" => %{"make" => "tesla", "model" => "cybertruck"}
        }
      },
      "tony" => %{
        "dealer" => "tony",
        "cars" => %{
          "0" => %{"make" => "ford", "model" => "fiesta"},
          "1" => %{"make" => "mazda", "model" => "cx30"}
        }
      }
    }
    socket =
      socket
      |> assign(:options, %{
        "mazda" => [:cx5, :cx50, :cx9, :cx30],
        "tesla" => [:roadster, :cybertruck, :plaid],
        "ford" => [:f150, :focus, :fiesta]
      })
      |> assign(:dealers, dealers)
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    IO.inspect(assigns, label: "CarSelect Assigns")
    dealer_initial = socket.assigns.dealers[assigns.dealer] || %{}
    socket =
      socket
      |> assign(assigns)
      |> assign(:form, %CarForm{} |> CarForm.changeset(dealer_initial) |> to_form())

    update_live_select(dealer_initial, socket.assigns.options)

    {:ok, socket}
  end

  @impl true
  def handle_event("dealer-car-selected", %{"car_form" => %{"cars" => cars}}, socket) do
    dealer = socket.assigns.dealers[socket.assigns.dealer]
    changes =
      %{dealer | "cars" => Map.new(dealer["cars"], fn {idx, car} ->
        {idx, %{car | "model" => cars[idx]["model"]}}
      end)}
    socket =
      socket
      |> assign(:form, %CarForm{} |> CarForm.changeset(changes) |> to_form())

    {:noreply, socket}
  end

  def handle_event("recover", %{"car_form" => %{"cars" => cars}, "dealer" => dealer}, socket) do
    # dealer = params["car_form"]["dealer"]
    # cars = params["car_form"]["cars"]
    # dbg()
    dealer_initial = socket.assigns.dealers[dealer]
    changes =
      %{dealer_initial | "cars" => Map.new(dealer_initial["cars"], fn {idx, car} ->
        {idx, %{car | "model" => cars[idx]["model"]}}
      end)}

    IO.inspect(changes, label: "Car Select recovery")
    socket =
      socket
      |> assign(:dealer, dealer)
      |> assign(:form, %CarForm{} |> CarForm.changeset(changes) |> to_form())

    update_live_select(dealer_initial, socket.assigns.options)

    {:noreply, socket}
  end

  def handle_event("submit", form, socket) do
    IO.inspect(form, label: "Submit")
    {:noreply, socket}
  end

  defp update_live_select(dealer, models) do
    Enum.each(dealer["cars"] || %{}, fn {_idx, car} ->
      send_update(LiveSelect.Component, id: "car-select-#{car["make"]}", options: models[car["make"]])
    end)
  end
end
