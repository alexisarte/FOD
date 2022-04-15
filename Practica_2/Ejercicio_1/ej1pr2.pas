program ej1pr2;
type
    str25 = String[25];

    empleado = record
        codEmpleado: Integer;
        nombre: str25;
        montoComision: Integer;
    end;

    archivo = File of empleado;

procedure importarEmpleados(var empleados: archivo);
var 
    empleadosTexto: Text;
    employee: empleado;
begin
    Assign(empleadosTexto, 'data/Empleados.txt');
    Rewrite(empleados);
    Reset(empleadosTexto);
    while not eof(empleadosTexto) do begin
        Read(empleadosTexto, employee.codEmpleado, employee.nombre);
        ReadLn(empleadosTexto, employee.montoComision);
        Write(empleados, employee);
    end;
    Close(empleados);
    Close(empleadosTexto);
end;

procedure mostrarEmpleado(employee: empleado);
begin
    WriteLn('Codigo de empleado: ', employee.codEmpleado);
    WriteLn('Nombre: ', employee.nombre);
    WriteLn('Monto de comision: ', employee.montoComision);
    WriteLn('------------------------------------------------');
    WriteLn();
end;

procedure listarEmpleados(var empleados: archivo);
var
    employee: empleado;
begin
    Reset(empleados);
    while not eof(empleados) do begin
        Read(empleados, employee);
        mostrarEmpleado(employee);
    end;
    Close(empleados);
end;

procedure leer(var detalle: archivo; var dato: empleado);
begin
    if (not Eof(detalle)) then
        Read(detalle, dato)
    else
        dato.codEmpleado := 32767;
end;

procedure generarArchivoMaestro(var detalle: archivo);
var
    maestro: archivo; 
    registroD, registroM: empleado;
begin
    Assign(maestro, 'empleados2');
    Rewrite(maestro);
    Reset(detalle);
    leer(detalle, registroD);
    while (registroD.codEmpleado <> 32767) do begin
        registroM.codEmpleado:= registroD.codEmpleado;
        registroM.nombre:= registroD.nombre;
        registroM.montoComision:= 0;
        while (registroD.codEmpleado = registroM.codEmpleado) do begin
            registroM.montoComision:= registroM.montoComision + registroD.montoComision;
            leer(detalle, registroD);
        end;
        Write(maestro, registroM);
    end;
    Close(maestro);
    Close(detalle);
    WriteLn('cada empleado aparece una unica vez con el valor total de sus comisiones.');
    listarEmpleados(maestro);
end;

var
    empleados: archivo;
begin
    Assign(empleados, 'empleados');
    importarEmpleados(empleados);
    listarEmpleados(empleados);
    generarArchivoMaestro(empleados);
end.