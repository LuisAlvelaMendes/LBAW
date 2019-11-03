// Checks if array 'a' is sorted.
predicate isSorted(a: array<int>)
  reads a
{
    forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
}

// Finds a value 'x' in a sorted array 'a', and returns its index,
// or -1 if not found. 
method binarySearch(a: array<int>, x: int) returns (index: int)
    requires isSorted(a)
    ensures -1 <= index < a.Length
    ensures 0 <= index < a.Length ==> a[index] == x
    ensures index == -1 ==> (forall i:: 0 <= i < a.Length ==> a[i] != x)
{   
    var low, high := 0, a.Length;
    while low < high 
        decreases high - low
        invariant 0 <= low <= high <= a.Length
        invariant isSorted(a)
        invariant forall i:: 0 <= i < low ==> a[i] < x //se uma posicao for menor que low, o resultado do a[index] sera inferior ao valor desejado, pela ordem do array
        invariant forall i:: high <= i < a.Length ==> a[i] > x // se uma posicao for maior que high, o resultado do a[index] sera superior ao valor
    {
        var mid := low + (high - low) / 2;
        if 
        {
            case a[mid]  < x => low := mid + 1;
            case a[mid]  > x => high := mid;
            case a[mid] == x => return mid;
        }
    }
    return -1;
}

// Checks if array 'a' is sorted between positions 'from' (inclusive) and 'to' (exclusive).
predicate sorted(a: array<int>, from: nat, to: nat)
  requires 0 <= from <= to <= a.Length
  reads a
{
    forall i, j :: from <= i < j < to ==> a[i] <= a[j] 
}

// Sorts array 'a' using the insertion sort algorithm.
method insertionSort(a: array<int>)
    modifies a
    ensures isSorted(a)
    ensures multiset(a[..]) == multiset(old(a[..]))
{
    var i := 0;
    while i < a.Length 
        // nota: uma boa maneira de calcular a variante e sabendo que com base em C, condicao do ciclo, tem-se
        // v > 0
        // a.Length > i (=) a.Length - i > 0
        // calculo feito, logo, decreases a.Length - i
        decreases a.Length - i
        invariant 0 <= i <= a.Length
        // sabe-se que no final do ciclo, i == a.Length, logo, na expressao do sorting
        // podemos entao substituir na definicao do sorted o a.Length por i
        invariant forall m, n :: 0 <= m < n < i ==> a[m] <= a[n]
        invariant multiset(a[..]) == multiset(old(a[..]))
    {
        var j := i;
        while j > 0 && a[j-1] > a[j]
            // no ciclo interior do insertion sort vai-se rodando os elementos do array ordenando
            // vai-se inserir o novo elemento na posicao correta do array ordenado
            decreases j
            invariant 0 <= j <= i
            // invariant forall m, n :: 0 <= m < n < j ==> a[m] <= a[n]
            // invariant forall m, n :: j < m < n < i ==> a[m] >= a[n]
            
            // tem que se garantir que todos os pares differentes de m,n 0, i e j estao garantidos menos aqueles que ja se garantiu
            invariant forall m, n :: 0 <= m < n < i+1 && n !=j ==> a[m] <= a[n]
            invariant multiset(a[..]) == multiset(old(a[..]))
        {
            a[j-1], a[j] := a[j], a[j-1];
            j := j - 1;
        }

        i := i + 1;

        // quando se sai do ciclo, tendo calculado o novo elemento, obtem-se que
        // Q: forall m, n :: 0 <= m < n < i+1 ==> a[m] <= a[n]
        // I ^ not(C) => Q
        // not(C): j <= 0 || a[j-1] <= a[j]
    }
}
