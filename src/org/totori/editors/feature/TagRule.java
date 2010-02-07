package org.totori.editors.feature;

import org.eclipse.jface.text.rules.*;

public class TagRule extends PatternRule {

	public TagRule(IToken token) {
		super("@", "", token, ' ', true);
	}
	
	protected boolean sequenceDetected(
		ICharacterScanner scanner,
		char[] sequence,
		boolean eofAllowed) {
		int c = scanner.read();
		if (sequence[0] == '@') {
			if (c == '?') {
				// processing instruction - abort
				scanner.unread();
				return false;
			}
			if (c == '!') {
				scanner.unread();
				// comment - abort
				return false;
			}
		} else if (c == ' ') {
			scanner.unread();
		} else if (c == ',') {
			scanner.unread();
		}
		return super.sequenceDetected(scanner, sequence, eofAllowed);
	}

}
