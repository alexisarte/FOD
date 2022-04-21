program ej7pr1;
type
    str25 = String[25];
  
    novela = record
        codigo: integer;
        precio: real;
        genero: str25;
        nombre: str25;
    end;

    archivo = File of novela;

function menu(): integer;
begin
    writeln('Elige una opcion: ');
    writeln('1. Crear archivo');
    writeln('2. Abrir archivo');
    writeln('0. Salir');
    writeln();
    readln(menu);
    writeln();
end;

function subMenu(): integer;
begin
    writeln('1. Agregar una novela.');
    writeln('2. Modificar una existente.');
    writeln('0. Regresar');
    writeln();
    readln(subMenu);
    writeln();
end;

procedure leerNovela(var novela1: novela);
begin
    write('Ingrese el codigo de la novela: '); readln(novela1.codigo);
    if (novela1.codigo <> 00) then begin
        write('Ingrese el precio: '); readln(novela1.precio);
        write('Ingrese el genero: '); readln(novela1.genero);
        writeln('Ingrese el nombre: '); readln(novela1.nombre);
        writeln('=======================================');
    end;
    writeln();
end;

procedure importarNovelas(var novelas: archivo);
var
    novela1: novela;
    novelasTexto: Text;
begin
    assign(novelasTexto, 'data/novelas.txt');
    reset(novelasTexto);
    rewrite(novelas);
    while not eof(novelasTexto) do begin 
        readln(novelasTexto, novela1.codigo, novela1.precio, novela1.genero);
        readln(novelasTexto, novela1.nombre);
        write(novelas, novela1);
    end; 
    close(novelas);
    close(novelasTexto);
end;

procedure agregarNovela(var novelas: archivo);
var
    novela1: novela;
begin
    reset(novelas);
    seek(novelas, filesize(novelas));
    leernovela(novela1);
    write(novelas, novela1);
    close(novelas);
end;

procedure modificarNovela(var novelas: archivo);
var
    novela1: novela; name: str25;
begin
    write('Ingrese el nombre de la novela que desea modificar: ');
    readln(name);
    reset(novelas);
    read(novelas, novela1);
    while ((not eof (novelas)) and (name <> novela1.nombre)) do begin
        read(novelas, novela1);
    end;
    if (name = novela1.nombre) then begin
        WriteLn('Ingrese los nuevos datos: ');
        leernovela(novela1);
        seek(novelas, filepos(novelas)-1); 
        write(novelas, novela1);
    end
    else
    begin WriteLn('novela no encontrada') end;
    WriteLn();
    close(novelas);
end;

var
    opcion, subOpcion: integer;
    nombreFisico: String[25];
    novelas: archivo;
begin
    write('Ingrese el nombre del archivo a crear o utilizar: ');
    readln(nombreFisico);
    assign(novelas, nombreFisico);
    writeln();
    repeat
        opcion:= menu();
        case opcion of 
            1: begin importarNovelas(novelas) end;
            2: begin
                subOpcion:= submenu();  
                while (subOpcion <> 0) do begin
                    case subOpcion of
                        1: begin agregarNovela(novelas) end;
                        2: begin modificarNovela(novelas) end;
                        else begin writeln('Opcion no reconocida');
                            writeln();
                        end;
                    end;
                    subOpcion:= submenu();
                end;
            end;
            0: begin writeln('Hasta pronto!') end
            else begin writeln('Opcion no reconocida');
                writeln();
            end;
        end;
    until(opcion = 0);
end.
