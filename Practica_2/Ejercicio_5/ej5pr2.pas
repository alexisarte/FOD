program ej5pr2;
const

type
    str25 = String[25];

    direccionDetallada = record
        calle: str25;
        nro: str25;
        piso: str25;
        depto: str25;
        ciudad: str25;
    end; 

    progenitor = record
        nombreYApellido: str25;
        dni: str25;
    end;

    nacimiento = record
        nroPartidaNacimiento: str25;
        nombre: str25;
        apellido: str25;
        direccion: direccionDetallada; 
        matriculaMedico: str25;
        madre: progenitor;
        padre: progenitor;
    end;

    fallecimiento = record
        nroPartidaNacimiento: str25;
        DNI: str25;
        nombreYApellido: str25;
        matriculaMedico: str25;
        fechaYHora: str25;
        lugar: str25;
    end;

begin
  
end.