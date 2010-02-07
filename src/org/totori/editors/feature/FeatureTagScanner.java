package org.totori.editors.feature;

import org.eclipse.jface.text.*;
import org.eclipse.jface.text.rules.*;
import org.totori.editors.ColorManager;
import org.totori.editors.WhitespaceDetector;

public class FeatureTagScanner extends RuleBasedScanner {

	public FeatureTagScanner(ColorManager manager) {
		IToken string =
			new Token(
				new TextAttribute(manager.getColor(IFeatureColorConstants.STRING)));

		IRule[] rules = new IRule[3];

		// Add rule for double quotes
		rules[0] = new SingleLineRule("\"", "\"", string, '\\');
		// Add a rule for single quotes
		rules[1] = new SingleLineRule("'", "'", string, '\\');
		// Add generic whitespace rule.
		rules[2] = new WhitespaceRule(new WhitespaceDetector());

		setRules(rules);
	}
}
