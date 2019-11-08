method bina r ySea r ch ( a: array <in t > , value: int ) returns ( index: int )
requires a != n ull && 0 <= a . Length ;
requires f o r a l l j , k : : 0 <= j < k < a . Length =⇒ a [ j ] <= a [ k ] ;
ensures 0 <= inde x =⇒ inde x < a . Length && a [ inde x ] == value ;
ensures inde x < 0 =⇒ f o r a l l k : : 0 <= k < a . Length =⇒ a [ k ] != value ;
{
var low , high := 0 , a . Length ;
while low < high
i n v a ri a n t 0 <= low <= high <= a . Length ;
i n v a ri a n t f o r a l l i : : 0 <= i < a . Length && ! ( low <= i < high ) =⇒ a [ i ] != value ;
{
var mid := ( low + high ) / 2;
i f a [ mid ] < value {
low := mid ;
}
else i f value < a [ mid ] {
high := mid − 1;
}
else {
re tu rn mid ;
}
}
r