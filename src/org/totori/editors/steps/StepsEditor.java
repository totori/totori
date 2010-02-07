package org.totori.editors.steps;

import org.eclipse.ui.editors.text.TextEditor;
import org.totori.editors.ColorManager;

public class StepsEditor extends TextEditor {

	private ColorManager colorManager;

	public StepsEditor() {
		super();
		colorManager = new ColorManager();
		setSourceViewerConfiguration(new StepsConfiguration(colorManager));
		setDocumentProvider(new StepsDocumentProvider());
	}
	public void dispose() {
		colorManager.dispose();
		super.dispose();
	}

}
