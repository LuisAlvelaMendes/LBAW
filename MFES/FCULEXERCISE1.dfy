method odd ( n: nat ) returns (j:int)
    ensures j == 1 + 2 ∗ n
    ensures j > n
    ensures j % 2 == 1 // significa que j e impar, e a de cima ja garante isso
{
    var k := 0;
    j := 1;

    // I ^ not(C) => Q

    // I ^ k >= n => j == 1 + 2 * n

    while k < n
        invariant 0 <= k <= n;
        invariant j == 1+2*k;
        decreases n-k;
    {
        k := k + 1;
        j := j + 2;
    }
}