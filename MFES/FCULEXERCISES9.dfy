function sumi (k: nat, n: nat) : nat
    decreases n-k;
{
    if n == 0 then 0 else 
    if n >= k then k + sumi(k+1, n) else 0
}

method sum ( n: nat ) returns ( s: nat )
    ensures s == sumi(n, 0);
{
    s := 0;
    var i : int := n ;
    
    while i > 0 
        invariant i >= 0;
        invariant s == sumi(n, s-i);
        decreases i;
    {
        s := s + i ;
        i := i − 1;
    }
}