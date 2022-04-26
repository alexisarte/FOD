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

function existeDistribucion(var distros: archivoDistro; nombre: str50): boolean;
    
    function buscarDistribucion(var distros: archivoDistro; nombre: str50): Integer;
    var
        distro1: distro; pos: Integer;
    begin
        pos:= -1;
        Seek(distros, 0);
        while ((not eof(distros)) and (distro1.nombre <> nombre)) do begin
            read(distros, distro1);
        end;
        if (distro1.nombre = nombre) then begin
            pos:= FilePos(distros) - 1;
        end;
        buscarDistribucion:= pos;
    end;

begin
    if (buscarDistribucion(distros, nombre) = -1) then begin
        existeDistribucion:= False;
    end;
end;


procedure altaDistribucion(var distros: archivoDistro);

    procedure leerDistribucion(var distro1: distro);
    begin
        Write('Ingrese el nombre de la distro: ');
        ReadLn(distro1.nombre);
        Write('Ingrese el anio de lanzamiento: ');
        ReadLn(distro1.lanzamiento);
        Write('Ingrese el numero de version del kernel: ');
        ReadLn(distro1.kernel);
        Write('Ingrese la cantidad de desarrolladores: ');
        ReadLn(distro1.desarrolladores);
        Write('Ingrese la descripcion');
        ReadLn(distro1.descripcion);
    end;

var
    distro1, distro2, distro3: distro;
    desarrolladores, pos: Integer;
begin
    Reset(distros);
    Read(distros, distro1);
    leerDistribucion(distro3);
    if (existeDistribucion(distros, distro3.nombre)) then begin
        WriteLn('Ya existe la distro');
    end
    else begin
        desarrolladores:= distro1.desarrolladores;
        if (desarrolladores < 0) then begin
            pos:= Abs(desarrolladores);
            Seek(distros, pos);
            Read(distros, distro2);
            Seek(distros, pos);
            Write(distros, distro1);
            Seek(distros, 0);
            Write(distros, distro2);
        end;
    end;
end;

procedure bajaDistribucion(var distros: archivoDistro);
var
    distro1, distro2: distro; 
    nombre: str50; pos: Integer;
begin
    Write('Ingrese el nombre de la distro a eliminar: ');
    ReadLn(nombre);
    Read(distros, distro1);
    if (existeDistribucion(distros, nombre)) then begin
        pos:= FilePos(distros) - 1;
        Seek(distros, pos);
        Read(distros, distro2);
        Seek(distros, pos);
        Write(distros, distro1);
        Seek(distros, 0);
        distro2.desarrolladores:= pos * -1;
        Write(distros, distro2);
    end
    else begin
        WriteLn('Distro no existente');
    end;
end;

var
    distros: archivoDistro;
begin

    Assign(distros, 'distribuciones');
end.