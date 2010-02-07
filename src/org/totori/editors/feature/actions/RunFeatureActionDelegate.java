package org.totori.editors.feature.actions;

import org.eclipse.core.resources.IFile;
import org.eclipse.jface.action.IAction;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.ui.IEditorActionDelegate;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.IFileEditorInput;
import org.totori.actions.LaunchCucumber;

public class RunFeatureActionDelegate implements IEditorActionDelegate {
	
	private IEditorPart targetEditor = null;
	private ISelection selection = null;
	
	public void setActiveEditor(IAction action, IEditorPart targetEditor) {
		this.targetEditor = targetEditor;
	}

	public void run(IAction action) {
		
		try {
			
			String[] features = new String[1];
			features[0] = targetEditor.getEditorInput().getName();
			
			IFile currentFile = ((IFileEditorInput)targetEditor.getEditorInput()).getFile();
			String projectName = currentFile.getProject().getName();
			
			int exitVal = LaunchCucumber.launchFeatures(projectName, features, null);
			
		} catch(Exception e) {
			System.out.println(e.toString());
			e.printStackTrace();
		}
	}

	public void selectionChanged(IAction action, ISelection selection) {
		this.selection = selection;
	}

}
