function fib(n : nat ) : nat
  decreases n
{
    if n < 2 then n else fib(n - 2) + fib(n - 1)
}

method computeFib (n : nat) returns (x : nat)
    requires n >= 0;
    ensures x == fib(n);
{
    var i := 0;
    x := 0;
    var y := 1;

    //P=>I
    assert i <= n;
    assert i >= 0;
    assert y == fib(i+1);
    assert x == fib(i);

    while  i < n 
        invariant i <= n 
        invariant i >= 0 
        // pela logica do loop, y = fib(i-1) + fib(i), sendo que
        // y vai tomando os valores anteriores na iteracao de i devido a x
        // e depois a isso soma-se o da iteracao atual
        // por substituicao fib(i-1) + fib(i) = fib(n-2) + fib(n-1)
        // para isso, i = n-1
        // logo, n = i+1
        // assim sendo, y == fib(i+1), isto para usarmos ambos os ramos da funcao fib ao mesmo tempo!
        invariant y == fib(i+1)
        invariant x == fib(i)
        decreases n - i
    {
        ghost var Vzero := n - i;
        //falta I && C
        assert n - i == Vzero;
        x, y := y, x + y; // multiple assignment
        i := i + 1;

        // falta aqui a invariante
        assert n - i >= 0 && n - i < Vzero;
    }

    assert x == fib(n);
}

function method fact(n: nat) : nat
  decreases n
{
    if n == 0 then 1 else n * fact(n-1)
}
method factIter(n: nat) returns (f : nat)
    requires n>=0;
    ensures f == fact(n);
{
  f := 1;
  var i := 0;
  while i < n 
    invariant i <= n
    invariant i >= 0
    invariant f >= 0
    invariant f == fact(i)
    decreases n - i
  {
    i := i + 1;
    f := f * i;
  }
}