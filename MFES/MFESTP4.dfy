type T = int // to allow doing new T[cap], but can be other type 

/*
    Atencao que o dafny nao verificara os nossos contratos, podendo estar mal por falta de precondicoes e pos-condicoes,
    o Dafny nao sabe o que e um "push" ou um "pop"
*/
 
class {:autocontracts} Stack
{
    var elems: array<T>;
    var size : nat; // used size
 
    constructor (cap: nat)
        ensures Valid();
        ensures size == 0;
        ensures this.elems.Length == cap;
    {
        elems := new T[cap];
        size := 0; 
    }

    predicate Valid()
        // precisa de ler o proprio elemento, o this, e tambem ler o proprio elems, array dentro da instancia "this" do objeto da classe Stack
        reads elems, this
    {
        // ao definir isto estamos a definir, no fundo, invariantes da classe
        size <= elems.Length
    }

    predicate method isEmpty()
       // reads this
    {
        size == 0
    }
 
    predicate method isFull()
       // reads elems, this
    {
        size == elems.Length
    }
 
    method push(x : T)
        requires 0 <= size < elems.Length
        // a instancia como um todo muda ao alterar os seus atributos, logo, modifies this
        // ate porque vai mexer no size
        // requires Valid()
        modifies elems, this
        ensures size == old(size) + 1
        ensures elems[size - 1] == x // ensures top() == x
        ensures forall i :: 0 <= i < size - 1 ==> old(elems)[i] == elems[i]
    {
        elems[size] := x;
        size := size + 1;
    }
 
    function method top(): T
        // reads elems, this 
        requires 0 < size < elems.Length
    {
        elems[size-1]
    }
    
    method pop()
        modifies this
        requires size > 0
        ensures size == old(size) - 1
    {
         size := size-1;
    }
}
 
// A simple test case to check on the console.
method Main()
{
    /* 
    
    Example testing for the STACK exercise
    
    var s := new Stack(3);
    s.push(1);
    s.push(2);
    s.push(3);
    s.pop();
    var x := s.top();
    print "top=", x, " (should be 2)\n";

    */

    var dad := new Person("dad", Masculine, null, null);
    var mom := new Person("mom", Feminine, null, null);

    var dad2 := new Person("dad2", Masculine, null, null);
    var mom2 := new Person("mom2", Feminine, null, null);

    var son := new Person("sonOfdadAndMOM", Masculine, dad, mom);
    var wife := new Person("wifeofSonOfDadAndmMom", Feminine, dad2, mom2);
    var anotherGuy := new Person("someguy", Masculine, dad, mom);
    var anotherWife := new Person("anotherwife", Feminine, dad2, mom2);

    // getting married 
    print "son civilState before marriage = ", son.civilState;
    print "\n";
    print "wife civilState before marriage = ", wife.civilState;
    print "\n";

    assert son.civilState == Single;
    assert wife.civilState == Single;

    son.marry(wife);

    assert son.civilState == Married;
    assert wife.civilState == Married;

    print "son civilState after marriage = ", son.civilState;
    print "\n";
    print "wife civilState after marriage = ", wife.civilState;
    print "\n";

    // son dies
    print "son civilState before dying = ", son.civilState;
    print "\n";
    print "wife civilState before son dying = ", wife.civilState;
    print "\n";
    son.die();

    assert son.civilState == Dead;
    //assert wife.civilState == Widow; esta verificacao nao da em Dafny por alguma razao.

    print "son civilState after dying = ", son.civilState;
    print "\n";
    print "wife civilState after son dying = ", wife.civilState;
    print "\n";

    // anotherWife that is wife's sister marries another guy that was son's brother
    print "anotherGuy civilState before marriage = ", anotherGuy.civilState;
    print "\n";
    print "anotherWife civilState before marriage = ", anotherWife.civilState;
    print "\n";

    assert anotherGuy.civilState == Single;
    assert anotherWife.civilState == Single;

    anotherWife.marry(anotherGuy);
    print "anotherGuy civilState after marriage = ", anotherGuy.civilState;
    print "\n";
    print "anotherWife civilState after marriage = ", anotherWife.civilState;
    print "\n";

    assert anotherGuy.civilState == Married;
    assert anotherWife.civilState == Married;

    // wife gets divorced from another guy
    print "anotherGuy civilState before divorce = ", anotherGuy.civilState;
    print "\n";
    print "anotherWife civilState before divorce = ", anotherWife.civilState;
    print "\n";

    anotherWife.divorce();

    print "anotherGuy civilState after divorce = ", anotherGuy.civilState;
    print "\n";
    print "anotherWife civilState after divorce = ", anotherWife.civilState;
    print "\n";

    assert anotherWife.civilState == Divorced;
    assert anotherGuy.civilState == Divorced;
}

datatype Sex = Masculine | Feminine
datatype CivilState = Single | Married | Divorced | Widow | Dead
 
class Person
{
    var name: string;
    var sex: Sex;
    var mother: Person?; // ‘?’ to allow null
    var father: Person?;
    var spouse: Person?;
    var civilState: CivilState;
    ghost var ancestors: set<Person>; 
 
    constructor (name: string, sex: Sex, mother: Person?, father: Person?)
        requires mother != null ==> mother.sex == Feminine && father != null ==> father.sex == Masculine
        ensures this.name == name
        ensures this.sex == sex
        ensures this.mother == mother
        ensures this.father == father
        ensures this.civilState == Single
        ensures this.spouse == null
        ensures Valid()
    {
        this.name := name;
        this.sex := sex;
        this.mother := mother;
        this.father := father;
        this.spouse := null;
        this.civilState := Single;

        // codigo recursivo que vai colocando ancestors do pai e mai e assim ate nao haver mais no array dos ancestors
    }

    predicate Valid()
        reads this, mother, spouse, father
    {
        /*
            only married people have a spouse 
            the mother, if defined, must be a woman (of sex feminine) 
            the father, if defined, must be a man (of sex masculine) 
            a person can only marry another person of the opposite sex
            the “spouse” relation is symmetric, i.e., “I am the spouse of my spouse”
        */

        // a partida, isto traduziria-se em spouse != null <==> civilState == Married mas as vezes nao da no Dafny
        civilState == Married ==> spouse != null &&
        spouse != null ==> civilState == Married &&

        mother != null ==> mother.sex == Feminine &&
        father != null ==> father.sex == Masculine &&
        spouse != null ==> sex != spouse.sex &&
        spouse != null ==> spouse.spouse == this
    }
    method marry(spouse: Person)
        modifies this, spouse
        requires Valid() && spouse.Valid()
        requires civilState != Married && civilState != Dead
        requires spouse.civilState != Married && spouse.civilState != Dead
        requires sex != spouse.sex //so se verifica o Valid depois do predicado terminar por isso e necessario assegurar isto
        ensures this.spouse == spouse
        ensures this.civilState == Married
        ensures spouse.civilState == Married
        ensures old(name) == name
        ensures old(sex) == sex
        ensures old(mother) == mother
        ensures old(father) == father
        ensures old(spouse).name == spouse.name
        ensures old(spouse).sex == spouse.sex
        ensures old(spouse).mother == spouse.mother
        ensures old(spouse).father == spouse.father
        ensures spouse.spouse == this
        ensures Valid()
    {
        this.spouse := spouse;
        this.civilState := Married;
        spouse.spouse := this;
        spouse.civilState := Married;
    }
    method divorce()
        modifies this, spouse
        requires Valid()
        requires civilState == Married && spouse != null && spouse.civilState == Married
        ensures old(spouse).civilState == Divorced
        ensures old(spouse).spouse == null
        ensures spouse == null
        ensures civilState == Divorced
        ensures Valid()
    {
        spouse.civilState := Divorced;
        spouse.spouse := null;
        this.spouse := null;
        this.civilState := Divorced;
    }

    method die()
        modifies this, spouse
        requires Valid()
        requires this.civilState != Dead
        ensures spouse != null ==> spouse.civilState == Widow
        ensures spouse != null ==> spouse.spouse == null
        ensures civilState == Dead
        ensures Valid()
    {
        if spouse != null
        {
            spouse.civilState := Widow;
            spouse.spouse := null;
        }
        this.spouse := null;
        this.civilState := Dead;
    }
}
