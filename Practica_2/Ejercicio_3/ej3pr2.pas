program ej3pr2;
const
    MAX = 30;
    valorAlto = 32767;
type
    str25 = String[25];
    rango = 0..MAX;

    producto = record
        codigoProducto: Integer;
        nombre: str25;
        descripcion: str25;
        stockDisponible: Integer; 
        stockMinimo: Integer;
        precio: Real;
    end;

    detalle = record
        codigoProducto: Integer;
        cantidadVendida: Integer;
    end;

    archivoDetalle = File of detalle;
    archivoMaestro = File of producto;

    archivosDetalle = array[rango] of archivoDetalle;
    registrosDetalle = array[rango] of detalle;

procedure leer(var archivoDetalle1: archivoDetalle; var dato: detalle);
begin
    if (not Eof(archivoDetalle1)) then
        Read(archivoDetalle1, dato)
    else
        dato.codigoProducto:= valorAlto;
end;

procedure importarMaestro(var productos: archivoMaestro);
var 
    maestro: Text;
    producto1: producto;
begin
    Assign(maestro, 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_3\Productos.txt');
    Rewrite(productos);
    Reset(maestro);
    while not eof(maestro) do begin
        Read(maestro, producto1.codigoProducto, producto1.nombre);
        ReadLn(maestro, producto1.stockDisponible, producto1.stockMinimo, producto1.precio, producto1.descripcion);
        Write(productos, producto1);
    end;
    Close(productos);
    Close(maestro);
end;

procedure leerDetalle(var regDetalle: detalle);
begin
    Write('Ingrese el codigo del producto o 0 para terminar de cargar un archivo: ');
    ReadLn(regDetalle.codigoProducto);
    if (regDetalle.codigoProducto <> 0) then begin
        Write('Ingrese la cantidad vendida: ');
        ReadLn(regDetalle.cantidadVendida);
        WriteLn('--------------------------------------');
    end;
    WriteLn();
end;

procedure crearDetalles(var vectorArchivoDetalle: archivosDetalle);
var
    i: Integer;
    iStr: str25;
    regDetalle: detalle;
begin
    for i:= 1 to MAX do begin
        Str(i, iStr);
        Assign(vectorArchivoDetalle[i], 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_3\detalle'+iStr);
        Rewrite(vectorArchivoDetalle[i]);
        leerDetalle(regDetalle);
        while (regDetalle.codigoProducto <> 0) do begin
            Write(vectorArchivoDetalle[i], regDetalle);
            leerDetalle(regDetalle);
        end;
        Close(vectorArchivoDetalle[i]);
    end;
end;

procedure actualizarMaestro(var productos: archivoMaestro; var vectorRegistroDetalle: registrosDetalle; vectorArchivoDetalle: archivosDetalle);
    
    procedure minimo(var regMinimo: detalle; var vectorRegistroDetalle: registrosDetalle; vectorArchivoDetalle: archivosDetalle);
    var
        posMin, i: Integer;
    begin
        regMinimo.codigoProducto:= valorAlto;
        for i:= 1 to MAX do begin
            if (vectorRegistroDetalle[i].codigoProducto < regMinimo.codigoProducto) then begin
                regMinimo:= vectorRegistroDetalle[i];
                posMin:= i;
            end;
        end;
        if (regMinimo.codigoProducto <> valorAlto) then begin
            leer(vectorArchivoDetalle[posMin], vectorRegistroDetalle[posMin]);
        end;
    end;

    procedure abrirDetalles(var vectorRegistroDetalle:registrosDetalle; var vectorArchivoDetalle: archivosDetalle);
    var
        iStr: str25; 
        i: Integer;
    begin
        for i:= 1 to MAX do begin
            Str(i, iStr);
            Assign(vectorArchivoDetalle[i], 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_3\detalle'+iStr);
            Reset(vectorArchivoDetalle[i]);
            leer(vectorArchivoDetalle[i], vectorRegistroDetalle[i]);
        end;
    end;

var
    regMaestro: producto; regMinimo: detalle; iStr: str25;
    totalCantVendida, codigoActual, i: Integer;
begin
    abrirDetalles(vectorRegistroDetalle, vectorArchivoDetalle);
    Reset(productos);
    Read(productos, regMaestro);
    minimo(regMinimo, vectorRegistroDetalle, vectorArchivoDetalle);
    while (regMinimo.codigoProducto <> valorAlto) do begin     // Procesamos todos los detalles de los productos       
        totalCantVendida:= 0;
        codigoActual:= regMinimo.codigoProducto; 
        while (regMinimo.codigoProducto = codigoActual) do begin
            totalCantVendida:= totalCantVendida + regMinimo.cantidadVendida;
            minimo(regMinimo, vectorRegistroDetalle, vectorArchivoDetalle);
        end;
        while (regMaestro.codigoProducto <> codigoActual)  do begin
            Read(productos, regMaestro);
        end;
        regMaestro.stockDisponible:= regMaestro.stockDisponible - totalCantVendida;
        Seek(productos, FilePos(productos)-1);
        Write(productos, regMaestro);
    end;
    for i:= 1 to MAX do begin
        Close(vectorArchivoDetalle[i]);
    end;
    Close(productos);   
end;

procedure mostrarProducto(producto1: producto);
begin
    WriteLn('Codigo de producto: ', producto1.codigoProducto);
    WriteLn('Nombre: ', producto1.nombre);
    WriteLn('Stock disponible: ', producto1.stockDisponible);
    WriteLn('Stock minimo: ', producto1.stockMinimo);
    WriteLn('Precio: ', producto1.precio:2:2);
    WriteLn('Descripcion: ', producto1.descripcion);
    WriteLn('------------------------------------------------');
    WriteLn();
end;

procedure listarProductos(var productos: archivoMaestro);
var
    producto1: producto;
begin
    Reset(productos);
    while not eof(productos) do begin
        Read(productos, producto1);
        mostrarProducto(producto1);
    end;
    Close(productos);
end;

procedure exportarSinStock(var productos: archivoMaestro);
var
    sinStock: Text;
    producto1: producto;
begin
    Assign(sinStock, 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_3\SinStock.txt');
    Rewrite(sinStock);
    Reset(productos);
    while not Eof(productos) do begin
        Read(productos, producto1);
        if (producto1.stockDisponible < producto1.stockMinimo) then begin
            with producto1 do begin
                writeln(sinStock, 'Producto: ', nombre, ' ', descripcion, ' - stock disponible: ', stockDisponible, ' -$ ', precio:2:2);
            end;
        end;
    end;
    Close(sinStock);
    Close(productos);
end;

var
    productos: archivoMaestro; 
    vectorArchivoDetalle: archivosDetalle;
    vectorRegistroDetalle: registrosDetalle; 
begin
    Assign(productos, 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_3\productos');
    //crearDetalles(vectorArchivoDetalle);
    importarMaestro(productos);
    actualizarMaestro(productos, vectorRegistroDetalle, vectorArchivoDetalle);
    listarProductos(productos);
    exportarSinStock(productos);
end.