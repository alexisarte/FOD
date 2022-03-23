Program Generar_Archivo;
type 
    archivo = file of integer; 
  
var 
    archivoLogico: archivo;        
    numero: integer;               
    archivoFisico: string[12]; 

procedure mostrarArchivo(var archi_logico: archivo);
var
    number: integer;

begin
    reset(archi_logico);

    while not eof (archi_logico) do begin
        read(archi_logico, number);
        write(number);
    end;

    close(archi_logico);
end;
    
begin
    write('Ingrese el nombre del archivo: ');
    read(archivoFisico); 
    assign(archivoLogico, archivoFisico);
    rewrite(archivoLogico); 
    write('Ingrese un numero: ');
    read(numero); 
    while numero <> 0 do begin
        write(archivoLogico, numero); 
        write('Ingrese un numero: ');
        read(numero);
    end;
    readln;
    writeln('Mostrar archivo ');
    mostrarArchivo(archivoLogico);
    readln;
end.

