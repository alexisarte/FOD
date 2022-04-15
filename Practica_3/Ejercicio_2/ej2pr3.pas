program ej2pr3;
type
    str25 = String[25];

    asistente = record
        nroAsistente: str25;
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
        if (nroAsistente <> -1) then begin
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

procedure crearEmpleados(var empleados: archivo);
var
    worker: empleado;
begin
    
    rewrite(empleados);
    leerEmpleado(worker);
    while (worker.apellido <> 'fin') do begin
        write(empleados, worker);
        leerEmpleado(worker);
    end; 
    close(empleados);
end;

begin


end.