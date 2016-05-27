# cs231a

Use generateSegmentationSaliencyMaps to produce the intermediate saliency maps the DRFI paper uses
Then, use createCombinorTrainMatrix to create the feature and correct weight matricies
Then use generateKNNSaliencyMaps or use generateGMMSaliencyMaps to produce the final saliency maps for our method
Alternatively use createClusterModelAndWeights and then use generateClusterSaliencyMaps to produce the third set of saliency maps
Once you have an output, if you want to evaluate your method look under the Evaluation subfolder and look at quickRunEval.  Modify the inputDir, outputDir, and inputExtension variables to the output you produce
