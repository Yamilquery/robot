defmodule RobotTest do
  use ExUnit.Case, async: true
  doctest Robot
  alias Robot.Models.Point

  describe "Within limits" do
    test "Command `UUU` should return `%Point{x: 0, y: 3}`" do
      {:ok, pid} = Robot.new()
      Robot.move(pid, "UUU")
      assert Robot.get(pid) == %Point{x: 0, y: 3}
    end
    test "Command `RRRRRUUUUU` should return `%Point{x: 5, y: 5}`" do
      {:ok, pid} = Robot.new()
      Robot.move(pid, "RRRRRUUUUU")
      assert Robot.get(pid) == %Point{x: 5, y: 5}
    end
  end

  describe "Out of limits" do
    test "Command `UUUDDDLLLRRRRRDDDDDDDD` should return `%Point{x: 2, y: -5}`" do
      {:ok, pid} = Robot.new()
      Robot.move(pid, "UUUDDDLLLRRRRRDDDDDDDD")
      assert Robot.get(pid) == %Point{x: 2, y: -5}
    end

    test "Command `UDDLLRUUUDUURUDDUULLDRRRR` should return `%Point{x: 2, y: 3}`" do
      {:ok, pid} = Robot.new()
      Robot.move(pid, "UDDLLRUUUDUURUDDUULLDRRRR")
      assert Robot.get(pid) == %Point{x: 2, y: 3}
    end
    test "Command `RRRRRRUUUUUU` should return `%Point{x: -5, y: -5}`" do
      {:ok, pid} = Robot.new()
      Robot.move(pid, "RRRRRRUUUUUU")
      assert Robot.get(pid) == %Point{x: -5, y: -5}
    end
  end

  describe "Another validations" do
    test "Command `1234` should return `%Point{x: 0, y: 0}`" do
      {:ok, pid} = Robot.new()
      Robot.move(pid, 1234)
      assert Robot.get(pid) == %Point{x: 0, y: 0}
    end

    test "Command `nil` should return `%Point{x: 0, y: 0}`" do
      {:ok, pid} = Robot.new()
      Robot.move(pid, nil)
      assert Robot.get(pid) == %Point{x: 0, y: 0}
    end

    # The maximum number of simultaneously alive Erlang processes is by default 262,144
    test "Should run 262,000 stream processes in parallel to test concurrency" do
      tasks = Task.async_stream(0..262_000, fn _ ->
        {:ok, pid} = Robot.new()
        Robot.move(pid, "RRR")
        Robot.move(pid, "UUU")
        Robot.move(pid, "RRR")
        Robot.move(pid, "UUU")
        Robot.move(pid, "R")
        Robot.move(pid, "U")
        assert Robot.get(pid) == %Point{x: -4, y: -4}
      end)
      |> Enum.into([], fn {:ok, res} -> res end)

      assert !Enum.member?(tasks, false)
    end
  end
end
