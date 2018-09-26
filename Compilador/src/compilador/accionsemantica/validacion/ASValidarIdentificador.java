package compilador.accionsemantica.validacion;

import compilador.AnalizadorLexico;
import compilador.TipoToken;
import compilador.log.EventoLog;

public class ASValidarIdentificador implements Validable {

	private final int LARGO_MAXIMO = 25;
	
	public ASValidarIdentificador() {
	}

	@Override
	public boolean evaluar(AnalizadorLexico aLexico, TipoToken tipoToken) {
		
		//Devuelve false en caso de superar el largo permitido
		return (aLexico.getLexemaParcial().length() <= LARGO_MAXIMO);
		
	}

	@Override
	public void procesar(AnalizadorLexico aLexico) {
		
		String lexema = aLexico.getLexemaParcial().toString();
		int linea = aLexico.getLineaActual();
		
		aLexico.getLogger().log(new EventoLog("El identificador" + lexema 
				+ " supera el largo maximo permitido " + LARGO_MAXIMO + " caracteres.", EventoLog.ERROR, linea));
		
		aLexico.reiniciar();
	}

}
