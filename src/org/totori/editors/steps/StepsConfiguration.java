package org.totori.editors.steps;

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

public class StepsConfiguration extends SourceViewerConfiguration {
	private StepsDoubleClickStrategy doubleClickStrategy;
	private StepsTagScanner tagScanner;
	private StepsScanner scanner;
	private ColorManager colorManager;

	public StepsConfiguration(ColorManager colorManager) {
		this.colorManager = colorManager;
	}
	public String[] getConfiguredContentTypes(ISourceViewer sourceViewer) {
		return new String[] {
			IDocument.DEFAULT_CONTENT_TYPE,
			StepsPartitionScanner.STEPS_COMMENT,
			StepsPartitionScanner.STEPS_STRING };
	}
	public ITextDoubleClickStrategy getDoubleClickStrategy(
		ISourceViewer sourceViewer,
		String contentType) {
		if (doubleClickStrategy == null)
			doubleClickStrategy = new StepsDoubleClickStrategy();
		return doubleClickStrategy;
	}

	protected StepsScanner getXMLScanner() {
		if (scanner == null) {
			scanner = new StepsScanner(colorManager);
			scanner.setDefaultReturnToken(
				new Token(
					new TextAttribute(
						colorManager.getColor(IStepsColorConstants.DEFAULT))));
		}
		return scanner;
	}
	protected StepsTagScanner getXMLTagScanner() {
		if (tagScanner == null) {
			tagScanner = new StepsTagScanner(colorManager);
			tagScanner.setDefaultReturnToken(
				new Token(
					new TextAttribute(
						colorManager.getColor(IStepsColorConstants.TAG))));
		}
		return tagScanner;
	}

	public IPresentationReconciler getPresentationReconciler(ISourceViewer sourceViewer) {
		PresentationReconciler reconciler = new PresentationReconciler();
		
		DefaultDamagerRepairer dr =
			new DefaultDamagerRepairer(getXMLTagScanner());
		reconciler.setDamager(dr, StepsPartitionScanner.STEPS_STRING);
		reconciler.setRepairer(dr, StepsPartitionScanner.STEPS_STRING);
		
		dr = new DefaultDamagerRepairer(getXMLScanner());
		reconciler.setDamager(dr, IDocument.DEFAULT_CONTENT_TYPE);
		reconciler.setRepairer(dr, IDocument.DEFAULT_CONTENT_TYPE);
		
		NonRuleBasedDamagerRepairer ndr =
			new NonRuleBasedDamagerRepairer(
				new TextAttribute(
					colorManager.getColor(IStepsColorConstants.COMMENT)));
		reconciler.setDamager(ndr, StepsPartitionScanner.STEPS_COMMENT);
		reconciler.setRepairer(ndr, StepsPartitionScanner.STEPS_COMMENT);

		return reconciler;
	}

}