method squareRoot ( n: nat ) returns ( r: nat )
    ensures r ∗ r <= n < (r+1) ∗ (r+1)
{
    r := 0;
    var sqr := 1;

    //  I ^ (sqr > n) => r ∗ r <= n < ( r + 1 ) ∗ ( r + 1 )

    while sqr <= n
        invariant r < sqr;
        invariant r*r <= n;
        invariant sqr == (r+1) * (r+1);
        decreases n-sqr;
    {
        r := r + 1;
        sqr := sqr + 2 ∗ r + 1;
    }
}