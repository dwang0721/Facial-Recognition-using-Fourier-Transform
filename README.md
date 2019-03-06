# Facial-Recognition-using-Fourier-Transform

### The Idea
Fourier Transform is just one of many different face recognition methods that have been developed over the last 25 years. Comparing to the Machine Learning approach, Fourier Transform is a very simple and fast algorithm. It extracts frequency features of a face, rather than analyzing the image pattern using constitutional network. The Main idea is to find the most variant frequencies in the image database and identify the faces by matching these frequencies.

### The Math
#### Fourier Transform
<p align="middle">
<a href="https://www.codecogs.com/eqnedit.php?latex=f'_{u,v}&space;=&space;\sum_{y=0}^{M-1}\sum_{x=0}^{N-1}{f_{x,y}}\cdot&space;e^{{2\pi&space;j}{(\frac{x\cdot&space;u}{N}&space;&plus;&space;\frac{y\cdot&space;v}{M})}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?f'_{u,v}&space;=&space;\sum_{y=0}^{M-1}\sum_{x=0}^{N-1}{f_{x,y}}\cdot&space;e^{{2\pi&space;j}{(\frac{x\cdot&space;u}{N}&space;&plus;&space;\frac{y\cdot&space;v}{M})}}" title="f'_{u,v} = \sum_{y=0}^{M-1}\sum_{x=0}^{N-1}{f_{x,y}}\cdot e^{{2\pi j}{(\frac{x\cdot u}{N} + \frac{y\cdot v}{M})}}" /></a>
</p>

The formula of Fourier Transform means that an image of size N x M can be decomposed into frequencies (of various wave length j) in the directions of u or v. u corresponds to the horizontal direction, while v corresponds to the vertical direction. x and y are the measurements along u and v.

#### Euler's formula
<p align="middle">
<a href="https://www.codecogs.com/eqnedit.php?latex=e^{ix}=cos(x)&space;&plus;sin(x)&space;\cdot&space;i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?e^{ix}=cos(x)&space;&plus;sin(x)&space;\cdot&space;i" title="e^{ix}=cos(x) +sin(x) \cdot i" /></a>
</p>

Euler's formula just says that each wave length is made of cos and sin waves, written in a complex number form, where cos is in the real part and sin is in the imaginary part. 

### Visualization of Fourier Transform
The math may seem to be complicated, but the two formulas explain a simple concept: an image is composed of various frequencies. Here is the example of Fourier Transform:

5 horizontal waves         |  10 horizontal waves      | 15 diagonal  waves        
:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/5%20wave%20sine.jpg" alt="Smiley face" height="230" width="260"> | <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/10%20wave%20sine.jpg" alt="Smiley face" height="230" width="260"> | <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/15%20wave%20sine.jpg" alt="Smiley face" height="230" width="260"> 
FFT of 5 horizontal waves         |  FFT of 10 horizontal waves      | FFT of 15 diagonal  waves        
<img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/5%20wave%20sine%20fft.jpg" alt="Smiley face" height="230" width="260"> | <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/10%20wave%20sine%20fft.jpg" alt="Smiley face" height="230" width="260"> | <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/15%20wave%20sine%20fft.jpg" alt="Smiley face" height="230" width="260"> 

The above images show: After Fourier Transform, each frequency is decomposed into 2 white pixels, symmetrical around the origin (0,0). Higher frequencie are farther away from the origin and their direction aligns with the wave direction. Overlaying the above three images and Forier Transform it, we get this:

Three waves combined | FFT of Three waves combined
:-------------------------:|:-------------------------:
<img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/combined%20wave.jpg" alt="Smiley face" height="300" width="340"> | <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/combined%20wave%20fft.jpg" alt="Smiley face" height="300" width="340"> 

### The Approach
<p>
Take an face image and pad the image into 128 x 128 pixels. Fourier Transform of the image is on the right:
</p>


Input Sample Image         |  FFT of Sample
:-------------------------:|:-------------------------:
<img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/display%20sample.jpg" alt="Smiley face" height="250" width="290"> | <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/sample%20fft.jpg" alt="Smiley face" height="250" width="290">


<p>
However, this is not very helpful. We don't know which frequency in this image is very different from the rest. 
We need to apply Fourier Transform to the whole image database, and find out where is not most variant frequencies. 
</p>


Varicance of frequency in image data         | 
:-------------------------:|
<img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/freq.jpg" alt="Smiley face" height="250" width="300">| 


<p>
The above plot is the variance of frequency through out the whole image database. If we decompose this variance plot into "real" and "imaginary " parts, we get the two plots below. (The real part is the cos wave, and imaginary part is the sin wave, as we explained in the above). We can see something very interesting: Two bright spot around the origin! Look closely, the brightest part are the most variant frequencies, distinguishing the face features of among all images. We can call them feature frequencies! 
</p>

real feature frequency |  imaginary feature frequency
:-------------------------:|:-------------------------:
<img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/real.jpg" height="360" width="410"> | <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/imaginary.jpg" height="360" width="410">


<p>
Set the threshold for both real and imaginary part, we can filter those brightest spot!
</p>

```matlab
% locate the big variance in both parts of the image data
big_variance_real = real_var_map > 0.7;
big_variance_imag = imag_var_map > 0.05;
```

<p>
Plot the 1/4 of the "diamond", which is the fourth lower quadrant. 1 indicates the most variant frequencies though out the image database. We can use the two matrices as masks to filter out the feature frequencies.</p>


Location of real feature frequency        |  Location of imaginary feature frequency
:-------------------------:|:-------------------------:
  <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/big_variance_real_loc.JPG" alt="Smiley face" height="250" width="300"> | <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/big_variance_imag_loc.JPG" alt="Smiley face" height="250" width="300">
 
After deleting these feature frequecies, the input sample lose many details:
 
 original input        |  delete feature frequecies
:-------------------------:|:-------------------------:
  <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/display%20sample.jpg" alt="Smiley face" height="250" width="300"> | <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/ifft_sample.jpg" alt="Smiley face" height="250" width="300">
 
 
<p>
The algorithm only matches the frequency in these positions. The distances between the feature vector of the input face and all faces in the image data are calculated. The smallest distance then gives the closest match.
</p>

```matlab
function x = feature_distance(A, B)
%The distances between the feature vectors
    M = abs(A-B);
    x = sum(sum(M));
end
```

### Result

The Matlab code takes an sample face and out put the face number. So if I use face 7, the algorithm should output 7 in real and imaginary feature vectors. It has above 95% acccuracy. So I tried to rotate and flip the input image and check the accuracy again.

 original input # 17      |  # 17 flip   |   # 17  rotate 90 
:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/display%20sample.jpg" alt="Smiley face" height="250" width="290">|  <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/fliped%20sample_both_match.jpg" alt="Smiley face" height="250" width="300">|<img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/rotate90%20sample_none_match.jpg" alt="Smiley face" height="250" width="300">
output: real 17,  imag 17     |   output: real 17,  imag 9    |   output: real 37,  imag 29 
 avg acc > 95%       |  avg acc > 90%    |  avg acc < 10% 

This algorithm is not very robust to rotations. ¯ \ _ (ツ) _ / ¯



