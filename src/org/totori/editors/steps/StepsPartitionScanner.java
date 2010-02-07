package org.totori.editors.steps;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.jface.text.rules.IPredicateRule;
import org.eclipse.jface.text.rules.IToken;
import org.eclipse.jface.text.rules.MultiLineRule;
import org.eclipse.jface.text.rules.RuleBasedPartitionScanner;
import org.eclipse.jface.text.rules.SingleLineRule;
import org.eclipse.jface.text.rules.Token;

public class StepsPartitionScanner extends RuleBasedPartitionScanner {
	public final static String STEPS_COMMENT = "__feature_comment";
	public final static String STEPS_STRING = "__feature_string";

	public StepsPartitionScanner() {

		IToken comment = new Token(STEPS_COMMENT);
		IToken string = new Token(STEPS_STRING);
		
		List<IPredicateRule> rules = new ArrayList<IPredicateRule>();
		
		// comments
		rules.add(new MultiLineRule("=begin", "=end", comment));
		rules.add(new SingleLineRule("#", "", comment));
		
		// strings
		rules.add(new MultiLineRule("\"", "\"", string, '\\'));
		rules.add(new MultiLineRule("'", "'", string, '\\'));

		setPredicateRules(rules.toArray(new IPredicateRule[1]));
	}
}
