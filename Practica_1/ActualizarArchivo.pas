procedure actualizarArchivo (var archi: archivo); 
var
  r: registro;

begin
    reset(archi_logico); 

    while not eof(archi_logico) do begin
        read(archi_logico, r); 
        r.campo:= r.campo * 1.1;    
        Seek(archi_logico, filepos(archi_logico) -1 );
        write(archi_logico, r); 
    end;

    close(archi_logico);
end;


