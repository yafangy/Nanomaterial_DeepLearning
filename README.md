# Nanomaterial_DeepLearning
Semantic neural network to realize pixel-wise classification of 2D nano-material using Matlab.

We present identification of monolayer graphene using semantic pixel-wise segmentation methods. 
We start with optical images of graphene/graphite flakes taken under various laboratory conditions. 
By SLIC superpixelization and DBSCAN clustering, we are able to associate each pixels in the optical image to three classes: "background", "monolayer" and "multilayer". 
We then perform data augmentation and feed the labeled images to a semantic segmentation network for pixel-wise classification. 

Background:

In 2003, one ingenious physicist took a block of graphite, some Scotch tape and a lot of patience and persistence and produced a magnificent new wonder material that is a million times thinner than paper, stronger than diamond, more conductive than copper. 
It is called graphene.
It took the physics community by storm when the first paper appeared in Science magazine in 2004, and it is now one of the most highly cited papers in materials physics (37348 citations up to date).
In 2010, the Nobel Prize in Physics was awarded jointly to Andre Geim and Konstantin Novoselov "for ground breaking experiments regarding the two-dimensional material graphene". 

Despite numerous groundbreaking discoveries and proliferating research on graphene and 2D materials beyond graphene, the technique of producing such high-quality 2D materials remains almost unchanged as it is first invented: mechanical exfoliations.           
It relies on using Scotch tape to repeatedly peel away the the top layer to achieve progressively thinner flakes attached to the tape.
After transferring these flakes onto the surface of a silicon wafer, the flakes with different thicknesses are randomly distributed on a centimeter-scale wafer.
Researchers need to spend hours seating in front of a microscope, in order to search for one eligible flake that are truly one atom thick.
This task is very time-consuming and difficult especially for inexperienced researchers.

The goal of our work is to implement an algorithm that segments the microscopic images into regions labeled as "background", "monolayer", and "multilayer". To achieve this goal, we did the following.

(1) Pixel-wise labeling for training data

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

Reference:

[1] K. S. Novoselov, A. K. Geim, S. V. Morozov, D. Jiang, Y. Zhang, S. V. Dubonos, I. V. Grigorieva and A. A. Firsov. "Electric Field Effect in Atomically Thin Carbon Films". Science 306, 666-669 (2004).

[2] R. Achanta, A. Shaji, K. Smith, A. Lucchi, P. Fua and S. Susstrunk. "SLIC Superpixels Compared to State-of-the-Art Superpixel Methods". PAMI. Vol 34 No 11. November 2012. pp 2274-2281.

[3] Martin Ester, Hans-Peter Kriegel, Jrg Sander, Xiaowei Xu (1996). ”A density-based algorithm for discovering clusters in large spatial databases with noise”. Proceedings of the Second International Con- ference on Knowledge Discovery and Data Mining (KDD-96). AAAI Press. pp. 226-231.

[4] Badrinarayanan V, Kendall A, Cipolla R. "Segnet: A deep convolutional encoder-decoder architecture for image segmentation". arXiv preprint arXiv:1511.00561. 2015.
