program ej1pr3;
type
    empleado = record
        nroEmpleado: String;
        apellido: String;
        nombre: String;
        edad: Integer;
        DNI: String;
    end;
  
    archivo = file of empleado;

    str25 = String[25];

procedure mostrarEmpleado(emp: empleado);
begin
    with emp do begin 
        write('Empleado # ', nroEmpleado, '  ');
        write('Apellido: ', apellido, '  '); 
        write('Nombre: ', nombre, '  ');
        write('Edad: ', edad, '  ');
        writeln('DNI: ', DNI, '  ');
    end;
end;

function menu(): integer;
begin
    writeln('Elige una opcion: ');
    writeln('1. Crear archivo e ingresar datos');
    writeln('2. Abrir archivo');
    writeln('0. Salir');
    writeln();
    readln(menu);
    writeln();
end;

function subMenu(): integer;
begin
    writeln('1. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
    writeln('2. Listar en pantalla los empleados de a uno por linea');
    writeln('3. Listar en pantalla empleados mayores de 70 anios, proximos a jubilarse');
    writeln('4. Agregar uno o mas empleados al final del archivo');
    writeln('5. Modificar edad a uno o mas empleados');
    writeln('6. Exportar el contenido del archivo a un archivo de texto');
    writeln('7. Exportar los empleados que no tengan cargado el DNI (DNI en 00)');
    writeln('8. Eliminar empleado');
    writeln('0. Regresar');
    writeln();
    readln(subMenu);
    writeln();
end;

procedure leerEmpleado(var worker: empleado);
begin
    with worker do begin
        write('Ingrese el apellido del empleado o fin para terminar: ');
        readln(apellido);
        if (apellido <> 'fin') then begin
            write('Ingrese el numero de empleado: '); readln(nroEmpleado);
            write('Ingrese el nombre: '); readln(nombre);
            write('Ingrese la edad: '); readln(edad);
            write('Ingrese el DNI: '); readln(DNI); 
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

procedure listarEmpleados(var empleados: archivo);
var
    worker: empleado;
begin
    reset(empleados);
    while not eof (empleados) do begin
        read(empleados, worker);
        mostrarEmpleado(worker);
    end;
    close(empleados);
    writeln();
end;

procedure listarEmpleadosEspecificos(var empleados: archivo);
var
    worker: empleado; name: str25;
begin
    reset(empleados);
    write('Ingrese el nombre o apellido que desea filtrar: ');
    readln(name);
    writeln();
    while not eof (empleados) do begin
        read(empleados, worker);
        if (worker.nombre = name) or (worker.apellido = name) then
        begin mostrarEmpleado(worker); end;
    end;
    close(empleados);
    writeln();
end;

procedure listarEmpleadosMayores(var empleados: archivo);
var
    worker: empleado;
begin
    reset(empleados);
    while not eof (empleados) do begin
        read(empleados, worker);
        if (worker.edad > 70) then
        begin mostrarEmpleado(worker); end;
    end;
    close(empleados);
    writeln();
end;

procedure agregarEmpleados(var empleados: archivo);
var
    worker: empleado;
begin
    reset(empleados);
    seek(empleados, filesize(empleados));
    leerEmpleado(worker);
    while (worker.apellido <> 'fin') do begin
        write(empleados, worker);
        leerEmpleado(worker);
    end; 
    close(empleados);
end;

procedure modificarEdad(var empleados: archivo);
var
    worker: empleado; number: string;
    newAge: integer;
begin
    write('Ingrese el # del empleado al que desea modificar la edad o 32767 para terminar: ');
    readln(number);
    reset(empleados);
    while (number <> '32767') do begin
        read(empleados, worker);
        while ((not eof (empleados)) and (number <> worker.nroEmpleado)) do begin
            read(empleados, worker);
        end;
        if (number = worker.nroEmpleado) then begin
            write('Ingrese la nueva edad del empleado # ', number, ': ');
            readln(newAge);
            worker.edad:= newAge;
            seek(empleados, filepos(empleados)-1);
            write(empleados, worker);
        end;
        seek(empleados, 0);
        write('Ingrese el # del empleado al que desea modificar la edad o 32767 para terminar: ');
        readln(number);
    end; 
    close(empleados);
end;

procedure exportar(var empleados: archivo; opcion: integer);
var
    worker: empleado; texto: Text;
begin
    if (opcion = 6) then 
    begin assign(texto, 'todos_empleados.txt'); end 
    else  
    begin assign(texto, 'faltaDNIEmpleado.txt'); end;
    reset(empleados);
    rewrite(texto);
    while not eof(empleados) do begin
        read(empleados, worker);
        with worker do begin
            if ((DNI = '00') and (opcion = 7)) or (opcion = 6) then begin
                writeln(texto, nroEmpleado, ' ', apellido, ' ', nombre, ' ', edad, ' ', DNI);
            end;
        end;
    end;
    close(texto);
end;

function buscarEmpleado(var empleados: archivo; nro: str25): Integer;
var
    worker: empleado; pos: Integer;
begin
    pos:= -1;
    while ((not eof(empleados)) and (worker.nroEmpleado <> nro)) do begin
        read(empleados, worker);
    end;
    if (worker.nroEmpleado = nro) then begin
        pos:= FilePos(empleados) - 1;
    end;
    buscarEmpleado:= pos;
end;

procedure eliminarEmpleado(var empleados: archivo);
var
    worker: empleado; nro: str25; pos: Integer;
begin
    write('Ingrese el numero del empleado a borrar: ');
    ReadLn(nro);
    reset(empleados);
    pos:= buscarEmpleado(empleados, nro); 
    if (pos <> -1) then begin
        Seek(empleados, FileSize(empleados) - 1);   // Me traigo los datos del ultimo empleado 
        Read(empleados, worker);                    // del archivo.
        Seek(empleados, pos);                       // Sobreescribo la info del empleado a eliminar 
        Write(empleados, worker);                   // poniendo la info del ultimo empleado.
        Seek(empleados, FileSize(empleados) - 1);   // Disminuyo el tamaño del archivo 
        Truncate(empleados);                        // a lo que realmente ocupa.
        WriteLn('Empleado eliminado con exito!');
    end
    else begin 
        WriteLn('No se encontro el empleado # ', nro); 
    end;
    Close(empleados);
    WriteLn();
end;

var
    opcion, subOpcion: integer;
    nombreFisico: String[25];
    empleados: archivo;
begin
    write('Ingrese el nombre del archivo a crear o utilizar: ');
    readln(nombreFisico);
    assign(empleados, nombreFisico);
    writeln();
    repeat
        opcion:= menu();
        case opcion of 
            1: begin crearEmpleados(empleados); end;
            2: begin
                subOpcion:= submenu();
                while (subOpcion <> 0) do begin
                    case subOpcion of
                        1: begin listarEmpleadosEspecificos(empleados); end;
                        2: begin listarEmpleados(empleados); end;
                        3: begin listarEmpleadosMayores(empleados); end;
                        4: begin agregarEmpleados(empleados); end;
                        5: begin modificarEdad(empleados); end;
                        6: begin exportar(empleados, subOpcion); end;
                        7: begin exportar(empleados, subOpcion); end;
                        8: begin eliminarEmpleado(empleados); end;
                        else begin writeln('Opcion no reconocida');
                            writeln();
                        end;
                    end;
                    subOpcion:= submenu();
                end;
            end;
            0: begin writeln('Hasta pronto!'); end
            else begin writeln('Opcion no reconocida');
                writeln();
            end;
        end;
    until(opcion = 0);
end.
