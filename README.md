# Facial-Recognition-using-Fourier-Transform

### The Idea
Fourier Transform is just one of many different face recognition methods that have been developed over the last 25 years. 
Comparing to the Machine Learnign approach, Fourier Transform is a very simple and fast algorithm. 
It extracts frequency features of a face, rather than analysing the image pattern using convolutional network.
The Main idea is to find the most variant frequencies in the face database and identify the faces by matching these frequencies.

### The Math
#### Fourier Transform
<p align="middle">
<a href="https://www.codecogs.com/eqnedit.php?latex=f'_{u,v}&space;=&space;\sum_{y=0}^{M-1}\sum_{x=0}^{N-1}{f_{x,y}}\cdot&space;e^{{2\pi&space;j}{(\frac{x\cdot&space;u}{N}&space;&plus;&space;\frac{y\cdot&space;v}{M})}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?f'_{u,v}&space;=&space;\sum_{y=0}^{M-1}\sum_{x=0}^{N-1}{f_{x,y}}\cdot&space;e^{{2\pi&space;j}{(\frac{x\cdot&space;u}{N}&space;&plus;&space;\frac{y\cdot&space;v}{M})}}" title="f'_{u,v} = \sum_{y=0}^{M-1}\sum_{x=0}^{N-1}{f_{x,y}}\cdot e^{{2\pi j}{(\frac{x\cdot u}{N} + \frac{y\cdot v}{M})}}" /></a>
</p>

The fomular of Fourier Transform means that an image of size N x M can be decomposed into frequencies (of various wave length j) in the directions of u or v. u corresponds to the horizontal direction, while v corresponds to the vetical direction. x and y are the measurements along u and v.

#### Euler's formula
<p align="middle">
<a href="https://www.codecogs.com/eqnedit.php?latex=e^{ix}=cos(x)&space;&plus;sin(x)&space;\cdot&space;i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?e^{ix}=cos(x)&space;&plus;sin(x)&space;\cdot&space;i" title="e^{ix}=cos(x) +sin(x) \cdot i" /></a>
</p>

Euler's formula just says that each wave length is made of cos and sin waves, written in a complex number form, where cos is in the real part and sin is in the imaginary part. 

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


Varicance of frequency in image data         |  Varicance of real frequency            |  Varicance of imaginary frequency
:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/freq.jpg" alt="Smiley face" height="250" width="280">| <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/real.jpg" height="250" width="280">|<img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/imaginary.jpg" height="250" width="280">


<p>
The left most plot is the variance of frequency through out the whole image database. If we decompose this variance plot into "real" and "imaginary " parts, we get the two plots on the right. (The real part is the cos wave, and imaginary part is the cos wave, as we explained in the above). We can see something very interesting: Two bright spot around the origin! Look closely, the brightest part are the most variant frequencies, and they form a diamond shape with a black whole in the center. 
</p>

<p>
Set the threshold for both real and imaginary part, we can filter those brightest spot!
</p>

 <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/threshold2.JPG" height="80" width="500">
<p>
Plot the 1/4 of the "diamond", which is the fourth lower quadrant. 1 indicates the most variant frequencies though out the image database. We can use this matrices as masks to filter out  the most variant frequencies.</p>

<div>
   <div>
  <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/big_variance_real_loc.JPG" alt="Smiley face" height="250" width="300">
  </div>
  <div>
  <img src="https://github.com/dwang0721/Facial-Recognition-using-Fourier-Transform/blob/master/output%20images/big_variance_imag_loc.JPG" alt="Smiley face" height="250" width="300">
  </div>
</div>


### Result


