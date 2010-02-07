package org.totori.editors.feature;

import org.eclipse.ui.editors.text.TextEditor;
import org.totori.editors.ColorManager;

public class FeatureEditor extends TextEditor {

	private ColorManager colorManager;

	public FeatureEditor() {
		super();
		colorManager = new ColorManager();
		setSourceViewerConfiguration(new FeatureConfiguration(colorManager));
		setDocumentProvider(new FeatureDocumentProvider());
	}
	public void dispose() {
		colorManager.dispose();
		super.dispose();
	}

}
