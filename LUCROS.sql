CREATE FUNCTION LUCROS() RETURNS INT

func_parameter: 
	idOperador INT
	cursorOperadores CURSOR for select IDOPERADOR from operador

characteristic:

	OPEN cursorOperadores;

	cenas : LOOP
		FETCH cursorOperadores INTO idOperador;
		CALL log(concat('the value is', idOperador));
		

	END;
	CLOSE cursorOperadores;