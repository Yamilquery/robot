defmodule RobotTest do
  use ExUnit.Case, async: true
  doctest Robot
  alias Robot.Models.Point

  describe "Subscriptions" do
    test "Should receive `:robot_position_changed` when a subscriptor exists" do
      {:ok, pid} = Robot.start(self())

      Robot.move(pid, "URDL")

      Robot.stop(pid)

      assert_receive({:robot_position_changed, _position}, 100)
    end

    test "Shouldn't receive `:robot_position_changed` when a subscriptor doesnt exists" do
      {:ok, pid} = Robot.start()

      Robot.move(pid, "URDL")

      Robot.stop(pid)

      refute_receive({:robot_position_changed, _position}, 100)
    end
  end

  describe "Within limits" do
    test "Command `UUU` should return `%Point{x: 0, y: 3}`" do
      {:ok, pid} = Robot.start()

      Robot.move(pid, "UUU")

      assert Robot.get(pid) == %Point{x: 0, y: 3}

      Robot.stop(pid)
    end

    test "Command `RRRRRUUUUU` should return `%Point{x: 5, y: 5}`" do
      {:ok, pid} = Robot.start()

      Robot.move(pid, "RRRRRUUUUU")

      assert Robot.get(pid) == %Point{x: 5, y: 5}

      Robot.stop(pid)
    end

    test "Extend the bounds of the Robot and move it to the last position" do
      {:ok, pid} = Robot.start()

      Robot.setBounds(pid, {10, 10})

      Robot.move(pid, String.duplicate("U", 10))

      assert Robot.get(pid) == %Point{x: 0, y: 10, bounds: %{x: 10, y: 10}}

      Robot.stop(pid)
    end
  end

  describe "Out of limits" do
    test "Command `UUUDDDLLLRRRRRDDDDDDDD` should return `%Point{x: 2, y: -5}`" do
      {:ok, pid} = Robot.start()

      Robot.move(pid, "UUUDDDLLLRRRRRDDDDDDDD")

      assert Robot.get(pid) == %Point{x: 2, y: -5}

      Robot.stop(pid)
    end

    test "Command `UDDLLRUUUDUURUDDUULLDRRRR` should return `%Point{x: 2, y: 3}`" do
      {:ok, pid} = Robot.start()

      Robot.move(pid, "UDDLLRUUUDUURUDDUULLDRRRR")

      assert Robot.get(pid) == %Point{x: 2, y: 3}

      Robot.stop(pid)
    end

    test "Command `RRRRRRUUUUUU` should return `%Point{x: -5, y: -5}`" do
      {:ok, pid} = Robot.start()

      Robot.move(pid, "RRRRRRUUUUUU")

      assert Robot.get(pid) == %Point{x: -5, y: -5}

      Robot.stop(pid)
    end

    test "Extend the bounds of the Robot and move it to the last position plus one" do
      {:ok, pid} = Robot.start()

      Robot.setBounds(pid, {10, 10})

      Robot.move(pid, String.duplicate("U", 11))

      assert Robot.get(pid) == %Point{x: 0, y: -10, bounds: %{x: 10, y: 10}}

      Robot.stop(pid)
    end
  end

  describe "Another validations" do
    test "Command `1234` should return `%Point{x: 0, y: 0}`" do
      {:ok, pid} = Robot.start()

      Robot.move(pid, 1234)

      assert Robot.get(pid) == %Point{x: 0, y: 0}

      Robot.stop(pid)
    end

    test "Command `nil` should return `%Point{x: 0, y: 0}`" do
      {:ok, pid} = Robot.start()

      Robot.move(pid, nil)

      assert Robot.get(pid) == %Point{x: 0, y: 0}

      Robot.stop(pid)
    end

    # The maximum number of simultaneously alive Erlang processes is by default 262,144
    @tag :concurrency
    test "Should run 262,000 stream processes in parallel to test concurrency" do
      tasks = Task.async_stream(0..262_000, fn _ ->
        {:ok, pid} = Robot.start(self())

        Robot.move(pid, "RRR")
        Robot.move(pid, "UUU")
        Robot.move(pid, "RRR")
        Robot.move(pid, "UUU")
        Robot.move(pid, "R")
        Robot.move(pid, "U")

        point = Robot.get(pid)

        assert_receive({:robot_position_changed, _position}, 100)

        assert %Point{x: -4, y: -4, subscribers: _} = point
      end)
      |> Enum.into([], fn {:ok, res} -> res end)

      assert !Enum.member?(tasks, false)
    end
  end
end
