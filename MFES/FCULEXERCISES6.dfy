method p rodu ct (m: nat , n: i n t ) re turns ( p: i n t )
ensures p == m ∗ n ;
{
var i : nat := m;
p := 0;
while ( i != 0 ) {
p := p + n ;
i := i − 1;
}
}