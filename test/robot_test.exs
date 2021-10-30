defmodule RobotTest do
  use ExUnit.Case, async: true
  doctest Robot
  alias Robot.Models.Point

  describe "within limits" do
    test "Command `UUU` should return `%Point{x: 0, y: 3}`" do
      {:ok, pid} = Robot.new()
      Robot.move(pid, "UUU")
      assert Robot.get(pid) == %Point{x: 0, y: 3}
    end
  end

  describe "out of limits" do
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
  end

  describe "another validations" do
    test "Command `1234` should return `%Point{x: 0, y: 0}`" do
      {:ok, pid} = Robot.new()
      Robot.move(pid, "1234")
      assert Robot.get(pid) == %Point{x: 0, y: 0}
    end

    test "Command `nil` should return `%Point{x: 0, y: 0}`" do
      {:ok, pid} = Robot.new()
      Robot.move(pid, nil)
      assert Robot.get(pid) == %Point{x: 0, y: 0}
    end
  end
end
