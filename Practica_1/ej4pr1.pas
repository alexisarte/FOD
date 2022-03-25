program ej4pr1;
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
      mostrarEmpleado(worker);
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
      mostrarEmpleado(worker);
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
    assign(texto, 'todos_empleados.txt') 
  else  
    assign(texto, 'faltaDNIEmpleado.txt');
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

var
  opcion, subOpcion, subOpcion2: integer;
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
      1: crearEmpleados(empleados);
      2: begin
        subOpcion:= submenu();
        while (subOpcion <> 0) do begin
          case subOpcion of
            1: listarEmpleadosEspecificos(empleados);
            2: listarEmpleados(empleados);
            3: listarEmpleadosMayores(empleados);
            4: agregarEmpleados(empleados);
            5: modificarEdad(empleados);
            6: exportar(empleados, subOpcion);
            7: exportar(empleados, subOpcion);
            else begin writeln('Opcion no reconocida');
              writeln();
            end;
          end;
          subOpcion:= submenu();
        end;
      end;
      0: writeln('Hasta pronto!')
      else begin writeln('Opcion no reconocida');
        writeln();
      end;
    end;
  until(opcion = 0);
end.
