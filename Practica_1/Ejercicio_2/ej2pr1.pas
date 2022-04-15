program ej2pr1;
type
  archivo = file of Integer;

var
  suma: real;
  cant, number, cantTotal: Integer;
  nombreFisico: String[25];
  nombreLogico: archivo;

begin
  write('Ingrese el nombre del archivo: ');
  readln(nombreFisico);
  assign(nombreLogico, nombreFisico);
  reset(nombreLogico);
  suma:= 0;
  cantTotal:= 0;
  cant:= 0;
  while not eof (nombreLogico) do begin
    read(nombreLogico, number); 
    writeln(number);
    cantTotal:= cantTotal + 1;
    suma:= suma + number;
    if(number < 1500) then
      cant:= cant + 1;
  end;
  writeln('Cantidad de numeros menores a 1500: ', cant);
  writeln('Promedio de los numeros ingresados: ', suma/cantTotal:2:2);
  close(nombreLogico);
  readln;
end.
