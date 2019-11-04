type T = int // for demo purposes, but could be another type
 
class {:autocontracts} Deque {
    // (Private) concrete state variables 
    const list: array<T>; // circular array, from list[start] (front) to list[(start+size-1) % list.Length] (back) 
    var start : nat; 
    var size : nat;
    ghost var elems: seq<T>;
    ghost const capacity: nat;

    predicate Valid(){
        0 <= size <= list.Length
      && 0<=start<list.Length
      && (elems == if start+size <= list.Length then list[start..start+size] else list[start..] + list[..size-(list.Length-start)])
      && capacity == list.Length 
    }
 
    constructor (capacity: nat) 
        requires capacity > 0
        ensures Valid() && this.elems == [] && this.capacity == capacity
    {
        list := new T[capacity];
        start := 0;
        size := 0;
        this.elems := [];
        this.capacity := capacity;
    }
 
    predicate method isEmpty() 
        requires Valid();
        ensures this.elems == [];
    {
        size == 0
    }
    
    predicate method isFull() 
        requires Valid();
        ensures Valid() && |this.elems| == this.capacity    
    {
        size == list.Length
    }
 
    function method front() : T 
        requires !isEmpty();
        ensures front() == this.elems[0]; 
    {
        list[start]
    }
 
    function method back() : T 
        requires !isEmpty();
        ensures back() == this.elems[|this.elems| - 1]
    {
        list[(start + size - 1) % list.Length] 
    }
    
    method push_back(x : T) 
        requires !isFull();
        ensures back() == x && this.elems == old(elems) + [x];
    {
        list[(start + size) % list.Length] := x;
        size := size + 1;
        elems := elems + [x];
    }
 
    method pop_back() 
        requires !isEmpty();
        ensures elems == old(elems[..|elems|-1]);
    {
        size := size - 1;
        elems := elems[..|elems|-1];
    }
 
    method push_front(x : T) {
        if start > 0 {
            start := start - 1;
        }
        else {
            start := list.Length - 1;
        }
        list[start] := x;
        size := size + 1;
    }    
 
    method pop_front() {
        if start + 1 < list.Length {
            start := start + 1;
        }
        else {
            start := 0;
        }
        size := size - 1;
    } 
}
 
// A simple test scenario.
method testDeque()
{
    var q := new Deque(3);
    assert q.isEmpty();
    q.push_front(1);
    assert q.front() == 1;
    assert q.back() == 1;
    q.push_front(2);
    assert q.front() == 2;
    assert q.back() == 1;
    q.push_back(3);
    assert q.front() == 2;
    assert q.back() == 3;
    assert q.isFull();
    q.pop_back();
    assert q.front() == 2;
    assert q.back() == 1;
    q.pop_front();
    assert q.front() == 1;
    assert q.back() == 1;
    q.pop_front();
    assert q.isEmpty();
}