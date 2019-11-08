function sumi (k: int, n: int) : int
    requires k <= n;
{
    if k == 0
    then (n * (n + 1)) / 2
    else (n * (n + 1) - (k - 1) * k) / 2
}

method sum ( n: nat ) returns ( s: nat )
    ensures s == sumi(0, n);
{
    s := 0;
    var i : int := n ;
    
    while i > 0 
        invariant 0 <= i <= n;
        invariant s == sumi(i, n) - i;
        decreases i;
    {
        s := s + i ;
        i := i − 1;
    }
}