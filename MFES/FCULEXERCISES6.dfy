method product (m: nat , n: int ) returns ( p: int )
    ensures p == m ∗ n ;
{
    var i : nat := m;
    p := 0;

    while ( i != 0 )
        invariant 0<= i <= m;
        invariant p == (m - i) * n; 
        decreases i;
    {
        p := p + n ;
        i := i − 1;
    }
}