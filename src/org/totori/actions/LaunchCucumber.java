package org.totori.actions;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.regex.Pattern;

import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.preferences.DefaultScope;
import org.eclipse.core.runtime.preferences.IEclipsePreferences;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.totori.preferences.PreferenceConstants;

public class LaunchCucumber {
	
	private static Process runCommand(String projectName, String command) throws IOException {
		Process pr = null;
		Runtime rt = Runtime.getRuntime();
		
		File projectDir = getProjectDirectory(projectName);
		System.out.println("Current directory: "+projectDir);
		System.out.println("Executing command: "+command);
		
		pr = rt.exec(command, null, projectDir);
		
		BufferedReader input = new BufferedReader(new InputStreamReader(pr.getInputStream()));
		
		String line = null;
		
		while((line=input.readLine()) != null) {
			System.out.println(line);
		}
		return pr;
	}
	
	private static String cucumberCommand(String[] features, String[] tags, String reportPath) {
		IEclipsePreferences prefs = new DefaultScope().getNode("org.totori");
		String rubyPath = prefs.get(PreferenceConstants.P_RUBY_PATH, "");
		String command = rubyPath+"\\bin\\ruby \""+rubyPath+"\\bin\\cucumber\"";
		// Features
		for(int i=0; features!=null && i<features.length; i++) {
			String[] parts = features[i].split(Pattern.quote(File.separator));
			command += " features"+File.separator+parts[parts.length-1];
		}
		// Tags
		for(int i=0; tags!=null && i<tags.length; i++) {
			if(i==0) {
				command += " --tags ";
			} else {
				command += ",";
			}
			command += "@"+tags[i];
		}
		// Formatter
		command += " --format TotoriFormatter --out "+reportPath;
		
		return command;
	}
	
	public static int launchFeatures(String projectName) throws IOException, InterruptedException {
		return launchFeatures(projectName, null, null);
	}
	
	public static int launchFeatures(String projectName, String[] features, String[] tags) throws IOException, InterruptedException {
		String reportPath = reportPath();
		String command = cucumberCommand(features, tags, reportPath);
		
		// Run the command
		Process pr = runCommand(projectName, command);
		int exitVal = pr.waitFor();
		System.out.println("Exited with error code "+exitVal);
		
		// Open the report in browser mode
		File projectDir = getProjectDirectory(projectName);
		File report = new File(projectDir, reportPath);
		if(report.exists()) {
			try {
				PlatformUI.getWorkbench().getBrowserSupport().createBrowser("TotoriReportBrowser").openURL(report.toURI().toURL());
			} catch (PartInitException e) {
				e.printStackTrace();
			} catch (MalformedURLException e) {
				e.printStackTrace();
			}
		}
		
		return exitVal;
	}
	
	private static String reportPath() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd-HHmmss");
		String time = formatter.format(new Date(System.currentTimeMillis()));
		return "reports"+File.separator+"report_"+time+".html";
	}
	
	private static File getProjectDirectory(String projectName) {
		return new File(ResourcesPlugin.getWorkspace().getRoot().getLocation().toOSString()+IPath.SEPARATOR+projectName);
	}
}
