method divide ( x : nat , y : nat ) returns ( q : nat , r : nat )
    requires y > 0;
    ensures q ∗ y + r == x && r >= 0 && r < y ;
{
    q := 0;
    r := x ;

    // I ^ r < y ==> q ∗ y + r == x && r >= 0 && r < y 

    while r >= y 
        invariant q ∗ y + r == x && r >= 0; 
        decreases r;
    {
        r := r − y ;
        q := q + 1;
    }
}