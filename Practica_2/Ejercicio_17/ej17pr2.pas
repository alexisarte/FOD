program ej17pr2;
const
    MAX = 10;
    VALOR_ALTO = 32767;
type
    rango = 1..MAX;
    
    moto = record
        codigo: integer;
        nombre: string;
        descripcion: string;
        modelo: string;
        marca: string;
        stockActual: integer;
    end;

    venta = record
        codigoMoto: integer;
        precio: integer;
        fecha: string;
    end;

    detalle = File of venta;
    maestro = File of moto;

    vDetalles = array[rango] of detalle;
    vRegDetalles = array[rango] of venta;

procedure leerArchivo(var archivo: detalle; var reg: venta);
begin
    if not eof(archivo) then
        read(archivo, reg)
    else
        reg.codigoMoto:= VALOR_INVALIDO;
end;

procedure abrirYLeerDetalles(var detalles: vDetalles; var regDetalles: vRegDetalles);
var
    i: rango;
begin
    for i:= 1 to MAX do begin
        assign(detalles[i], 'detalle' + intToStr(i) + '.dat');
        reset(detalles[i]);
        leerArchivo(detalles[i], regDetalles[i]);
    end;
end;

procedure cerrarDetalles(var detalles: vDetalles);
var
    i: rango;
begin
    for i:= 1 to MAX do begin
        close(detalles[i]);
    end;
end;

procedure actualizarMaestro(var maestro1: maestro; var detalles: vDetalles; var regDetalles: vRegDetalles);
var
    i: rango;
    min: venta;
    moto1, motoMasVendida: moto;
begin
    motoMasVendida.stockActual:= VALOR_ALTO;
    Assign(maestro1, 'maestro.dat'); Reset(maestro1);
    abrirYLeerDetalles(detalles, regDetalles);
    minimo(detalles, regDetalles, min);
    while (min.codigoMoto <> VALOR_ALTO) do begin   
        Read(maestro1, moto1);
        while (moto1.codigo <> min.codigoMoto) do begin 
            Read(maestro1, moto1);
        end;
        while (moto1.codigo = min.codigoMoto) do begin  
            moto1.stockActual:= moto1.stockActual - 1;
            minimo(detalles, regDetalles, min);
        end;
        if (moto1.stockActual < motoMasVendida.stockActual) then begin  
            motoMasVendida:= moto1;
        end;
        seek(maestro1, filePos(maestro1) - 1);
        write(maestro1, moto1);
    end;
    Close(maestro1);
    cerrarDetalles(detalles);
    writeln('La moto mas vendida es: ', motoMasVendida.nombre); 
end;

var
    maestro1: maestro;
    detalles: vDetalles;
    regDetalles: vRegDetalles;
begin
    actualizarMaestro(maestro1, detalles, regDetalles);
end.