/*** 1-DECLARATION SECTION ***/
%{
import java.io.IOException;
import compilador.AnalizadorLexico;
import compilador.RegTablaSimbolos;
import compilador.TablaDeSimbolos;
import compilador.TipoToken;
import compilador.Token;
import compilador.log.Logger;
import compilador.log.EventoLog;
import static java.lang.Math.toIntExact;
%}

/*** 2-YACC DECLARATIONS ***/

/* RESERVED KEYS [if else endif print usinteger single for void fun return ]*/
%token _IF _ELSE _ENDIF _PRINT _USINTEGER _SINGLE _FOR _VOID _FUN _RETURN

/* ARITHMETIC OPERATORS [ + - * / ] */
%token _PLUS _MINUS _MULT _DIV

/* ASIGNATION OPERATORS [ := ] */
%token _ASSIGN

/* COMPARATORS [ = < <= > >= != ] */
%token _EQUAL _LESSER _LESSER_OR_EQUAL _GREATER _GREATER_OR_EQUAL _UNEQUAL

/* OTHERS [ ( ) { } , ; ' ] */
%token _LPAREN _RPAREN _LCBRACE _RCBRACE _COMMA _SEMICOLON _QUOTE _IDENTIFIER _CONSTANT

%right _PLUS _MINUS
%right _MULT _DIV
%right _ELSE

%start programa
%%

/*** 3-GRAMMAR FOLLOWS ***/

/**
 * Programa
 * Conjunto de sentencias sin delimitador
 */
programa :
	sentencia
  | programa sentencia
	;

/**
 * Sentencia
 * Declarativas o ejecutables
 */
sentencia :
	bloque_declarativo
  | bloque_ejecutable
;

/**
 * Bloque_declarativo
 * Tira de sentencias declarativas
 */
bloque_declarativo :
  sentencias_de_declaracion_de_variables
  ;

/**
 * Sentencias de declaracion de variables
 * <tipo> <lista_de_variables> ","
 */
sentencias_de_declaracion_de_variables :
	tipo lista_de_variables _COMMA { notify("Sentencia de declaración de variables en línea " + this.lineaActual + "."); }
	;

/**
 * Tipo
 * Tipos _USINTEGER Y _SINGLE
 */
tipo :
	_USINTEGER { this.tipoActual = TipoToken.CONSTANTE_ENTERO_SIN_SIGNO; }
	|	_SINGLE { this.tipoActual = TipoToken.CONSTANTE_FLOTANTE;	}
	;

/**
 * Lista de variables
 * Las variables se separan con ";"
 */
lista_de_variables:
  _IDENTIFIER
	|	_IDENTIFIER _SEMICOLON lista_de_variables
	;

/**
 * Bloque
 * Sentencias ejecutables
 */
bloque :
	bloque bloque_ejecutable
	|	bloque_ejecutable
	;

/**
 * Bloque ejecutable
 *
 */
bloque_ejecutable :
	seleccion {	notify("Sentencia IF en línea " + this.lineaActual + ".");	}
	;

/**
 * Selección
 * if ( <condicion> ) <bloque_de_sentencias> else <bloque_de_sentencias>
 */
seleccion :
	_IF _LPAREN condicion _RPAREN bloque_de_seleccion
	;

/**
 * Bloque de selección
 * Asignaciones, selecciones y sentencias de control
 * @TODO Agregar while
 */
bloque_de_seleccion :
	asignacion
	;

/**
 * Condicion
 * Comparación entre expresiones aritméticas, variables o constantes
 */
condicion :
	expresion comparador expresion
  ;

/**
 * Asignación
 * <_IDENTIFIER> := <expresion>
 */
asignacion:
  _IDENTIFIER _ASSIGN expresion _COMMA
 ;

/**
 * Expresión
 * Aritmética, variable o constante
 */
expresion :
	expresion _PLUS termino
	|	expresion _MINUS termino
	|	termino
	;

/**
 * Término
 * Aritmética, variable o constante
 */
termino :
	termino _MULT factor
	|	termino _DIV factor
	|	factor
	;

/**
 * Factor
 * Aritmética, variable o constante
 */
factor :
	_CONSTANT
	;

/**
 * Comparador
 * <, >, <=, >=, ==, != >>
 */
comparador :
	_LESSER
	|	_GREATER
	|	_LESSER_OR_EQUAL
	|	_GREATER_OR_EQUAL
	|	_EQUAL
	|	_UNEQUAL
	;

%%

/*** 4-CODE ***/
AnalizadorLexico analizadorLexico;
TablaDeSimbolos tablaDeSimbolos;
Logger logger;
Token tokenActual;
TipoToken tipoActual;
int lineaActual;

public void notify(String msg)
{
	System.out.println(msg);
	//this.syntaxLog.addLog(msg, lexAnalyzer.getLineNumber());
}

public void notify(String msg, int line)
{
	//this.syntaxLog.addLog(msg, line);
}

public void tokenfy(String msg, int line)
{
	//this.tokensLog.addLog(msg, line);
}

public void yyerror(String error)
{
	this.logger.log(new EventoLog(error, "Error", this.analizadorLexico.getLineaActual()));
}

public void yyerror(String error, int line)
{
	this.logger.log(new EventoLog(error, "Error", line));
}

public int yylex() throws IOException
{
	this.tokenActual = analizadorLexico.getToken();
	this.lineaActual = analizadorLexico.getLineaActual();
	//RegTablaSimbolos reg = this.tablaDeSimbolos.getRegistro(this.tokenActual.toString());
	//yylval = reg.getTipo();
	//tokenfy(this.tokenActual.toString(), this.tokenActual.getLine());
	//yylval = this.tablaDeSimbolos.createRegTabla(this.tokenActual.toString(), this.tipoToken, lineaToken, posicionToken);
	if (this.tokenActual != null)
	{
		if (this.tokenActual.getId() == -1)
		{
			return 0;
		}

		return toIntExact(this.tokenActual.getId());
	}

	return 0;
}

public Parser(AnalizadorLexico analizadorLexico, TablaDeSimbolos tablaDeSimbolos)
{
	this.analizadorLexico = analizadorLexico;
	this.logger = new Logger();
	this.tablaDeSimbolos = tablaDeSimbolos;
}

public void Run() throws IOException
{
  yyparse();
}
