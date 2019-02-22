while(true){
    if(T1 >= 22 && T1 <= 24){
        CloseWindow();
        TurnHeaterOff();
        TurnACOff();
    }

    if(T1 <= 20 || T1 >= 26){
        CloseWindow();
        
        if(T1 <= 20){
            TurnHeaterOn();
        }

        if(T1 >= 26){
            TurnACOn();
        }
    }

    if(T1 >= 24 && T1 <= 26){
        OpenWindow();
    }
}