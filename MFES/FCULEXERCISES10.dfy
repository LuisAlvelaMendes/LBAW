method find (a : array <int>, key : int) returns ( index : int )
    ensures 0 <= index <= a.Length;
    ensures index < a.Length ==> a[index] == key;
{
    index := 0;

    assert 0 <= index <= a.Length; // I

    while index < a.Length && a[index] != key 
        invariant 0 <= index <= a.Length;
        decreases a.Length - index;
    {
        ghost var Vzero := a.Length - index;
        assert index < a.Length && 0 <= index <= a.Length && a.Length - index == Vzero; //C ^ I ^ V=Vzero
        index := index + 1;
        assert 0 <= index <= a.Length && 0 <= a.Length - index < Vzero; // I ^ 0 <= V < Vzero
    }

    assert index < a.Length ==> a[index] == key; //Q
}