
Program ej1pr1;

Uses crt;

Type 
    archivo =   file Of Integer;

Var 
    nombreLogico:   archivo;
    number:   Integer;
    nombreFisico:   String[25];

Begin
    write('Ingrese el nombre del archivo: ');
    readln(nombreFisico);

    assign(nombreLogico, nombreFisico);
    rewrite(nombreLogico);

    write('Ingrese un numero entero: ');
    read(number);
    While (number <> 3000) Do
        Begin
            write(nombreLogico, number);
            write('Ingrese un numero entero: ');
            readln(number);
        End;
    close(nombreLogico);
    readln;
End.
