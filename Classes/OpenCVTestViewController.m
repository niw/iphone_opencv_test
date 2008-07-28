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
#pragma mark OpenCV Support Methods

// NOTE you SHOULD cvReleaseImage() for the return value when end of the code.
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

// NOTE You should convert color mode as RGB before passing to this function
- (UIImage *)UIImageFromIplImage:(IplImage *)image {
	NSLog(@"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s", image->width, image->height, image->depth, image->nChannels, image->widthStep, image->channelSeq);

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
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
#pragma mark IBAction

- (IBAction)loadImage:(id)sender {
/* // Testing IplImage <-> UIImage Conversion
	cvSetErrMode(CV_ErrModeParent);
	NSString *path = [[NSBundle mainBundle] pathForResource:@"lena" ofType:@"jpg"];

	// Load UIImage and convert to IplImage
	UIImage *uiimage = [UIImage imageWithContentsOfFile:path];
	IplImage *img = [self CreateIplImageFromUIImage:uiimage];

	// Convert IplImage(BGR) to IplImage(RGB) then convert to UIImage to show
	IplImage *image = cvCreateImage(cvGetSize(img), IPL_DEPTH_8U, 3);
	cvCvtColor(img, image, CV_BGR2RGB);
	cvReleaseImage(&img);

	imageView.image = [self UIImageFromIplImage:image];
	cvReleaseImage(&image);
*/
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
													otherButtonTitles:@"Use Photo from Library", @"Take Photo with Camera", @"Use Default Lena", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (IBAction)edgeDetect:(id)sender {
	cvSetErrMode(CV_ErrModeParent);
	if(imageView.image) {
		// Create grayscale IplImage from UIImage
		IplImage *img_color = [self CreateIplImageFromUIImage:imageView.image];
		IplImage *img = cvCreateImage(cvGetSize(img_color), IPL_DEPTH_8U, 1);
		cvCvtColor(img_color, img, CV_BGR2GRAY);
		cvReleaseImage(&img_color);
		
		// Detect edge
		IplImage *img2 = cvCreateImage(cvGetSize(img), IPL_DEPTH_8U, 1);
		cvCanny(img, img2, 64, 128, 3);
		cvReleaseImage(&img);
		
		// Convert black and whilte to 24bit image then convert to UIImage to show
		IplImage *image = cvCreateImage(cvGetSize(img2), IPL_DEPTH_8U, 3);
		for(int i=0; i<img2->imageSize; i++) {
			image->imageData[i*3] = image->imageData[i*3+1] = image->imageData[i*3+2] = img2->imageData[i];
		}
		cvReleaseImage(&img2);
		imageView.image = [self UIImageFromIplImage:image];
		cvReleaseImage(&image);
	}
}

- (IBAction)faceDetect:(id)sender {
	cvSetErrMode(CV_ErrModeParent);
	if(imageView.image) {
		IplImage *image = [self CreateIplImageFromUIImage:imageView.image];

		// Load XML
		NSString *path = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_default" ofType:@"xml"];
		CvHaarClassifierCascade* cascade = (CvHaarClassifierCascade*)cvLoad([path cStringUsingEncoding:NSASCIIStringEncoding], NULL, NULL, NULL);
		CvMemStorage* storage = cvCreateMemStorage(0);

		// Detect faces and draw rectangle on them
		CvSeq* faces = cvHaarDetectObjects(image, cascade, storage, 1.1f, 3, 0, cvSize(0, 0));
		for(int i = 0; i < faces->total; i++) {
			CvRect face_rect = *(CvRect*)cvGetSeqElem(faces, i);
			cvRectangle(image, cvPoint(face_rect.x, face_rect.y), cvPoint(face_rect.x + face_rect.width, face_rect.y + face_rect.height), CV_RGB(255, 0, 0), 3, 8, 0);
		}
		cvReleaseMemStorage(&storage);
		cvReleaseHaarClassifierCascade(&cascade);

		// Convert BGR to RGB, then show it
		IplImage *img = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 3);
		cvCvtColor(image, img, CV_BGR2RGB);
		cvReleaseImage(&image);

		imageView.image = [self UIImageFromIplImage:img];
		cvReleaseImage(&img);
	}
}

#pragma mark -
#pragma mark UIViewControllerDelegate

- (void)loadView {
	[super loadView];
	imageView.image = nil;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	UIImagePickerControllerSourceType sourceType;

	if (buttonIndex == 0) {
		sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	} else if(buttonIndex == 1) {
		sourceType = UIImagePickerControllerSourceTypeCamera;
	} else if(buttonIndex == 2) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"lena" ofType:@"jpg"];
		imageView.image = [UIImage imageWithContentsOfFile:path];
		return;
	} else {
		// Cancel
		return;
	}

	if([UIImagePickerController isSourceTypeAvailable:sourceType]) {
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.sourceType = sourceType;
		picker.delegate = self;
		picker.allowsImageEditing = NO;
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
	imageView.image = image;
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}
@end