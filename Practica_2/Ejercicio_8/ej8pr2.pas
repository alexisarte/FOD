program ej8pr2;
const
    valorAlto = 32767;
type
    str25 = String[25];
    rangoDia = 1..31;
    rangoMes = 1..12;

    clienteDetallado = record
        codCliente: Integer;
        nombreYApellido: str25;
    end;

    fechaDetallada = record
        anio: Integer;
        mes: 1..12;
        dia: rangoDia;
    end;

    venta = record
        cliente: clienteDetallado;
        fecha: fechaDetallada;
        monto: Real;
    end;

    archivoMaestro = File of venta;

procedure importarMaestro(var ventas: archivoMaestro);
var 
    maestro: Text;
    venta1: venta;
begin
    Assign(maestro, 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_8\Ventas.txt');
    Rewrite(ventas);
    Reset(maestro);
    while not eof(maestro) do begin
        Read(maestro, venta1.cliente.codCliente, venta1.cliente.nombreYApellido);
        ReadLn(maestro, venta1.fecha.anio, venta1.fecha.mes, venta1.fecha.dia, venta1.monto);
        Write(ventas, venta1);
    end;
    Close(ventas);
    Close(maestro);
end;
    
procedure leer(var archivo: archivoMaestro; var dato: venta);
begin
    if (not Eof(archivo)) then
        Read(archivo, dato)
    else
        dato.cliente.codCliente:= valorAlto;
end; 

procedure mostrarCliente(cliente: clienteDetallado);
begin
    WriteLn('Codigo de cliente: ', cliente.codCliente);
    WriteLn('Nombre y Apellido: ', cliente.nombreYApellido);
    WriteLn('------------------------------------------------');
    WriteLn();
end;

procedure reporte(var ventas: archivoMaestro);
var
    mesActual: rangoMes; anioActual, codActual: Integer;
    regMaestro: venta; totalMensual, totalAnual, total: Real;
begin
    Reset(ventas);
    leer(ventas, regMaestro);
    total:= 0;
    while (regMaestro.cliente.codCliente <> valorAlto)  do begin
        mostrarCliente(regMaestro.cliente);
        codActual:= regMaestro.cliente.codCliente;
        while (codActual = regMaestro.cliente.codCliente) do begin
            WriteLn('Anio: ', regMaestro.fecha.anio);
            anioActual:= regMaestro.fecha.anio;
            totalAnual:= 0;
            while ((codActual = regMaestro.cliente.codCliente) and (anioActual = regMaestro.fecha.anio)) do begin
                WriteLn('Mes: ', regMaestro.fecha.mes);
                mesActual:= regMaestro.fecha.mes;
                totalMensual:= 0;
                while ((codActual = regMaestro.cliente.codCliente) and (anioActual = regMaestro.fecha.anio) and (mesActual = regMaestro.fecha.mes)) do begin
                    totalMensual:= totalMensual + regMaestro.monto;
                    leer(ventas, regMaestro);
                end;
                WriteLn('Total mensual: ', totalMensual:2:2);
                totalAnual:= totalAnual + totalMensual;
            end;
            WriteLn('Total anual: ', totalAnual:2:2);
            WriteLn('===================================================');
            WriteLn();
            total:= total + totalAnual;
        end;
        WriteLn('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
        WriteLn();
    end;
    WriteLn('Total Empresa: ', total:2:2);
    Close(ventas);
end;

var
    ventas: archivoMaestro;
begin
    Assign(ventas, 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_8\ventas');
    importarMaestro(ventas);
    reporte(ventas);
end.