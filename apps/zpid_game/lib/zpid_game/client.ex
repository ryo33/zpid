defmodule Zpid.Game.Client do
  use Zpid.Client

  import Zpid.EventDispatcher, only: [listen: 1, dispatch: 1]
  alias Zpid.Display.Container
  alias Zpid.Display.Object.Updating
  alias Zpid.Display.Object.ContainerState
  alias Zpid.Game.Player

  @offset_x 800
  @offset_y 800

  @impl true
  def start_link(client_id) do
    GenServer.start_link(__MODULE__, client_id)
  end

  def init(client_id) do
    player_id = Zpid.ID.gen
    listen(Updating.for_object(player_id))
    container_id = Zpid.ID.gen
    container_state = %ContainerState{
      scale_x: 160,
      scale_y: 160,
      x: @offset_x,
      y: @offset_y
    }
    Container.start_link(container_id, client_id, container_state)
    Player.start_link(player_id, client_id, container_id)
    state = %{container_id: container_id}
    {:ok, state}
  end

  def handle_info(%Updating{state: player_state}, state) do
    walk = player_state.walk
    dispatch(Container.update(state.container_id, fn state ->
      %ContainerState{
        state |
        x: @offset_x,
        y: @offset_y,
        origin_x: walk.x,
        origin_y: walk.y,
        rotation: -walk.rotation - :math.pi/2
      }
    end))
    {:noreply, state}
  end
end
