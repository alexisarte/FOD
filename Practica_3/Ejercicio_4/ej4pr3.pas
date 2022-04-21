program ej4pr3;
type
    reg_flor = record
        nombre: String[45];
        codigo:integer;
    end;

    tArchFlores = file of reg_flor;

// Abre el archivo y agrega una flor
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

var
    archivoFlores: tArchFlores;
    nombre: string;
    codigo: Integer;
begin
    Assign(archivoFlores, flores);
    agregarFlor(archivoFlores, nombre, codigo)
end.