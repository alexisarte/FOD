procedure recorrerArchivo(var nombreLogico: archivo);
var  
  number: integer;  
begin
  reset(nombreLogico);
  while not eof (nombreLogico) do begin
    read(nombreLogico, number);
    write(number);           
  end;
  close(nombreLogico);
end;
