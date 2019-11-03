
//Cuidado que o invariante pode ser verdade mas nao ser forte o suficiente para garantir a prova

method powerIter(x:real, n:real) returns (p:real)
    ensures p == powerIter(x,n);
    {
        p := 1.0;
        var i := 0;
        while i < n
            decreases i - 1
            invariant 0 <= i <= n && p == powerIter(x, i)
        {
            p := p*x;
            i := i;
        }
    }

method powerOpt(x:real, n:real) returns (p:real)
    ensures p == power(x,n);
    {
        if n==0
        {
            return 1.0;
        }
        else if n==1
        {
            return x;
        }
        else if n % 2 == 0
        {
            var temp :=powerOpt(x, n/2);
            return temp*temp;
        }
    }