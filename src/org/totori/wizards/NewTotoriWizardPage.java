package org.totori.wizards;

import org.eclipse.jface.viewers.ISelection;
import org.eclipse.ui.dialogs.WizardNewProjectCreationPage;

/**
 * The "New" wizard page allows setting the container for the new file as well
 * as the file name. The page will only accept file name without the extension
 * OR with the extension that matches the expected one (totori).
 */

public class NewTotoriWizardPage extends WizardNewProjectCreationPage {

	/**
	 * Constructor for SampleNewWizardPage.
	 * 
	 * @param pageName
	 */
	public NewTotoriWizardPage(ISelection selection) {
		super("wizardPage");
		setTitle("Totori project");
		setDescription("This wizard creates a new Totori project.");
	}

}