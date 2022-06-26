program ej14pr2;
const
VALOR_ALTO = 'ZZZ';
type
    vuelo = record
        destino: string;
        fecha: string;
        horaDeSalida: string;
        asientosDisponibles: Integer;
    end;

    regDetalle = record
        destino: string;
        fecha: string;
        horaDeSalida: string;
        asientosReservados: Integer;
    end;

    maestro = File of vuelo;
    detalle = File of regDetalle;

procedure leerDetalle(var archivo: detalle; var reg: regDetalle);
begin
    if (not Eof(archivo)) then begin
        Read(archivo, regDetalle);
    end
    else begin
        reg.destino:= VALOR_ALTO;
    end;
end;

procedure minimo(var detalle1, detalle2: detalle; var reg1, reg2: regDetalle; var min: regDetalle);
begin
    if ((reg1.destino < reg2.destino) or ((reg1.destino = reg2.destino) and (reg1.fecha < reg2.fecha)) or
        ((reg1.destino = reg2.destino) and (reg1.fecha = reg2.fecha) and (reg1.horaDeSalida < reg2.horaDeSalida))) then begin
        min:= regDetalle1;
        leerDetalle(detalle1, regDetalle1);
    end
    else begin
        min:= regDetalle2;
        leerDetalle(detalle2, regDetalle2);
    end
end;

procedure mostrarVuelo(regMaestro: vuelo);
begin
    writeln('Destino del vuelo: ', regMaestro.destino);
    writeln('Fecha', regMaestro.fecha);
    writeln('Hora de salida: ', regMaestro.horaDeSalida);
    writeln('-----------------------------------------');
end;

procedure actualizarMaestro(var maestro1: maestro; var detalle1, detalle2: detalle; cantAsientos: Integer);
var
    regMaestro: vuelo;
    regDetalle1, regDetalle2, min: regDetalle;
begin
    Reset(maestro1); 
    Assign(detalle1, 'detalle1'); Reset(detalle1); leerDetalle(detalle1, regDetalle1);
    Assign(detalle1, 'detalle2'); Reset(detalle2); leerDetalle(detalle2, regDetalle2);
    minimo(detalle1, detalle2, regDetalle1, regDetalle2, min);
    while (min.destino <> VALOR_ALTO) do begin
        Read(maestro1, regMaestro);
        while ((regMaestro.destino <> min.destino) or (regMaestro.fecha <> min.fecha) or
                (regMaestro.horaDeSalida <> min.horaDeSalida)) do begin
            Read(maestro1, regMaestro);
        end;
        while ((min.destino = regMaestro.destino) and (min.fecha = regMaestro.fecha) and
                (min.horaDeSalida = regMaestro.horaDeSalida))
            do begin
            regMaestro.asientosDisponibles -= min.asientosReservados;
            minimo(detalle1, detalle2, regDetalle1, regDetalle2, min);
        end;
        if (regMaestro.asientosDisponibles < cantAsientos) then begin
            mostrarVuelo(regMaestro);
        end;
        Seek(maestro1, FilePos(maestro1) - 1);
        write(maestro1, regMaestro);
    end;
    Close(maestro1);
    Close(detalle1);
    Close(detalle2);
end;

var
    maestro1: maestro;
    detalle1, detalle2: detalle;
    cantAsientos: Integer;
begin
    Assign(maestro1, 'maestro.dat');
    write('Ingrese una cantidad de asientos disponibles: '); read(cantAsientos);
    actualizarMaestro(maestro1, detalle1, detalle2, cantAsientos);
end.