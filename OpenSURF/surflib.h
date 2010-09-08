/*********************************************************** 
*  --- OpenSURF ---                                        *
*  This library is distributed under the GNU GPL. Please   *
*  contact chris.evans@irisys.co.uk for more information.  *
*                                                          *
*  C. Evans, Research Into Robust Visual Features,         *
*  MSc University of Bristol, 2008.                        *
*                                                          *
************************************************************/

#ifndef SURFLIB_H
#define SURFLIB_H

#include <opencv/cv.h>
#include "integral.h"
#include "fasthessian.h"
#include "surf.h"
#include "ipoint.h"
#include "utils.h"


//! Library function builds vector of described interest points
inline void surfDetDes(IplImage *img,  /* image to find Ipoints in */
                       std::vector<Ipoint> &ipts, /* reference to vector of Ipoints */
                       bool upright = false, /* run in rotation invariant mode? */
                       int octaves = OCTAVES, /* number of octaves to calculate */
                       int intervals = INTERVALS, /* number of intervals per octave */
                       int init_sample = INIT_SAMPLE, /* initial sampling step */
                       float thres = THRES /* blob response threshold */)
{
  // Create integral-image representation of the image
  IplImage *int_img = Integral(img);
  
  // Create Fast Hessian Object
  FastHessian fh(int_img, ipts, octaves, intervals, init_sample, thres);
 
  // Extract interest points and store in vector ipts
  fh.getIpoints();
  
  // Create Surf Descriptor Object
  Surf des(int_img, ipts);

  // Extract the descriptors for the ipts
  des.getDescriptors(upright);

  // Deallocate the integral image
  cvReleaseImage(&int_img);
}


//! Library function builds vector of interest points
inline void surfDet(IplImage *img,  /* image to find Ipoints in */
                    std::vector<Ipoint> &ipts, /* reference to vector of Ipoints */
                    int octaves = OCTAVES, /* number of octaves to calculate */
                    int intervals = INTERVALS, /* number of intervals per octave */
                    int init_sample = INIT_SAMPLE, /* initial sampling step */
                    float thres = THRES /* blob response threshold */)
{
  // Create integral image representation of the image
  IplImage *int_img = Integral(img);

  // Create Fast Hessian Object
  FastHessian fh(int_img, ipts, octaves, intervals, init_sample, thres);

  // Extract interest points and store in vector ipts
  fh.getIpoints();

  // Deallocate the integral image
  cvReleaseImage(&int_img);
}




//! Library function describes interest points in vector
inline void surfDes(IplImage *img,  /* image to find Ipoints in */
                    std::vector<Ipoint> &ipts, /* reference to vector of Ipoints */
                    bool upright = false) /* run in rotation invariant mode? */
{ 
  // Create integral image representation of the image
  IplImage *int_img = Integral(img);

  // Create Surf Descriptor Object
  Surf des(int_img, ipts);

  // Extract the descriptors for the ipts
  des.getDescriptors(upright);
  
  // Deallocate the integral image
  cvReleaseImage(&int_img);
}


#endif