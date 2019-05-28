ExUnit.start()

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

defmodule StringV do
    defstruct [:str]
end

defmodule NumV do
    defstruct [:n]
end

defmodule Main do
    # exp: expression
    # env: environment
    # returns: expression
    def interp(exp, env) do
        case exp do
            %IdC{s: s} ->
                env[s]
            %NumC{n: n} ->
                %NumV{n: n}
            %StringC{str: str} ->
                %StringV{str: str}
            %IfC{test: test, th: th, el: el} ->
                case interp(test, env) do
                    %BoolV{b: b} ->
                        if b do
                            interp(th, env)
                        else
                            interp(el, env)
                        end
                end
            %LamC{param: param, body: body} ->
                %ClosV{param: param, body: body, env: env}
            %AppC{fun: fun, args: args} ->
                case interp(fun, env) do
                    %PrimV{p: p} ->
                        IO.puts "TODO: prim handler"
                    %ClosV{param: param, body: body, env: env2} ->
                        args_eval = Enum.map(args, fn arg -> interp(arg, env) end)
                        interp(body, extend_env(env2, param, args_eval))
                end
        end
    end

    # env: environment
    # symbols: list of symbols
    # values: list of values
    # returns: environment
    def extend_env(env, symbols, values) do
        List.foldl(Enum.zip(symbols, values), env,
            fn kv, acc ->
                Map.put(acc, elem(kv, 0), elem(kv, 1))
            end)
    end

    def main do
        interp(%AppC{fun: %LamC{param: [:x, :y], body: %IdC{s: :y}}, args: [%NumC{n: 1}, %NumC{n: 2}]}, %{})
    end
end

defmodule Tests do
    use ExUnit.Case

    test "interp" do
        result = Main.interp(%AppC{fun: %LamC{param: [:x, :y], body: %IdC{s: :y}}, args: [%NumC{n: 1}, %NumC{n: 2}]}, %{})
        assert result == %NumV{n: 2}
    end

    test "extend_env" do
        result = Main.extend_env(%{a: %NumV{n: 0}}, [:b, :c, :d], [%NumV{n: 1}, %NumV{n: 2}, %NumV{n: 3}])
        assert result == %{a: %NumV{n: 0}, b: %NumV{n: 1}, c: %NumV{n: 2}, d: %NumV{n: 3}}
    end
end

Main.main
