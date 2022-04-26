program ej5pr3;
type
    reg_flor = record
        nombre: String[45];
        codigo:integer;
    end;

    tArchFlores = file of reg_flor;

procedure agregarFlor (var a: tArchFlores; nombre: string; codigo:integer);
var 
    flor, florAuxiliar: reg_flor;
    codigo2: Integer;
begin
    // leer(a, flor);
    Reset(a);
    Read(a, flor);
    codigo2:= flor.codigo; 
    if (codigo2 < 0) then begin     // Si hay espacio libre en el archivo de flores
        flor.nombre:= nombre;   
        flor.codigo:= codigo;
        Seek(a, Abs(codigo2));  // Voy al primer espacio libre
        Read(a, florAuxiliar);  // Me guardo la info de este espacio, para posteriormente actualizar la lista de espacio libre  
        Seek(a, FilePos(a) - 1);    // Grabo la info de la nueva flor
        Write(a, flor);             // en el espacio libre.
        Seek(a, 0);             // Actualizo la lista de 
        Write(a, florAuxiliar); // espacio libre.
    end;
    Close(a);
end;

procedure mostrarFlor(flor: reg_flor);
begin
    Write('Nombre de la flor: ');
    ReadLn(flor.nombre);
    Write('Codigo: ');
    ReadLn(flor.nombre);
end;

procedure listarFlores(var a: tArchFlores);
begin
    Reset(a);
    Read(a, flor);
    while not Eof(a) do begin
        Read(a, flor);
        if (flor.codigo > 0) then begin
            mostrarFlor(flor);
        end;        
    end;
    Close(a);
end;

function buscarFlor(var flores: archivo; codigo: Integer): Integer;
var
    flor: novela; pos: Integer;
begin
    pos:= -1;
    while ((not eof(flores)) and (flor.codigo <> codigo)) do begin
        read(flores, flor);
    end;
    if (flor.codigo = codigo) then begin
        pos:= FilePos(flores) - 1;
    end;
    buscarFlor:= pos;
end;

procedure eliminarFlor(var a: tArchFlores; flor:reg_flor);
var
    florAuxiliar: reg_flor;
    pos: Integer;
begin
    Reset(a);
    Read(a, florAuxiliar);
    pos:= buscarFlor(a, flor.codigo);
    if (pos <> -1) then begin
        Seek(a, pos);
        Read(a, flor);
        flor.codigo:= pos * -1;
        Seek(a, pos);
        Write(a, florAuxiliar);
        Seek(a, 0);     // Actualizo la lista de 
        Write(a, flor); // espacio libre.  
    end;
end;

var
    archivoFlores: tArchFlores;
    nombre: string; codigo: Integer;
    flor: reg_flor;
begin
    Assign(archivoFlores, flores);
    agregarFlor(archivoFlores, nombre, codigo);
    eliminarFlor(a, flor);
end.