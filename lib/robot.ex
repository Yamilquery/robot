defmodule Robot do
  @moduledoc """
    Given a robot which can only move in four directions, UP(U), DOWN(D), LEFT(L), RIGHT(R).

    Given a string consisting of instructions to move. Output the coordinates of a robot
    after executing the instructions. Initial position of robot is at origin(0, 0).

    If the robot exceeds the established limits it will travel to the negative limit of
    the maximum position.

    The maximum position by default is set to 5, but it can be changed.
    For more details, see `Robot.setBounds/2`.
  """

  @robot_position_changed_payload :robot_position_changed

  alias Robot.Models.Point

  ## API

  @doc """
  Initialize a Robot process.

  Returns `{:ok, #PID<0.162.0>}`.

  ## Examples

      iex> {:ok, _pid} = Robot.start()

  """
  @spec start(pid()) :: {:ok, pid()}
  def start(caller), do: Agent.start_link(fn -> %Point{subscribers: [caller]} end)
  def start(), do: Agent.start_link(fn -> %Point{} end)

  @doc """
  Stop a Robot process.

  Returns `:ok`.

  ## Examples

      iex> {:ok, pid} = Robot.start()
      iex> :ok = Robot.stop(pid)
      :ok

  """
  @spec stop(pid()) :: :ok
  def stop(pid), do: Agent.stop(pid)

  @doc """
  Change the Robot bounds by a given tuple `{x, y}`.

  Returns `:ok`.

  ## Examples

      iex> {:ok, pid} = Robot.start()
      iex> :ok = Robot.setBounds(pid, {10, 10})
      :ok

  """
  @spec setBounds(pid(), tuple()) :: :ok
  def setBounds(pid, {x, y}), do: Agent.update(pid, &(Map.put(&1, :bounds, %{x: x, y: y})))

  @doc """
  Move the Robot to the desired location according to the given commands.

  Returns `:ok`.

  ## Examples

      iex> {:ok, pid} = Robot.start()
      iex> Robot.move(pid, "UUUDR")
      :ok

  """
  @spec move(pid(), String.t()) :: :ok
  def move(pid, command) when is_binary(command) do
    :ok =
      command
      |> split_command()
      |> update_movement(pid)
  end
  def move(_pid, _command), do: :ok

  @doc """
  Get the current position of the Robot.

  Returns `%Robot.Models.Point{}`.

  ## Examples

      iex> {:ok, pid} = Robot.start()
      iex> Robot.get(pid)
      %Robot.Models.Point{x: 0, y: 0}

  """
  @spec get(pid()) :: %Point{}
  def get(pid), do: Agent.get(pid, &(&1))


  ## private helpers

  defp update_movement(["U" | tail], pid) do
    Agent.update(pid, &(Map.put(&1, :y, (&1.y + 1) |> adjust_point(&1.bounds.y))))

    pid |> get() |> send_message_robot_moved()

    update_movement(tail, pid)
  end
  defp update_movement(["D" | tail], pid) do
    Agent.update(pid, &(Map.put(&1, :y, (&1.y - 1) |> adjust_point(&1.bounds.y))))

    pid |> get() |> send_message_robot_moved()

    update_movement(tail, pid)
  end
  defp update_movement(["L" | tail], pid) do
    Agent.update(pid, &(Map.put(&1, :x, (&1.x - 1) |> adjust_point(&1.bounds.x))))

    pid |> get() |> send_message_robot_moved()

    update_movement(tail, pid)
  end
  defp update_movement(["R" | tail], pid) do
    Agent.update(pid, &(Map.put(&1, :x, (&1.x + 1) |> adjust_point(&1.bounds.x))))

    pid |> get() |> send_message_robot_moved()

    update_movement(tail, pid)
  end
  defp update_movement(_, _pid), do: :ok

  defp adjust_point(value, bounds) when (value >= (bounds * -1) and value <= bounds), do: value
  defp adjust_point(_value, bounds), do: (bounds * -1)

  defp split_command(command), do: String.split(command, "", trim: true)

  defp send_message_robot_moved(%Point{subscribers: []}), do: :ok
  defp send_message_robot_moved(%Point{subscribers: subscribers, x: x, y: y}) do
    for pid <- subscribers, do: send(pid, {@robot_position_changed_payload, %{x: x, y: y}})
    :ok
  end
end
