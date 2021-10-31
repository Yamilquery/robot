# [Robot](https://github.com/Yamilquery/robot/blob/master/lib/robot.ex#L1)

Given a robot which can only move in four directions, UP(U), DOWN(D), LEFT(L), RIGHT(R).

Given a string consisting of instructions to move. Output the coordinates of a robot after executing the instructions. Initial position of robot is at origin(0, 0).

If the robot exceeds the established limits it will travel to the negative limit of the maximum position.

The maximum position by default is set to 5, but it can be changed. For more details, see [`Robot.setBounds/2`](https://hexdocs.pm/robot/0.1.0/Robot.html#setBounds/2).

# [Summary](https://hexdocs.pm/robot/0.1.0/Robot.html#summary)

## [Functions](https://hexdocs.pm/robot/0.1.0/Robot.html#functions)

[get(pid)](https://hexdocs.pm/robot/0.1.0/Robot.html#get/1)

Get the current position of the Robot.

[move(pid, command)](https://hexdocs.pm/robot/0.1.0/Robot.html#move/2)

Move the Robot to the desired location according to the given commands.

[setBounds(pid, arg)](https://hexdocs.pm/robot/0.1.0/Robot.html#setBounds/2)

Change the Robot bounds by a given tuple `{x, y}`.

[start()](https://hexdocs.pm/robot/0.1.0/Robot.html#start/0)

Initialize a Robot process.

[stop(pid)](https://hexdocs.pm/robot/0.1.0/Robot.html#stop/1)

Stop a Robot process.

# [Functions](https://hexdocs.pm/robot/0.1.0/Robot.html#functions)

[Link to this function](https://hexdocs.pm/robot/0.1.0/Robot.html#get/1)

# get(pid)

[View Source](https://github.com/Yamilquery/robot/blob/master/lib/robot.ex#L96)

## Specs

```
get(pid()) :: %Robot.Models.Point{bounds: term(), x: term(), y: term()}
```

Get the current position of the Robot.

Returns `%Robot.Models.Point{}`.

##  Examples

```
iex> {:ok, pid} = Robot.start()
iex> Robot.get(pid)
%Robot.Models.Point{x: 0, y: 0}
```

[Link to this function](https://hexdocs.pm/robot/0.1.0/Robot.html#move/2)

# move(pid, command)

[View Source](https://github.com/Yamilquery/robot/blob/master/lib/robot.ex#L75)

## Specs

```
move(pid(), String.t()) :: :ok
```

Move the Robot to the desired location according to the given commands.

Returns `:ok`.

##  Examples

```
iex> {:ok, pid} = Robot.start()
iex> Robot.move(pid, "UUUDR")
:ok
```

[Link to this function](https://hexdocs.pm/robot/0.1.0/Robot.html#setBounds/2)

# setBounds(pid, arg)

[View Source](https://github.com/Yamilquery/robot/blob/master/lib/robot.ex#L60)

## Specs

```
setBounds(pid(), tuple()) :: :ok
```

Change the Robot bounds by a given tuple `{x, y}`.

Returns `:ok`.

##  Examples

```
iex> {:ok, pid} = Robot.start()
iex> :ok = Robot.setBounds(pid, {10, 10})
:ok
```

[Link to this function](https://hexdocs.pm/robot/0.1.0/Robot.html#start/0)

# start()

[View Source](https://github.com/Yamilquery/robot/blob/master/lib/robot.ex#L30)

## Specs

```
start() :: {:ok, pid()}
```

Initialize a Robot process.

Returns `{:ok, #PID<0.162.0>}`.

##  Examples

```
iex> {:ok, _pid} = Robot.start()
```

[Link to this function](https://hexdocs.pm/robot/0.1.0/Robot.html#stop/1)

# stop(pid)

[View Source](https://github.com/Yamilquery/robot/blob/master/lib/robot.ex#L45)

## Specs

```
stop(pid()) :: :ok
```

Stop a Robot process.

Returns `:ok`.

##  Examples

```
iex> {:ok, pid} = Robot.start()
iex> :ok = Robot.stop(pid)
:ok
```
# Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `robot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:robot, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/robot](https://hexdocs.pm/robot).

# Test

To test without concurrency tests, use the following command:

```elixir
  mix test
```


To test with concurrency tests, run:

```elixir
  mix test --include concurrency
```

# Author

Yamil Díaz Aguirre

https://github.com/Yamilquery

yamilquery@gmail.com