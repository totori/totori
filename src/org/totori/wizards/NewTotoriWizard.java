package org.totori.wizards;

import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import org.eclipse.core.resources.IContainer;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IProjectDescription;
import org.eclipse.core.resources.IResource;
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
         monitor.subTask("Defining the nature of the project");
         IProject project = root.getProject(page.getProjectName());
         IProjectDescription description = ResourcesPlugin.getWorkspace().newProjectDescription(project.getName());
         if(!Platform.getLocation().equals(page.getLocationPath()))
            description.setLocation(page.getLocationPath());
         project.create(description,monitor);
         monitor.worked(10);
         project.open(monitor);
         description = project.getDescription();
         description.setNatureIds(new String[] { TotoriNature.NATURE_ID });
         project.setDescription(description,new SubProgressMonitor(monitor,10));
         monitor.subTask("Creating subdirectories");
         createFolderHelper(root.getFolder(project.getFullPath().append("config")), monitor);
         createFolderHelper(root.getFolder(project.getFullPath().append("ext")), monitor);
         createFolderHelper(root.getFolder(project.getFullPath().append("ext").append("nircmd")), monitor);
         createFolderHelper(root.getFolder(project.getFullPath().append("ext").append("watir")), monitor);
         createFolderHelper(root.getFolder(project.getFullPath().append("features")), monitor);
         createFolderHelper(root.getFolder(project.getFullPath().append("features").append("plugins")), monitor);
         createFolderHelper(root.getFolder(project.getFullPath().append("features").append("plugins").append("sap-ep")), monitor);
         createFolderHelper(root.getFolder(project.getFullPath().append("features").append("plugins").append("sap-ep").append("examples")), monitor);
         createFolderHelper(root.getFolder(project.getFullPath().append("features").append("plugins").append("sap-ep").append("steps")), monitor);
         createFolderHelper(root.getFolder(project.getFullPath().append("features").append("steps")), monitor);
         createFolderHelper(root.getFolder(project.getFullPath().append("features").append("support")), monitor);
         createFolderHelper(root.getFolder(project.getFullPath().append("reports")), monitor);
         createFolderHelper(root.getFolder(project.getFullPath().append("reports").append("assets")), monitor);
         createFolderHelper(root.getFolder(project.getFullPath().append("reports").append("screens")), monitor);
         project.setDescription(description,new SubProgressMonitor(monitor,10));
         monitor.subTask("Creating files");
         Vector<String> assets = new Vector<String>();
         assets.add("config/myconfig.example.yml");
         assets.add("ext/nircmd/nircmd.chm");
         assets.add("ext/nircmd/nircmd.exe");
         assets.add("ext/nircmd/nircmdc.exe");
         assets.add("ext/watir/AutoItX3.dll");
         assets.add("ext/watir/IEDialog.dll");
         assets.add("ext/watir/README");
         assets.add("ext/watir/win32ole.so");
         assets.add("features/plugins/sap-ep/portal.rb");
         assets.add("features/plugins/sap-ep/examples/001_connexion_portail.i18n.fr.feature");
         assets.add("features/plugins/sap-ep/examples/001_logging_in_and_off.feature");
         assets.add("features/plugins/sap-ep/examples/002_custom_wdp_application.feature");
         assets.add("features/plugins/sap-ep/examples/003_user_administration.feature");
         assets.add("features/plugins/sap-ep/steps/portal_basic_steps.i18n.fr.rb");
         assets.add("features/plugins/sap-ep/steps/portal_basic_steps.rb");
         assets.add("features/support/env.rb");
         assets.add("features/support/functions.rb");
         assets.add("features/support/screenshots.rb");
         assets.add("features/support/totori_formatter.rb");
         assets.add("reports/assets/jquery-1.4.1.min.js");
         assets.add("reports/assets/jquery.lightbox-0.5.css");
         assets.add("reports/assets/jquery.lightbox-0.5.min.js");
         assets.add("reports/assets/jquery.thumbs.js");
         assets.add("reports/assets/lightbox-blank.gif");
         assets.add("reports/assets/lightbox-btn-close.gif");
         assets.add("reports/assets/lightbox-btn-next.gif");
         assets.add("reports/assets/lightbox-btn-prev.gif");
         assets.add("reports/assets/lightbox-ico-loading.gif");
         assets.add("reports/assets/search.png");
         assets.add("reports/assets/thumbs.css");
         assets.add("reports/assets/totori.css");
         for(String asset : assets) {
        	 String resource = "/assets/"+asset;
        	 InputStream stream = this.getClass().getResourceAsStream(resource);
        	 System.out.println(resource + " : " + stream);
             IPath path = project.getFullPath();
             for(String dir : asset.split("/")) {
            	 path = path.append(dir);
             }
             IFile file = root.getFile(path);
             //file.getFullPath().toFile().mkdirs();
             //file.setCharset("utf-8", monitor);
             file.create(stream, false, monitor);
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
   private void createFolderHelper(final IFolder folder,final IProgressMonitor monitor)
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