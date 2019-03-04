# Facial-Recognition-using-Fourier-Transform

### The Idea
Fourier Transform is just one of many different face recognition methods that have been developed over the last 25 years. 
Comparing to the Machine Learnign approach, Fourier Transform is a very simple and fast algorithm. 
It extracts frequency features of a face, rather than analysing the image pattern using convolutional network.
The Main idea is to find the most variant frequencies in the face database and identify the faces by matching these frequencies.


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

