package org.totori.wizards;

import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.core.resources.IContainer;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IProjectDescription;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.runtime.Platform;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.SubProgressMonitor;
import org.eclipse.jface.dialogs.ErrorDialog;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.IWorkbenchWizard;
import org.eclipse.ui.actions.WorkspaceModifyOperation;
import org.totori.TotoriNature;

/**
 * This is a sample new wizard. Its role is to create a new file 
 * resource in the provided container. If the container resource
 * (a folder or a project) is selected in the workspace 
 * when the wizard is opened, it will accept it as the target
 * container. The wizard creates one file with the extension
 * "totori". If a sample multi-page editor (also available
 * as a template) is registered for the same extension, it will
 * be able to open it.
 */

public class NewTotoriWizard extends Wizard implements INewWizard {
	private NewTotoriWizardPage page;
	private ISelection selection;

	/**
	 * Constructor for NewTotoriWizard.
	 */
	public NewTotoriWizard() {
		super();
		setNeedsProgressMonitor(true);
	}
	
	/**
	 * Adding the page to the wizard.
	 */

	public void addPages() {
		page = new NewTotoriWizardPage(selection);
		addPage(page);
	}

	/**
	 * This method is called when 'Finish' button is pressed in
	 * the wizard. We will create an operation and run it
	 * using wizard as execution context.
	 */
	public boolean performFinish() {
		   try
		   {
		      WorkspaceModifyOperation op = new WorkspaceModifyOperation() {
		         protected void execute(IProgressMonitor monitor)
		         {
		            createProject(monitor != null ?
		                          monitor : new NullProgressMonitor());
		         }
		      };
		      getContainer().run(false,true,op);
		   }
		   catch(InvocationTargetException x)
		   {
		      reportError(x);
		      return false;
		   }
		   catch(InterruptedException x)
		   {
		      reportError(x);
		      return false;
		   }
		   return true; 
	}

   /**
    * This is the actual implementation for project creation.
    * @param monitor reports progress on this object
    */
   protected void createProject(IProgressMonitor monitor)
   {
      monitor.beginTask("Creating the Totori project", 50);
      try
      {
         IWorkspaceRoot root = ResourcesPlugin.getWorkspace().getRoot();
         monitor.subTask("Creating subdirectories");
         IProject project = root.getProject(page.getProjectName());
         IProjectDescription description = ResourcesPlugin.getWorkspace().newProjectDescription(project.getName());
         if(!Platform.getLocation().equals(page.getLocationPath()))
            description.setLocation(page.getLocationPath());
         project.create(description,monitor);
         monitor.worked(20);
         project.open(monitor);
         description = project.getDescription();
         description.setNatureIds(new String[] { TotoriNature.NATURE_ID });
         project.setDescription(description,new SubProgressMonitor(monitor,10));
         IPath projectPath = project.getFullPath(),
	           stepsPath = projectPath.append("steps"),
	           reportsPath = projectPath.append("reports"),
	           reportsAssetsPath = reportsPath.append("assets");
         IFolder stepsFolder = root.getFolder(stepsPath),
                 reportsFolder = root.getFolder(reportsPath),
                 reportsAssetsFolder = root.getFolder(reportsAssetsPath);
         createFolderHelper(stepsFolder,monitor);
         createFolderHelper(reportsFolder,monitor);
         createFolderHelper(reportsAssetsFolder,monitor);
         monitor.worked(10);
         monitor.subTask("Creating files");
         Map<String, InputStream> assets = new HashMap<String, InputStream>();
         assets.put("jquery-1.4.1.min.js", this.getClass().getResourceAsStream("assets/reports/jquery-1.4.1.min.js"));
         assets.put("jquery.lightbox-0.5.css", this.getClass().getResourceAsStream("assets/reports/jquery.lightbox-0.5.css"));
         assets.put("jquery.lightbox-0.5.min.js", this.getClass().getResourceAsStream("assets/reports/jquery.lightbox-0.5.min.js"));
         assets.put("jquery.thumbs.js", this.getClass().getResourceAsStream("assets/reports/jquery.thumbs.js"));
         assets.put("lightbox-blank.gif", this.getClass().getResourceAsStream("assets/reports/lightbox-blank.gif"));
         assets.put("lightbox-btn-close.gif", this.getClass().getResourceAsStream("assets/reports/lightbox-btn-close.gif"));
         assets.put("lightbox-btn-next.gif", this.getClass().getResourceAsStream("assets/reports/lightbox-btn-next.gif"));
         assets.put("lightbox-btn-prev.gif", this.getClass().getResourceAsStream("assets/reports/lightbox-btn-prev.gif"));
         assets.put("lightbox-ico-loading.gif", this.getClass().getResourceAsStream("assets/reports/lightbox-ico-loading.gif"));
         assets.put("search.png", this.getClass().getResourceAsStream("assets/reports/search.png"));
         assets.put("thumbs.css", this.getClass().getResourceAsStream("assets/reports/thumbs.css"));
         assets.put("totori.css", this.getClass().getResourceAsStream("assets/reports/totori.css"));
         for(String assetName : assets.keySet()) {
        	 InputStream in = assets.get(assetName);
             IPath indexPath = reportsAssetsPath.append(assetName);
             IFile indexFile = root.getFile(indexPath);
             indexFile.create(in, false, monitor);
         }
         monitor.worked(20);
      }
      catch(CoreException x)
      {
         reportError(x);
      }
      finally
      {
         monitor.done();
      }
   }
	
	/**
	 * We will accept the selection in the workbench to see if
	 * we can initialize from it.
	 * @see IWorkbenchWizard#init(IWorkbench, IStructuredSelection)
	 */
	public void init(IWorkbench workbench, IStructuredSelection selection) {
		this.selection = selection;
	}

   /**
    * Displays an error that occured during the project creation.
    * @param x details on the error
    */
   private void reportError(Exception x)
   {
      ErrorDialog.openError(getShell(),
                            "eclipse.dialogtitle",
                            "eclipse.projecterror",
                            new Status(IStatus.ERROR,
                            		"org.totori",
                                    IStatus.ERROR,
                                    x.getMessage() != null ? x.getMessage()
                                                           : x.toString(),
                                    x));
   }

   /**
    * Helper method: it recursively creates a folder path.
    * @param folder
    * @param monitor
    * @throws CoreException
    * @see java.io.File#mkdirs()
    */
   private void createFolderHelper(IFolder folder,IProgressMonitor monitor)
      throws CoreException
   {
      if(!folder.exists())
      {
         IContainer parent = folder.getParent();
         if(parent instanceof IFolder
            && (!((IFolder)parent).exists())) {
            createFolderHelper((IFolder)parent,monitor);
         }
         folder.create(false,true,monitor);
      }
   }
}