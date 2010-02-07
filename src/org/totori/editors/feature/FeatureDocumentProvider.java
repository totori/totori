package org.totori.editors.feature;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.IDocumentPartitioner;
import org.eclipse.jface.text.rules.FastPartitioner;
import org.eclipse.ui.editors.text.FileDocumentProvider;

public class FeatureDocumentProvider extends FileDocumentProvider {

	protected IDocument createDocument(Object element) throws CoreException {
		IDocument document = super.createDocument(element);
		if (document != null) {
			IDocumentPartitioner partitioner =
				new FastPartitioner(
					new FeaturePartitionScanner(),
					new String[] {
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
						FeaturePartitionScanner.FEATURE_EXAMPLES });
			partitioner.connect(document);
			document.setDocumentPartitioner(partitioner);
		}
		return document;
	}
}