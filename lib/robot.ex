defmodule Robot do
  @moduledoc false

  alias Robot.Models.Point

  @limit 5

  ## API

  @doc """
    Initialize a Robot process
  """
  @spec new() :: {:ok, pid()}
  def new, do: Agent.start_link(fn -> %Point{} end)

  @doc """
    Move the robot to the desired location according to the given commands.
  """
  @spec move(pid(), String.t()) :: :ok
  def move(pid, command) when is_binary(command) do
    :ok = command
    |> split_command()
    |> update_movement(pid)
  end
  def move(_pid, _command), do: :ok

  @doc """
    Get the current location of the Robot.
  """
  @spec get(pid()) :: %Point{}
  def get(pid), do: Agent.get(pid, &(&1))

  ## private helpers

  defp update_movement(["U" | tail], pid) do
    Agent.update(pid, &(Map.put(&1, :y, (Map.get(&1, :y) + 1) |> adjust_point())))
    update_movement(tail, pid)
  end
  defp update_movement(["D" | tail], pid) do
    Agent.update(pid, &(Map.put(&1, :y, (Map.get(&1, :y) - 1) |> adjust_point())))
    update_movement(tail, pid)
  end
  defp update_movement(["L" | tail], pid) do
    Agent.update(pid, &(Map.put(&1, :x, (Map.get(&1, :x) - 1) |> adjust_point())))
    update_movement(tail, pid)
  end
  defp update_movement(["R" | tail], pid) do
    Agent.update(pid, &(Map.put(&1, :x, (Map.get(&1, :x) + 1) |> adjust_point())))
    update_movement(tail, pid)
  end
  defp update_movement(_, _pid), do: :ok

  defp adjust_point(value) when (value >= (@limit * -1) and value <= @limit), do: value
  defp adjust_point(_value), do: (@limit * -1)

  defp split_command(command), do: String.split(command, "", trim: true)
end
