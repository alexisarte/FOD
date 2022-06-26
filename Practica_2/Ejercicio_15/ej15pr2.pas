program ej15pr2;
const
MAX = 10;
VALOR_ALTO = 'ZZZ';
type
    rango = 1..MAX;

    regMaestro = record
        codProvincia: string;
        nombreProvincia: string;
        codLocalidad: string;
        nombreLocalidad: string;
        viviendasSinLuz: Integer;
        viviendasSinGas: Integer;
        viviendasDeChapa: Integer;
        viviendasSinAgua: Integer;
        viviendasSinSanitarios: Integer;    
    end;

    regDetalle = record
        codProvincia: string;
        codLocalidad: string;
        viviendasConLuz: Integer;
        viviendasConstruidas: Integer;
        viviendasConAgua: Integer;
        viviendasConGas: Integer;
        entregaSanitarios: Integer;
    end;

    maestro = File of regMaestro;
    detalle = File of regDetalle;

    vDetalles = array[rango] of detalle;
    vRegDetalles = array[rango] of regDetalle;

procedure leerDetalle(var archivo: detalle; var reg: regDetalle);
begin
    if (not Eof(archivo))then begin
        Read(archivo, reg);
    end
    else begin
        reg.codProvincia:= VALOR_ALTO;
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

procedure minimo(var detalles: vDetalles; var regDetalles: vRegDetalles; var min: regDetalle);
var
    i, posMin: Integer;
begin
    posMin:= 0;
    for i:= 1 to MAX do begin
        if ((regDetalles[i].codProvincia < min.codProvincia) or ((regDetalles[i].codProvincia =
            min.codProvincia) and (regDetalles[i].codLocalidad < min.codLocalidad))) then begin
            min:= regDetalles[i];
            posMin:= i;
        end;
    end;
    if (posMin <> 0) then begin
        leerDetalle(detalles[i], regDetalles[i]);
    end;
end;

procedure actualizarMaestro(var maestro1: maestro; var detalles: vDetalles; var regDetalles: vRegDetalles);
var
    regMaestro1: regMaestro;
    min: regDetalle;
    localidadesSinChapa, i: Integer;
begin
    localidadesSinChapa:= 0;
    abrirYLeerDetalles(detalles, regDetalles);
    minimo(detalles, regDetalles, min);
    while (min.codProvincia <> VALOR_ALTO) do begin
        Read(maestro1, regMaestro1);
        while ((regMaestro1.codProvincia <> min.codProvincia) and (regMaestro1.codLocalidad <> min.codLocalidad)) do begin
            Read(maestro1, regMaestro1);
        end;
        regMaestro1.viviendasSinLuz -= min.viviendasConLuz;
        regMaestro1.viviendasSinGas -= min.viviendasConGas;
        regMaestro1.viviendasDeChapa -= min.viviendasConstruidas;
        regMaestro1.viviendasSinAgua -= min.viviendasConAgua;
        regMaestro1.viviendasSinSanitarios -= min.entregaSanitarios;
        minimo(detalles, regDetalles, min);
        if (regMaestro1.viviendasDeChapa < 0) then begin
            localidadesSinChapa += 1;
        end;
    end;
    writeln('Cantidad de localidades sin viviendas de chapa: ', localidadesSinChapa);
    Close(maestro1);
    for i:= 1 to MAX do begin
        Close(detalles[i]);
    end;
end;

var
    maestro1: maestro;
    detalles: vDetalles;
    regDetalles: vRegDetalles;
begin
    actualizarMaestro(maestro1, detalles, regDetalles);
end.