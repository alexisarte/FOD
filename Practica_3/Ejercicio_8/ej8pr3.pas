program ej8pr3;
type
    str50 = string[50];
    
    distro = record
        nombre: str50;
        lanzamiento: Integer;
        kernel: Integer;
        desarrolladores: Integer;
        descripcion: str50;
    end;

    archivoDistro = File of distro;

procedure buscarDistribucion(var distros: archivoDistro; nombre: str50; var pos: Integer);
var
    distro1: distro;
begin
    reset(distros);
    while ((not eof(distros)) and (distro1.nombre <> nombre)) do begin
        read(distros, distro1);
    end;
    if ((distro1.nombre = nombre) and (distro1.desarrolladores > 0)) then begin
        pos:= (FilePos(distros)) - 1;
    end;
    close(distros);
end;

procedure existeDistribucion(var distros: archivoDistro; nombre: str50; var existe: boolean);
var 
    pos: integer;
begin
    pos:= 0;
    buscarDistribucion(distros, nombre, pos);
    if (pos <> 0) then begin
        existe:= true;
    end
end;

procedure altaDistribucion(var distros: archivoDistro);

    procedure leerDistribucion(var distro1: distro);
    begin
        Write('Ingrese el nombre de la distro: '); ReadLn(distro1.nombre);
        Write('Ingrese el anio de lanzamiento: '); ReadLn(distro1.lanzamiento);
        Write('Ingrese el numero de version del kernel: '); ReadLn(distro1.kernel);
        Write('Ingrese la cantidad de desarrolladores: '); ReadLn(distro1.desarrolladores); 
        Write('Ingrese la descripcion'); ReadLn(distro1.descripcion);
    end;

var
    distro1, distro2, distro3: distro;
    desarrolladores, pos: Integer;
    existe: boolean;
begin
    Reset(distros);
    Read(distros, distro1);
    leerDistribucion(distro3);
    existeDistribucion(distros, distro3.nombre, existe);
    if (existe) then begin
        WriteLn('Ya existe la distro');
    end
    else begin
        desarrolladores:= distro1.desarrolladores;
        if (desarrolladores < 0) then begin
            pos:= Abs(desarrolladores); //
            Seek(distros, pos);
            Read(distros, distro2);
            Seek(distros, pos); //Se posiciona en la posicion de la distro anterior
            Write(distros, distro1);
            Seek(distros, 0);
            Write(distros, distro2);
        end
        else if (desarrolladores = 0) then begin
                Seek(distros, FileSize(distros));
                Write(distros, distro3);
            end;
    end;
end;

procedure bajaDistribucion(var distros: archivoDistro);
var
    distro1, distroAEliminar: distro; 
    nombre: str50; pos: Integer;
    existe: boolean;
begin
    Write('Ingrese el nombre de la distro a eliminar: ');
    ReadLn(nombre);
    Reset(distros);
    Read(distros, distro1);
    existeDistribucion(distros, nombre, existe);
    if (existe) then begin
        buscarDistribucion(distros, nombre, pos);
        Seek(distros, pos); //Se posiciona en la posicion de la distro a eliminar
        Read(distros, distroAEliminar); //Se lee la distro a eliminar
        Seek(distros, pos); //Se posiciona en la posicion de la distro a eliminar
        Write(distros, distro1); //Copio el antiguo registro cabeza de la lista
        Seek(distros, 0); //Se posiciona al principio del archivo
        distroAEliminar.desarrolladores:= pos * -1; //Se le asigna un valor negativo al desarrolladores para que sea una distro eliminada
        Write(distros, distroAEliminar); //Se escribe la distro eliminada en la cabecera del archivo
    end
    else begin
        WriteLn('Distro no existente');
    end;
    Close(distros);
end;

var
    distros: archivoDistro;
begin
    Assign(distros, 'distribuciones');
end.