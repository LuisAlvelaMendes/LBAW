method product (m: nat , n: nat ) returns ( res: nat )
    ensures res == m ∗ n;
{
    var m1: nat := m; res := 0;

    // I ^ (m1 == 0) => (res == m*n)

    while m1 != 0 
        invariant m >= 0;
        invariant n >= 0;
        invariant m1 <= m;
        invariant m1 < 0 && m != 0 && n != 0 ==> res == m*n;
        decreases m1;
    {
        var n1: nat := n ;

        while n1 != 0 
            invariant m1 != 0;
            invariant n1 <= n;
            invariant m1 == 0 ==> res == 0;
            decreases n1;
        {
            res := res + 1;
            n1 := n1 − 1;
        }

        m1 := m1 − 1;
    }
}
