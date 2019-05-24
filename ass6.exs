defmodule IdC do
    defstruct [:s]
end

defmodule NumC do
    defstruct [:n]
end

defmodule Main do
    def interp(exp = %_{}, env = %{}) do
        case exp do
            %IdC{s: s} ->
                IO.puts s
            %NumC{n: n} ->
                IO.puts n
        end
    end

    def main do
        interp(%IdC{s: :a}, %{})
        interp(%NumC{n: 1}, %{})
    end
end

Main.main