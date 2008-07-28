#import "OpenCVTestViewController.h"

#include <opencv/cv.h>
#include <opencv/highgui.h>

@implementation OpenCVTestViewController
@synthesize imageView;

- (void)dealloc {
	[imageView dealloc];
	[super dealloc];
}

#pragma mark -

- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
	CGImageRef imageRef = image.CGImage;

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	IplImage *iplimage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
	CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
													iplimage->depth, iplimage->widthStep,
													colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
	CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(colorSpace);

	IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
	cvCvtColor(iplimage, ret, CV_RGBA2BGR);
	cvReleaseImage(&iplimage);

	return ret;
}

- (UIImage *)UIImageFromIplImage:(IplImage *)image {
	NSLog(@"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s", image->width, image->height, image->depth, image->nChannels, image->widthStep, image->channelSeq);

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
//	CFDataRef data = CFDataCreate(NULL, (const UInt8 *)image->imageData, image->imageSize);
//	CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
	CGImageRef imageRef = CGImageCreate(image->width, image->height,
										image->depth, image->depth * image->nChannels, image->widthStep,
										colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
										provider, NULL, false, kCGRenderingIntentDefault);
	UIImage *ret = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	return ret;
}

#pragma mark -

- (IBAction)loadImage:(id)sender {
//	cvSetErrMode(CV_ErrModeParent);
	NSString *path = [[NSBundle mainBundle] pathForResource:@"lena" ofType:@"jpg"];

	UIImage *uiimage = [UIImage imageWithContentsOfFile:path];
	IplImage *img = [self CreateIplImageFromUIImage:uiimage];
//	IplImage *img = cvLoadImage([path cStringUsingEncoding:NSASCIIStringEncoding], CV_LOAD_IMAGE_COLOR);

	IplImage *image = cvCreateImage(cvGetSize(img), IPL_DEPTH_8U, 3);
	cvCvtColor(img, image, CV_BGR2RGB);
	cvReleaseImage(&img);

	imageView.image = [self UIImageFromIplImage:image];
	cvReleaseImage(&image);
}

- (IBAction)edgeDetect:(id)sender {
//	cvSetErrMode(CV_ErrModeParent);
	NSString *path = [[NSBundle mainBundle] pathForResource:@"lena" ofType:@"jpg"];

	UIImage *uiimage = [UIImage imageWithContentsOfFile:path];
	IplImage *img_color = [self CreateIplImageFromUIImage:uiimage];
	IplImage *img = cvCreateImage(cvGetSize(img_color), IPL_DEPTH_8U, 1);
	cvCvtColor(img_color, img, CV_BGR2GRAY);
	cvReleaseImage(&img_color);
//	IplImage *img = cvLoadImage([path cStringUsingEncoding:NSASCIIStringEncoding], CV_LOAD_IMAGE_GRAYSCALE);

	IplImage *img2 = cvCreateImage(cvGetSize(img), IPL_DEPTH_8U, 1);

	cvCanny(img, img2, 64, 128, 3);
	cvReleaseImage(&img);

	IplImage *image = cvCreateImage(cvGetSize(img2), IPL_DEPTH_8U, 3);
	for(int i=0; i<img2->imageSize; i++) {
		image->imageData[i*3] = image->imageData[i*3+1] = image->imageData[i*3+2] = img2->imageData[i];
	}
	cvReleaseImage(&img2);

	imageView.image = [self UIImageFromIplImage:image];
	cvReleaseImage(&image);
}

#pragma mark -

- (void)loadView {
	[super loadView];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}
@end