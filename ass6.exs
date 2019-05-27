defmodule IdC do
    defstruct [:s]
end
defmodule NumC do
    defstruct [:n]
end

defmodule StringC do
    defstruct [:str]
end

defmodule IfC do
    defstruct [:test, :th, :el]
end

defmodule AppC do
    defstruct [:fun, :args]
end

defmodule LamC do
    defstruct [:param, :body]
end

defmodule BoolV do
    defstruct [:b]
end

defmodule PrimV do
    defstruct [:p]
end

defmodule ClosV do
    defstruct [:param, :body, :env]
end

defmodule Main do
    def interp(exp = %_{}, env = %{}) do
        case exp do
            %IdC{s: s} ->
                IO.puts s
            %NumC{n: n} ->
                IO.puts n
	    %StringC{str: str} ->
		IO.puts str
        end
    end

    def main do
        interp(%IdC{s: :a}, %{})
        interp(%NumC{n: 1}, %{})
        interp(%StringC{str: "test"}, %{})
    end
end

Main.main
