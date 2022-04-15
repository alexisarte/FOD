program ej10pr2;
const
    valorAlto = ZZZ;
    MAX = 15;
type
    str25 = String[25];
    rango = 1..MAX;
    
    empleado = record
        departamento: Integer;
        division: Integer;
        nroEmpleado: Integer;
        categoria: rango;
        horasExtras: Integer;
    end;

    valorHora = record
        categoria: rango;
        valor: Real;
    end;

    archivoMaestro = File of empleado;
    archivoValores = File of valorHora;
    valoresHoras = array[rango] of Real;

procedure importarValores(var valores: valoresHoras);
var
    valoresTxt: Text;
    valor1: valorHora;
begin
    Assign(valoresTxt, 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_10\Valores.txt');
    Reset(valoresTxt);
    while not Eof(valoresTxt) do begin
        Read(valoresTxt, valor1.categoria, valor1.valor);
        valores[valor1.categoria]:= valor1.valor;
    end;
    Close(valoresTxt);
end;

procedure importarMaestro(var empleados: archivoMaestro);
var 
    maestro: Text;
    empleado1: empleado;
begin
    Assign(maestro, 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_10\Valores.txt');
    Rewrite(empleados);
    Reset(maestro);
    while not eof(maestro) do begin
        ReadLn(maestro, empleado1.departamento, empleado1.division, empleado1.nroEmpleado, empleado1.categoria, empleado1.horasExtras);
        Write(empleados, empleado1);
    end;
    Close(empleados);
    Close(maestro);
end;
    
procedure leer(var archivo: archivoMaestro; var dato: empleado);
begin
    if (not Eof(archivo)) then
        Read(archivo, dato)
    else
        dato.departamento:= valorAlto;
end; 

procedure presentarListado(var empleados: archivoMaestro);
var
    departamentoActual, divisionActual, nroEmpleadoActual: Integer;
    regMaestro: empleado; 
    departamentoHrs, divisionHrs: Integer;
    montoDivision, montoDepartamento: Real;
begin
    Reset(empleados);
    leer(empleados, regMaestro);
    total:= 0;
    while (regMaestro.departamento <> valorAlto)  do begin
        WriteLn('Departamento: ', regMaestro.division);
        departamentoActual:= regMaestro.departamento;
        departamentoHrs:= 0;
        while (departamentoActual = regMaestro.departamento) do begin
            WriteLn('Division: ', regMaestro.division);
            divisionActual:= regMaestro.division;
            divisionHrs:= 0;
            while ((departamentoActual = regMaestro.departamento) and (divisionActual = regMaestro.division)) do begin
                WriteLn('nroEmpleado: ', regMaestro.nroEmpleado);
                nroEmpleadoActual:= regMaestro.nroEmpleado;
                while ((departamentoActual = regMaestro.departamento) and (divisionActual = regMaestro.division) and (nroEmpleadoActual = regMaestro.nroEmpleado)) do begin
                    divisionHrs:= divisionHrs + regMaestro.horasExtras;
                    leer(empleados, regMaestro);
                end;
            end;
            WriteLn('Total de horas division: ', divisionHrs:2:2);
            WriteLn('Monto total por division: ', montoDivision:2:2);
            departamentoHrs:= departamentoHrs + divisionHrs;
        end;
        WriteLn('Total horas departamento: ', divisionHrs:2:2);
        WriteLn('Monto total departamento:: ', montoDivision:2:2);
    end;
    WriteLn('Total Empresa: ', total:2:2);
    Close(empleados);
end;

var
    empleados: archivoMaestro;
    valores: valoresHoras;
begin
    importarValores(valores);
    Assign(empleados, 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_8\empleados');
    importarMaestro(empleados);
    presentarListado(empleados);

end.