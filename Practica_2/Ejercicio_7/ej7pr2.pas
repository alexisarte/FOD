program ej7pr2;
const 
N = 2;
VALOR_ALTO = 32767;
type 
    producto = record
        codigo: Integer;
        nombre: string;
        precio: Real;
        stockActual: Integer;
        stockMinimo: Integer;
    end;

    venta = record
        codProducto: Integer;
        unidadesVendidas: Integer;
    end;

    detalle = File of venta;
    maestro = File of producto;

procedure leerArchivo(var archivo: detalle; var datos: venta);
begin
    if (not Eof(archivo)) then begin
        Read(archivo, datos);
    end
    else begin
        datos.codProducto:= VALOR_ALTO;
    end;
end;

procedure actualizarMaestro(var maestro1: maestro; var detalle1: detalle);
var
    regMaestro: producto;
    regDetalle: venta;
begin
    Assign(detalle1, 'detalle');
    Reset(maestro1);
    Reset(detalle1);
    leerArchivo(detalle1, regDetalle);
    while (regDetalle.codProducto <> VALOR_ALTO) do begin
        Read(maestro1, regMaestro);
        while (regMaestro.codigo <> regDetalle.codProducto) do begin
            Read(maestro1, regMaestro);
        end;
        while (regDetalle.codProducto = regMaestro.codigo) do begin
            regMaestro.stockActual:= regMaestro.stockActual - regDetalle.unidadesVendidas; 
            leerArchivo(detalle1, regDetalle);
        end;
        Seek(maestro1, FilePos(maestro1) - 1);
        Write(maestro1, regMaestro);
    end;
    Close(maestro1);
    Close(detalle1);
end;

procedure listarStockMinimo(var maestro1: maestro);
var
    maestroTxt: Text;
    regMaestro: producto;
begin
    Assign(maestro1, 'stock_minimo.txt');
    Rewrite(maestroTxt);
    Reset(maestro1);
    while (not Eof(maestro1)) do begin
        Read(maestro1, regMaestro);
        if (regMaestro.stockActual < regMaestro.stockMinimo) then begin
            WriteLn(maestroTxt, ' ', regMaestro.codigo, ' ', regMaestro.nombre, ' ', regMaestro.precio,' ', regMaestro.stockActual,
                ' ', regMaestro.stockMinimo);
        end;
    end;
    Close(maestro1);
    Close(maestroTxt);
end;

var
    detalles: vDetalles;
    ventas: regVentas;
    maestro1: maestro;
begin
    Assign(maestro1, 'maestro');
    actualizarMaestro(maestro1, detalles, ventas);
    listarStockMinimo(maestro1);
end.