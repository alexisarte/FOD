program ej4Pr1;
uses crt;
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
    write('Nombre: ', nombre, '  ');
    write('Apellido: ', apellido, '  '); 
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
  writeln('0. Regresar');
  writeln();
  readln(subMenu);
  writeln();
end;

procedure crearEmpleados(nombreFisico: str25);
var
  empleados: archivo; worker: empleado;
begin
  assign(empleados, nombreFisico);
  rewrite(empleados);
  with worker do begin
    write('Ingrese el apellido del empleado: ');
    readln(apellido);
    while (apellido <> 'fin') do begin
      write('Ingrese el numero de empleado: '); readln(nroEmpleado);
      write('Ingrese el nombre: '); readln(nombre);
      write('Ingrese la edad: '); readln(edad);
      writeln('Ingrese el DNI: '); readln(DNI); 
      writeln('=======================================');
      write(empleados, worker);
      write('Ingrese el apellido del empleado: '); readln(apellido);
      writeln();
    end;
  end; 
  close(empleados);
end;

procedure crearEmpleado(var worker: empleado);
begin
  with worker do begin
    write('Ingrese el apellido del empleado: ');
    readln(apellido);
    if (apellido <> 'fin') then begin
      write('Ingrese el numero de empleado: '); readln(nroEmpleado);
      write('Ingrese el nombre: '); readln(nombre);
      write('Ingrese la edad: '); readln(edad);
      writeln('Ingrese el DNI: '); readln(DNI); 
      writeln('=======================================');
      //write(empleados, worker);
      //write('Ingrese el apellido del empleado: '); readln(apellido);
      writeln();
    end;
  end;
end;

procedure listarEmpleados(nombreFisico: str25);
var
  worker: empleado; empleados: archivo;
begin
  assign(empleados, nombreFisico);
  reset(empleados);
  while not eof (empleados) do begin
    read(empleados, worker);
    mostrarEmpleado(worker);
  end;
  close(empleados);
end;

procedure listarEmpleadosEspecificos(nombreFisico: str25);
var
  empleados: archivo; worker: empleado; name: str25;
begin
  assign(empleados, nombreFisico);
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
end;

procedure listarEmpleadosMayores(nombreFisico: str25);
var
  empleados: archivo; worker: empleado;
begin
  assign(empleados, nombreFisico);
  reset(empleados);
  while not eof (empleados) do begin
    read(empleados, worker);
    if (worker.edad > 70) then
      mostrarEmpleado(worker);
  end;
  close(empleados);
end;

procedure agregarEmpleados(nombreFisico: str25);
var
  empleados: archivo; worker: empleado;
begin
  assign(empleados, nombreFisico);
  reset(empleados);
  while not eof (empleados) do begin
    seek(empleados, filesize(empleados));
    crearEmpleado(worker);
    write(empleados, worker); 

  end;
  close(empleados);
end;

var
  opcion, subOpcion: integer;
  nombreFisico: String[25];
begin
  write('Ingrese el nombre del archivo a crear o utilizar: ');
  readln(nombreFisico);
  writeln();
  repeat
    opcion:= menu();
    case opcion of 
      1: crearEmpleados(nombreFisico);
      2: begin
        subOpcion:= submenu();
        while (subOpcion <> 0) do begin
          case subOpcion of
            1: listarEmpleadosEspecificos(nombreFisico);
            2: listarEmpleados(nombreFisico);
            3: listarEmpleadosMayores(nombreFisico);
            4: agregarEmpleados(nombreFisico)
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
  readln;
end.
