function powerOfTwo (n: nat) : nat
    decreases n;
{
    if n == 0 then 1 else 2*powerOfTwo(n-1) 
}

method power ( n: nat ) returns ( j : nat )
    ensures j == powerOfTwo(n);
{
    var k := 0;
    j := 1;

    while k < n
        invariant k <= n;
        invariant j == powerOfTwo(k);
        decreases n-k;
    {
        k := k + 1;
        j := 2 ∗ j ;
    }
}
