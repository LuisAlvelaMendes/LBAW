function fib(n : nat ) : nat
  decreases n
{
    if n < 2 then n else fib(n - 2) + fib(n - 1)
}

method computeFib (n : nat) returns (x : nat)
    requires n >= 0;
    ensures x == fib(n);
{
    assert n >= 0; // P

    // WP(i := 0, ..)
    assert (0 <= n) && (0 >= 0) && (1 == fib(0+1)) && (0 == fib(0));
    var i := 0;

    // WP (x := 0, ..)
    assert (i <= n) && (i >= 0) && (1 == fib(i+1)) && (0 == fib(i));
    x := 0;

    // WP (y := 1, I)
    assert (i <= n) && (i >= 0) && (1 == fib(i+1)) && (x == fib(i));
    var y := 1;

    //I: (i <= n) && (i >= 0) && (y == fib(i+1)) && (x == fib(i))
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
        // C ^ I ^ V=V0
        assert n - i == Vzero && (i < n) && (i <= n) && (i >= 0) && (y == fib(i+1)) && (x == fib(i));
       
        //WP(x, y := y, x + y, (a))
        assert (i+1 <= n) && (i+1 >= 0) && (x+y == fib(i+2)) && (y == fib(i+1)) && 0 <= n - (i+1) < Vzero;
        x, y := y, x + y; // multiple assignment
        
        //WP(i := i + 1; I ^ 0 <= V <= V0) (a)
        assert (i+1 <= n) && (i+1 >= 0) && (y == fib(i+2)) && (x == fib(i+1)) && 0 <= n - (i+1) < Vzero;
        i := i + 1;

        // I ^ 0 <= V <= V0
        assert (i <= n) && (i >= 0) && (y == fib(i+1)) && (x == fib(i)) && 0 <= n - i < Vzero;
    }

    // not(C) ^ I
    assert (i >= n) && (i <= n) && (i >= 0) && (y == fib(i+1)) && (x == fib(i));
    // Q
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
  // P
  assert n>=0;

  f := 1;
  var i := 0;

  // I 
  assert i <= n && i >= 0 && f >= 0 && f == fact(i);

  while i < n 
    invariant i <= n
    invariant i >= 0
    invariant f >= 0
    invariant f == fact(i)
    decreases n - i
  {
    // C ^ I ^ V = V0
    ghost var Vzero := n - i;
    assert i < n && i <= n && i >= 0 && f >= 0 && f == fact(i) && n - i == Vzero;

    i := i + 1;
    f := f * i;

    // I ^ 0 <= V < V0
    assert i <= n && i >= 0 && f >= 0 && f == fact(i) && 0 <= n-i < Vzero;
  }

  // not(C) && I
  assert i >= n && i <= n && i >= 0 && f >= 0 && f == fact(i);
  assert f == fact(n);
}