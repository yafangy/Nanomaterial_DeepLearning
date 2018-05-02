# Nanomaterial_DeepLearning
Semantic neural network to realize pixel-wise classification of 2D nano-material using Matlab.

We present identification of monolayer graphene using semantic pixel-wise segmentation methods. 
We start with optical images of graphene/graphite flakes taken under various laboratory conditions. 
By SLIC superpixelization and DBSCAN clustering, we are able to associate each pixels in the optical image to three classes: "background", "monolayer" and "multilayer". 
We then perform data augmentation and feed the labeled images to a semantic segmentation network for pixel-wise classification. 

(1) Training image pixel-wise labeling

We aim to label the training image pixel-by-pixel with one of the three labels: 1-background; 2-monolayer; 3-multilayer.
Since each image contains millions of pixels, it is a formidable job to label them one by one. 
Here we come up with proper superpixelization and clustering method to greatly reduce the work load and facilitate the labeling process.

First, we resize the image scaled by 0.1 and normalize its color distribution in l*a*b space.
Second, we use simple linear iterative clustering (SLIC) method to merge neighboring pixels into superpixels based on their similarity in position and color space.
Third, we further combine the superpixels according to similarities and achieve the desired level of segmentations of the images by density based spatial clustering of applications with noise (DBSCAN) method.
In this way, we obtain superpixels with meaningful boundaries to allow label assignment.

(2) Data augmentation

Labeled images are randomly cropped into images with 100*100 pixels. 
Transformations such as rotation, reflection, shearing is applied to each cropped image to realize data augmentation.

(3) Semantic segmentation using deep learning

A semantic segmentation network can fulfill pixel-wise classification for given input images, resulting in an image that is segmented by classes.
It can associate each pixel of an image with a class label, i.e. “background”, “monolayer”, “multilayer” in our case.
This SegNet we use in our paper has an encoder network and a corresponding decoder network, followed by a final pixel-wise classification layer. 

Each encoder in the encoder network performs convolution with several filters to produce a set of feature maps, followed with batch normalized. 
Then an element-wise ReLU layer is applied. 
Then a max-pooling layer with a 2*2 window and stride 2 is performed and result in downsampling of the image by a factor of 2. 
The decoder produces produces sparse feature maps in the decoder network by upsampling its input feature maps using the max-unpooling.
This step utilizes memorized max-pooling indices from the corresponding encoder layers. 
Convolution is then performed on these feature maps with trainable decoder filters to produce dense feature maps, followed with batch normalization.
An element-wise ReLU layer is then applied. 
After equal number of upsampling to match the input size, the final output feature maps are fed to a soft-max classifier for pixel-wise classification.
The predicted segmentation is matched to the class with maximum soft-max probability at each pixel.

(4) Test the trained SegNet on test data

With trained SegNet, we can fulfill pixel-wise classification with accuracy > 90% and intersection-over-union > 90%.
