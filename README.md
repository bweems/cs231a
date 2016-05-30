# cs231a

Install/setup
under the Anthony directory put the MSRA-B directory and the MSRA-B-annot direcotry
put the drfi code under the Anthony dirctory as well

Note: all files expect to be run from the directory they are housed in.
Data set directories should only contain the approproate images, beware of compression artifacts

Use generateSegmentationSaliencyMaps to produce the intermediate saliency maps the DRFI paper uses
Then, use createCombinorTrainMatrix to create the feature and correct weight matricies
Then use generateKNNSaliencyMaps or use generateGMMSaliencyMaps to produce the final saliency maps for our method
Alternatively use createClusterModelAndWeights and then use generateClusterSaliencyMaps to produce the third set of saliency maps

Once you have an output, if you want to evaluate your method look under the Evaluation subfolder and look at quickRunEval.  Modify the inputDir, outputDir, and inputExtension variables to the output you produce
The quickRunEval function looks for a directory called gtDir that has all the ground truth saliency maps, point this to the correct directory once and forget it.


