program ej1pr1;
type
  archivo = file of Integer;
  
var 
  nombreLogico: archivo;
  number: Integer;
  nombreFisico: String[25];
  
begin
  write('Ingrese el nombre del archivo: ');
  readln(nombreFisico);
  
  assign(nombreLogico, nombreFisico);
  rewrite(nombreLogico);
  
  write('Ingrese un numero entero: ');
  read(number);
  while(number <> 3000) do begin
    write(nombreLogico, number);
    write('Ingrese un numero entero: ');
    readln(number);
  end;
  close(nombreLogico);
  readln;
end.
