program ej4pr2;
const
MAX =  5;
valorAlto = 32767;
type
    str25 = String[25];
    rango = 0..MAX;

    registro = record
        codigoUsuario: Integer;
        fecha: Integer;
        tiempoSesion: Integer;
    end;

    registroTotal = record
        codigoUsuario: Integer;
        tiempoTotal: Integer;
    end;

    archivoDetalle = File of registro;
    archivoMaestro = File of registroTotal;

    archivosDetalle = array[rango] of archivoDetalle;
    registrosDetalle = array[rango] of registro;

procedure leerDetalle(var regDetalle: registro);
begin
    Write('Ingrese el codigo de usuario o 0 para terminar de cargar un archivo: ');
    ReadLn(regDetalle.codigoUsuario);
    if (regDetalle.codigoUsuario <> 0) then begin
        Write('Ingrese la fecha: ');
        ReadLn(regDetalle.fecha);
        Write('Ingrese el tiempo de sesion: ');
        ReadLn(regDetalle.tiempoSesion);
        WriteLn('-------------------------------------------------------------------------');
    end;
    WriteLn();
end;

procedure crearDetalles(var vectorArchivoDetalle: archivosDetalle);
var
    i: Integer;
    iStr: str25;
    regDetalle: registro;
begin
    for i:= 1 to MAX do begin
        Str(i, iStr);
        Assign(vectorArchivoDetalle[i], 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_4\detalle'+iStr);
        Rewrite(vectorArchivoDetalle[i]);
        leerDetalle(regDetalle);
        while (regDetalle.codigoUsuario <> 0) do begin
            Write(vectorArchivoDetalle[i], regDetalle);
            leerDetalle(regDetalle);
        end;
        Close(vectorArchivoDetalle[i]);
    end;
end;

procedure leer(var archivoDetalle1: archivoDetalle; var dato: registro);
begin
    if (not Eof(archivoDetalle1)) then begin 
        Read(archivoDetalle1, dato) 
    end
    else begin 
        dato.codigoUsuario:= valorAlto 
    end;
end;

procedure generarArchivoMaestro(var registros: archivoMaestro; var vectorRegistroDetalle: registrosDetalle;
    vectorArchivoDetalle: archivosDetalle);
    
    procedure minimo(var regMinimo: registro; var vectorRegistroDetalle: registrosDetalle; vectorArchivoDetalle: archivosDetalle);
    var
        posMin, i: Integer;
    begin
        regMinimo.codigoUsuario:= valorAlto;
        for i:= 1 to MAX do begin
            if (vectorRegistroDetalle[i].codigoUsuario < regMinimo.codigoUsuario) then begin
                regMinimo:= vectorRegistroDetalle[i];
                posMin:= i;
            end;
        end;
        if (regMinimo.codigoUsuario <> valorAlto) then begin
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
            Assign(vectorArchivoDetalle[i], 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_4\detalle'+iStr);
            Reset(vectorArchivoDetalle[i]);
            leer(vectorArchivoDetalle[i], vectorRegistroDetalle[i]);
        end;
    end;

var
    regMaestro: registroTotal; regMinimo: registro; iStr: str25;
    i: Integer;
begin
    abrirDetalles(vectorRegistroDetalle, vectorArchivoDetalle);
    Rewrite(registros);
    minimo(regMinimo, vectorRegistroDetalle, vectorArchivoDetalle);
    while (regMinimo.codigoUsuario <> valorAlto) do begin     // Procesamos todos los detalles de los registros       
        regMaestro.codigoUsuario:= regMinimo.codigoUsuario; 
        regMaestro.tiempoTotal:= 0;
        while (regMinimo.codigoUsuario = regMaestro.codigoUsuario) do begin
            regMaestro.tiempoTotal:= regMaestro.tiempoTotal + regMinimo.tiempoSesion;
            minimo(regMinimo, vectorRegistroDetalle, vectorArchivoDetalle);
        end;
        Write(registros, regMaestro);
    end;
    for i:= 1 to MAX do begin
        Close(vectorArchivoDetalle[i]);
    end;
    Close(registros);   
end;

procedure mostrarRegistro(registro1: registroTotal);
begin
    WriteLn('Codigo de usuario: ', registro1.codigoUsuario);
    WriteLn('Tiempo total de sesiones abiertas: ', registro1.tiempoTotal);
    WriteLn('------------------------------------------------');
    WriteLn();
end;

procedure listarRegistros(var registros: archivoMaestro);
var
    registro1: registroTotal;
begin
    Reset(registros);
    while not eof(registros) do begin
        Read(registros, registro1);
        mostrarRegistro(registro1);
    end;
    Close(registros);
end;

var
    registros: archivoMaestro;
    vectorArchivoDetalle: archivosDetalle;
    vectorRegistroDetalle: registrosDetalle;
begin
    Assign(registros, 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_4\maestro');
    // crearDetalles(vectorArchivoDetalle);
    generarArchivoMaestro(registros, vectorRegistroDetalle, vectorArchivoDetalle);
    listarRegistros(registros);
end.