#import <UIKit/UIKit.h>

typedef enum {
	ActionSheetToSelectTypeOfSource = 1,
	ActionSheetToSelectTypeOfMarks
} OpenCVTestViewControllerActionSheetAction;

@interface OpenCVTestViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	IBOutlet UIImageView *imageView;
	OpenCVTestViewControllerActionSheetAction actionSheetAction;
}

- (IBAction)loadImage:(id)sender;
- (IBAction)saveImage:(id)sender;
- (IBAction)edgeDetect:(id)sender;
- (IBAction)faceDetect:(id)sender;

@property (nonatomic, retain) UIImageView *imageView;
@end