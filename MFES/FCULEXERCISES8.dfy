function sumNat ( n: nat) : nat
{
    if n == 0 then 0 else (n*(n-1))/2
}

method sum ( n: nat ) returns ( s: nat )
    ensures s == sumNat(n+1);
{
    s := 0;
    var i := 0;

    while i < n 
        invariant 0 <= i <= n;
        invariant s >= i;
        invariant n == 0 ==> s == 0;
        invariant s == sumNat(i+1);
        decreases n - i;
    {
        i := i + 1;
        s := s + i ;
    }
}
