package org.totori.editors.feature;

import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.ITextDoubleClickStrategy;
import org.eclipse.jface.text.TextAttribute;
import org.eclipse.jface.text.presentation.IPresentationReconciler;
import org.eclipse.jface.text.presentation.PresentationReconciler;
import org.eclipse.jface.text.rules.DefaultDamagerRepairer;
import org.eclipse.jface.text.rules.Token;
import org.eclipse.jface.text.source.ISourceViewer;
import org.eclipse.jface.text.source.SourceViewerConfiguration;
import org.totori.editors.ColorManager;
import org.totori.editors.NonRuleBasedDamagerRepairer;

public class FeatureConfiguration extends SourceViewerConfiguration {
	private FeatureDoubleClickStrategy doubleClickStrategy;
	private FeatureTagScanner tagScanner;
	private FeatureScanner scanner;
	private ColorManager colorManager;

	public FeatureConfiguration(ColorManager colorManager) {
		this.colorManager = colorManager;
	}
	public String[] getConfiguredContentTypes(ISourceViewer sourceViewer) {
		return new String[] {
			IDocument.DEFAULT_CONTENT_TYPE,
			FeaturePartitionScanner.FEATURE_COMMENT,
			FeaturePartitionScanner.FEATURE_STRING,
			FeaturePartitionScanner.FEATURE_TAG,
			FeaturePartitionScanner.FEATURE_FEATURE,
			FeaturePartitionScanner.FEATURE_BACKGROUND,
			FeaturePartitionScanner.FEATURE_SCENARIO,
			FeaturePartitionScanner.FEATURE_OUTLINE_SCENARIO,
			FeaturePartitionScanner.FEATURE_GIVEN,
			FeaturePartitionScanner.FEATURE_AND,
			FeaturePartitionScanner.FEATURE_WHEN,
			FeaturePartitionScanner.FEATURE_THEN,
			FeaturePartitionScanner.FEATURE_EXAMPLES };
	}
	public ITextDoubleClickStrategy getDoubleClickStrategy(
		ISourceViewer sourceViewer,
		String contentType) {
		if (doubleClickStrategy == null)
			doubleClickStrategy = new FeatureDoubleClickStrategy();
		return doubleClickStrategy;
	}

	protected FeatureScanner getXMLScanner() {
		if (scanner == null) {
			scanner = new FeatureScanner(colorManager);
			scanner.setDefaultReturnToken(
				new Token(
					new TextAttribute(
						colorManager.getColor(IFeatureColorConstants.DEFAULT))));
		}
		return scanner;
	}
	protected FeatureTagScanner getXMLTagScanner() {
		if (tagScanner == null) {
			tagScanner = new FeatureTagScanner(colorManager);
			tagScanner.setDefaultReturnToken(
				new Token(
					new TextAttribute(
						colorManager.getColor(IFeatureColorConstants.TAG))));
		}
		return tagScanner;
	}

	public IPresentationReconciler getPresentationReconciler(ISourceViewer sourceViewer) {
		PresentationReconciler reconciler = new PresentationReconciler();
		
		DefaultDamagerRepairer dr =
			new DefaultDamagerRepairer(getXMLTagScanner());
		reconciler.setDamager(dr, FeaturePartitionScanner.FEATURE_STRING);
		reconciler.setRepairer(dr, FeaturePartitionScanner.FEATURE_STRING);
		
		dr = new DefaultDamagerRepairer(getXMLTagScanner());
		reconciler.setDamager(dr, FeaturePartitionScanner.FEATURE_TAG);
		reconciler.setRepairer(dr, FeaturePartitionScanner.FEATURE_TAG);
		
		dr = new DefaultDamagerRepairer(getXMLTagScanner());
		reconciler.setDamager(dr, FeaturePartitionScanner.FEATURE_FEATURE);
		reconciler.setRepairer(dr, FeaturePartitionScanner.FEATURE_FEATURE);
		
		dr = new DefaultDamagerRepairer(getXMLTagScanner());
		reconciler.setDamager(dr, FeaturePartitionScanner.FEATURE_BACKGROUND);
		reconciler.setRepairer(dr, FeaturePartitionScanner.FEATURE_BACKGROUND);
		
		dr = new DefaultDamagerRepairer(getXMLTagScanner());
		reconciler.setDamager(dr, FeaturePartitionScanner.FEATURE_SCENARIO);
		reconciler.setRepairer(dr, FeaturePartitionScanner.FEATURE_SCENARIO);
		
		dr = new DefaultDamagerRepairer(getXMLTagScanner());
		reconciler.setDamager(dr, FeaturePartitionScanner.FEATURE_OUTLINE_SCENARIO);
		reconciler.setRepairer(dr, FeaturePartitionScanner.FEATURE_OUTLINE_SCENARIO);
		
		dr = new DefaultDamagerRepairer(getXMLTagScanner());
		reconciler.setDamager(dr, FeaturePartitionScanner.FEATURE_GIVEN);
		reconciler.setRepairer(dr, FeaturePartitionScanner.FEATURE_GIVEN);
		
		dr = new DefaultDamagerRepairer(getXMLTagScanner());
		reconciler.setDamager(dr, FeaturePartitionScanner.FEATURE_AND);
		reconciler.setRepairer(dr, FeaturePartitionScanner.FEATURE_AND);
		
		dr = new DefaultDamagerRepairer(getXMLTagScanner());
		reconciler.setDamager(dr, FeaturePartitionScanner.FEATURE_WHEN);
		reconciler.setRepairer(dr, FeaturePartitionScanner.FEATURE_WHEN);
		
		dr = new DefaultDamagerRepairer(getXMLTagScanner());
		reconciler.setDamager(dr, FeaturePartitionScanner.FEATURE_THEN);
		reconciler.setRepairer(dr, FeaturePartitionScanner.FEATURE_THEN);
		
		dr = new DefaultDamagerRepairer(getXMLTagScanner());
		reconciler.setDamager(dr, FeaturePartitionScanner.FEATURE_EXAMPLES);
		reconciler.setRepairer(dr, FeaturePartitionScanner.FEATURE_EXAMPLES);
		
		dr = new DefaultDamagerRepairer(getXMLScanner());
		reconciler.setDamager(dr, IDocument.DEFAULT_CONTENT_TYPE);
		reconciler.setRepairer(dr, IDocument.DEFAULT_CONTENT_TYPE);
		
		NonRuleBasedDamagerRepairer ndr =
			new NonRuleBasedDamagerRepairer(
				new TextAttribute(
					colorManager.getColor(IFeatureColorConstants.COMMENT)));
		reconciler.setDamager(ndr, FeaturePartitionScanner.FEATURE_COMMENT);
		reconciler.setRepairer(ndr, FeaturePartitionScanner.FEATURE_COMMENT);

		return reconciler;
	}

}