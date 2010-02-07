package org.totori.editors.feature;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.jface.text.rules.IPredicateRule;
import org.eclipse.jface.text.rules.IToken;
import org.eclipse.jface.text.rules.MultiLineRule;
import org.eclipse.jface.text.rules.RuleBasedPartitionScanner;
import org.eclipse.jface.text.rules.SingleLineRule;
import org.eclipse.jface.text.rules.Token;

public class FeaturePartitionScanner extends RuleBasedPartitionScanner {
	public final static String FEATURE_COMMENT = "__feature_comment";
	public final static String FEATURE_STRING = "__feature_string";
	public final static String FEATURE_TAG = "__feature_tag";
	public final static String FEATURE_FEATURE = "__feature_feature";
	public final static String FEATURE_BACKGROUND = "__feature_background";
	public final static String FEATURE_SCENARIO = "__feature_scenario";
	public final static String FEATURE_OUTLINE_SCENARIO = "__feature_outline_scenario";
	public final static String FEATURE_GIVEN = "__feature_given";
	public final static String FEATURE_AND = "__feature_and";
	public final static String FEATURE_WHEN = "__feature_when";
	public final static String FEATURE_THEN = "__feature_then";
	public final static String FEATURE_EXAMPLES = "__feature_examples";

	public FeaturePartitionScanner() {

		IToken comment = new Token(FEATURE_COMMENT);
		IToken string = new Token(FEATURE_STRING);
		IToken tag = new Token(FEATURE_TAG);
		IToken feature = new Token(FEATURE_FEATURE);
		IToken background = new Token(FEATURE_BACKGROUND);
		IToken scenario = new Token(FEATURE_SCENARIO);
		IToken outline_scenario = new Token(FEATURE_OUTLINE_SCENARIO);
		IToken given = new Token(FEATURE_GIVEN);
		IToken and = new Token(FEATURE_AND);
		IToken when = new Token(FEATURE_WHEN);
		IToken then = new Token(FEATURE_THEN);
		IToken examples = new Token(FEATURE_EXAMPLES);
		
		List<IPredicateRule> rules = new ArrayList<IPredicateRule>();
		
		// comments
		rules.add(new MultiLineRule("=begin", "=end", comment));
		rules.add(new SingleLineRule("#", "", comment));
		
		// strings
		rules.add(new MultiLineRule("\"", "\"", string, '\\'));
		rules.add(new MultiLineRule("'", "'", string, '\\'));
		
		// tags
		rules.add(new TagRule(tag));
		
		// cucumber
		rules.add(new SingleLineRule("Feature:", null, feature, ':'));
		rules.add(new SingleLineRule("Background:", null, background, ':'));
		rules.add(new SingleLineRule("Scenario:", null, scenario, ':'));
		rules.add(new SingleLineRule("Outline Scenario:", null, outline_scenario, ':'));
		rules.add(new SingleLineRule("Given", null, given, ' '));
		rules.add(new SingleLineRule("And", null, and, ' '));
		rules.add(new SingleLineRule("When", null, when, ' '));
		rules.add(new SingleLineRule("Then", null, then, ' '));
		rules.add(new SingleLineRule("Examples:", null, examples, ':'));

		setPredicateRules(rules.toArray(new IPredicateRule[1]));
	}
}
