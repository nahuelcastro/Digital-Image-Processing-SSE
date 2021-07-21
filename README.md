This group project consists of the implementation of three Image filters using SSE Instructions (Streaming SIMD Extensions) of the Intel x86-64 architecture, carried out for the subject "Organization Of The Computer II" at the University of Buenos Aires. 


## Introduction

The objective of this project is to work with the SIMD (Single Instruction Multiple Data) instruction set of the Intel IA-32 (x86-64) architecture. These instructions allow us to process multiple data in parallel, which saves us from having to use a larger number of instructions and operate with less content at the same time.

With this objective in mind, we implement different graphic filters that operate on color images. For each filter we have an implementation in C language, whose algorithm operates pixel by pixel, and an implementation in ASM language using instructions from the SIMD model.


What we propose to test is whether, given these implementations in ASM and C, the implementation in C language will always be less performant than one implemented in ASM with SIMD instructions. Since this model allows us to operate on multiple pixels simultaneously, we believe that there would be an improvement in execution speed. The question would be, if there is, how much difference in speed is there between the two implementations?

## Image format and considerations

The image format on which the implementations work is BMP. The images are considered as an array of pixels, stored in memory from left to right row by row
Each pixel consists of four components that are RGBA (Red, Blue, Green, Alpha) which occupy one byte each. The value of these components is between 0 and 255. If this margin is exceeded, the value will be saturated hardcoded to its maximum or minimum as appropriate.

The BMP format would imply that the image bitmap is read from bottom to top and left to right. But in this project, the same was reversed, so that the lines of the images are read from top to bottom and from left to right.

Additionally, the width of all images greater than 16 pixels and divisible by 8 is considered.


## Filters
We implement three filters on which we base our report and carry out our analysis. Here is a brief description of each filter.

### Ghost Image
This filter generates a ghost effect on the image. For this, the same original gray-scale image is used and twice the size. The horizontal and vertical offset where the ghost image should be located as a parameter can be passed as a parameter as long as they are smaller than the image size.

### Border color
This filter highlights the edges and silhouettes of the image through a series of calculations between the pixels that surround each pixel. It does this by summing the differences between the components of the three pairs of pixels that surround the pixel both vertically and horizontally. The result of this procedure corresponds to edge detection.


### Reinforce shine

This filter increases and decreases the brightness of an image based on the brightness it already had. Two thresholds are passed per parameter, if the pixel exceeds the upper threshold, the brightness is increased, if the pixel is below the lower threshold, the brightness is decreased. The resulting effect is a differentiated shine enhancement.

## Examples of applying all three filters to an image

![Examples Image](https://raw.githubusercontent.com/nahuelcastro/Digital-Image-Processing-SSE/img/filters_examples.png)
