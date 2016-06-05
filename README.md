# cs231a

Install/setup
under the Anthony directory put the MSRA-B directory and the MSRA-B-annot directory
put the drfi code under the Anthony directory as well - note that there are two versions of this code base and we use the older version from 2013
Create a directory called under the directory (should already exist if you pulled from git) and place vlfeat under this directory

MSRA-B : http://research.microsoft.com/en-us/um/people/jiansun/SalientObject/salient_object.htm
ECSSD: http://www.cse.cuhk.edu.hk/leojia/projects/hsaliency/dataset.html

Note: all files expect to be run from the directory they are housed in.
Data set directories should only contain the approproate images, beware of compression artifacts
The MSRA-B data set is formated in a weird way.  The data set is divided into sets of 500 images, so there are 10 subdirectories under the MSRA-B directory.  The code requries that you rename directory "9" to "10" and directory "8" to "9".  This is so that the first part of the image names match the directory they are in.

Use generateSegmentationSaliencyMaps to produce the intermediate saliency maps the DRFI paper uses - the DRFI paper code requires that you use matlab 2013b to run it (2012 wil probably also work, I can only garuntee 2013b)
Then, if the current implementation of the feature extractor requires a model to run, run that file (run bagOfVisualWords)
Then, use createCombinorTrainMatrix to create the feature and correct weight matricies
Then use generateKNNSaliencyMaps or use createClusterModelAdWeights and then generateGMMSaliencyMaps to produce the final saliency maps for our method
Alternatively use createClusterModelAndWeights and then use generateClusterSaliencyMaps to produce the final outputs using our third method

Once you have an output, if you want to evaluate your method look under the Evaluation subfolder and look at quickRunEval.  Modify the inputDir, outputDir, and inputExtension variables to the output you produce
The quickRunEval function looks for a directory called gtDir that has all the ground truth saliency maps, point this to the correct directory once and forget it.

Directory Structure
root
root/train.txt % These files are provided from the drfi website
root/valid.txt
root/test.txt
root/MSRA-B
root/MSRA-B-annot
root/drfi_code_cvpr2013
root/SailencyMapCombinor
root/Evaluation
root/BoundingBoxes
