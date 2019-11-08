method product (m: nat , n: nat ) returns ( res: nat )
    ensures res == m ∗ n;
{
    var m1: nat := m; res := 0;

    // I ^ (m1 == 0) => (res == m*n)

    while m1 != 0 
        invariant m >= 0;
        invariant n >= 0;
        invariant 0 <= m1 <= m;
        invariant res == (m - m1)*n; //e a diferenca entre m e m1, no inicio da 0 assim e confirma
        decreases m1;
    {
        var n1: nat := n ;

        while n1 != 0 
            invariant m1 != 0;
            invariant 0 <= n1 <= n;
            invariant res == (m - m1) * n + (n - n1); //tem este incremento cada vez que passa neste loop e vai fazendo n1 - 1
            decreases n1;
        {
            res := res + 1;
            n1 := n1 − 1;
        }

        m1 := m1 − 1;
    }
}
