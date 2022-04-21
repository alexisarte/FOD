program ej2pr3;
const
MIN = 0; 
type
    str25 = String[25];

    asistente = record
        nroAsistente: Integer;
        nombre: str25;
        apellido: str25;
        email: str25;
        telefono: str25;
        dni: str25;
    end;

    archivoMaestro = File of asistente;

procedure leerAsistente(var asistente1: asistente);
begin
    with asistente1 do begin
        write('Ingrese el numero de asistente o -1 para terminar: '); readln(nroAsistente);
        if (nroAsistente <> MIN) then begin
            write('Ingrese el nombre: '); readln(nombre);
            write('Ingrese la edad: '); readln(apellido);
            write('Ingrese el email: '); readln(email);
            write('Ingrese el telefono: '); readln(telefono);
            write('Ingrese el DNI: '); readln(dni); 
            writeln('=======================================');
        end;
    end;
    writeln();
end;

procedure crearAsistentes(var asistentes: archivoMaestro);
var
    asistente1: asistente;
begin
    rewrite(asistentes);
    leerAsistente(asistente1);
    while (asistente1.nroAsistente <> MIN) do begin
        write(asistentes, asistente1);
        leerAsistente(asistente1);
    end; 
    close(asistentes);
end;

procedure mostrarAsistente(asistente1: asistente);
begin
    with asistente1 do begin 
        write('Asistente # ', nroAsistente, '  ');
        write('Nombre: ', nombre, '  ');
        write('Apellido: ', apellido, '  '); 
        write('Email: ', email, '  ');
        write('Telefono: ', telefono, '  ');
        writeln('DNI: ', DNI, '  ');
    end;
end;

procedure listarAsistentes(var asistentes: archivoMaestro);
var
    asistente1: asistente;
begin
    reset(asistentes);
    while not eof (asistentes) do begin
        read(asistentes, asistente1);
        if (asistente1.nombre[1] <> '@') then begin
            mostrarAsistente(asistente1);
        end;
    end;
    close(asistentes);
    writeln();
end;

procedure eliminarAsistentes(var asistentes: archivoMaestro);
var
    asistente1: asistente;
begin
    reset(asistentes);
    while not eof(asistentes) do begin
        read(asistentes, asistente1);
        if (asistente1.nroAsistente < 1000) then begin
            asistente1.nombre:= '@' + asistente1.nombre;
            Seek(asistentes, FilePos(asistentes) - 1);
            Write(asistentes, asistente1);
        end;
    end;
    Close(asistentes);
    WriteLn();
end;

var
    asistentes: archivoMaestro;
begin
    Assign(asistentes, 'asistentes');
    // crearAsistentes(asistentes);
    listarAsistentes(asistentes);
    eliminarAsistentes(asistentes);
    listarAsistentes(asistentes);
end.