method product (m: nat , n: int ) returns ( p: int )
    ensures p == m ∗ n ;
{
    var i : nat := m;
    p := 0;

    while ( i != 0 )
        invariant 0<= i <= m;
        invariant m == 0 || n == 0 ==> p == 0;
        invariant m == 0 ==> i == 0;
        invariant i < 0 && m != 0 && n != 0 ==> p == m * n; 
        decreases i;
    {
        p := p + n ;
        i := i − 1;
    }
}