program ej16pr2;
const
VALOR_ALTO = 32767;
MAX = 100;
type
    rango = 1..MAX;
    emisionSeminario = record
        fecha: Integer;
        codSeminario: string;
        nombreSeminario: string;
        descripcion: string;
        precio: Integer;
        totalEjemplares: Integer;
        ejemplaresVendidos: Integer;
    end;

    ventaSeminario = record
        fecha: Integer;
        codSeminario: string;
        ejemplaresVendidos: Integer;
    end;

    maestro = File of emisionSeminario;
    detalle = File of ventaSeminario;

    vRegDetalles = array[rango] of ventaSeminario;
    vDetalles = array[rango] of detalle;

procedure leerDetalle(var archivo: detalle; var reg: ventaSeminario);
begin
    if (not Eof(archivo)) then begin
        Read(archivo, reg);
    end
    else begin
        reg.fecha:= VALOR_ALTO;
    end;
end;

procedure minimo(var detalles: vDetalles; var regDetalles: vRegDetalles; var min: ventaSeminario);
var
    i, posMin: Integer;
begin
    for i:= 1 to MAX do begin
        if ((regDetalles[i].fecha < min.fecha) or ((regDetalles[i].fecha = min.fecha) and
            (regDetalles[i].codSeminario < min.codSeminario))) then begin
            min:= regDetalles[i];
            posMin:= i;
        end;
    end;
    if (posMin <> 0) then begin
        leerDetalle(detalles[i], regDetalles[i]); 
    end;
end;

procedure abrirYLeerDetalles(var detalles: vDetalles; var regDetalles: vRegDetalles);
var
    i: Integer;
begin
    for i:= 1 to MAX do begin
        Assign(detalles[i], 'detalle' + i.toString());
        Reset(detalles[i]);
        leerDetalle(detalles[i], regDetalles[i]);
    end;
end;

procedure actualizarMaestro(var maestro1: maestro; var detalles: vDetalles; var regDetalles: vRegDetalles);
var
    regMaestro, maximo, minimo: emisionSeminario;
    min: ventaSeminario;
    i: Integer;
begin
    maximo.ejemplaresVendidos:= -32768;
    minimo.ejemplaresVendidos:= 32767;
    Assign(maestro1, 'maestro.dat'); Reset(maestro1);
    abrirYLeerDetalles(detalles, regDetalles);
    minimo(detalles, regDetalles, min);
    while (min.fecha <> VALOR_ALTO) do begin
        Read(maestro1, regMaestro);
        while ((regMaestro.fecha <> min.fecha) or (regMaestro.codSeminario <> min.codSeminario)) do begin
            Read(maestro1, regMaestro);
        end;
        while ((regMaestro.fecha = min.fecha) or (regMaestro.codSeminario = min.codSeminario)) do begin
            regMaestro.ejemplaresVendidos:= regMaestro.ejemplaresVendidos + min.ejemplaresVendidos;
            minimo(detalles, regDetalles, min);
        end;
        if (regMaestro.ejemplaresVendidos > maximo.ejemplaresVendidos) then begin
            maximo:= regMaestro;
        end
        else if (regMaestro.ejemplaresVendidos < min.ejemplaresVendidos) then begin
            min:= regMaestro;
        end;
        Seek(maestro1, FilePos(maestro1) - 1);
        write(maestro1, regMaestro);
    end;
    Close(maestro1);
    for i:= 1 to MAX do begin
        Close(detalles[i]);
    end;
    writeln('Semanario que tuvo mas ventas: ', maximo);    
    writeln('Semanario que tuvo menos ventas: ', minimo);
end;


var
    maestro1: maestro;
    detalles: vDetalles;
    regDetalles: vRegDetalles;
begin
    actualizarMaestro(maestro1, detalles, regDetalles);
end.