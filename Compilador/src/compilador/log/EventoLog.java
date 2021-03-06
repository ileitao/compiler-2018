package compilador.log;

/**
 * 
 * @author leandro
 *
 */
public class EventoLog {

	// Identificadores del tipo de evento ocurrido (Si fueran enum quedaria mejor)
	public static final String ERROR = "ERROR";
	public static final String WARNING = "WARNING";

	// Linea dentro del archivo en la que se encuentra el error
	private int linea;
	private int posicion;
	
	// Tipo de evento ocurrido: Error o Warning
	private String tipo;
	
	// Mensaje del evento
	private String mensaje;

	public EventoLog(String mensaje, String tipo, int linea, int posicion) {
		this.mensaje = mensaje;
		this.tipo = tipo;
		this.linea = linea;
		this.posicion = posicion;
	}

	/**
	 * @return the mensaje
	 */
	public String getMensaje() {
		return mensaje;
	}

	/**
	 * @param mensaje
	 *            the mensaje to set
	 */
	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}

	/**
	 * @return the tipo
	 */
	public String getTipo() {
		return tipo;
	}

	/**
	 * @param tipo
	 *            the tipo to set
	 */
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public int getLinea() {
		return linea;
	}

	public void setLinea(int linea) {
		this.linea = linea;
	}
	
	public int getPosicion() {
		return posicion;
	}

	public void setPosicion(int posicion) {
		this.posicion = posicion;
	}

	@Override
	public String toString() {
		return "EventoLog [linea=" + linea + ", posicion=" + posicion + ", tipo=" + tipo + ", mensaje=" + mensaje + "]";
	}

}
