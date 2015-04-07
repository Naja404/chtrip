//
//  ZBPhotoTaker.m
//  XChat
//
//  Created by Zhou Bin on 14-2-25.
//  Copyright (c) 2014年 Zhou.Bin. All rights reserved.
//

#import "ZBPhotoTaker.h"
#import "UIImage+Resize.h"

@implementation ZBPhotoTaker

- (instancetype)initWithViewController:(UIViewController *)viewController{
    if ([super init]) {
        self.targetViewController = viewController;
    }
    return self;
}

- (void)takePhotoFrom:(ZBPhotoTakerSource)source
        allowsEditing:(BOOL)allowsEditing
             finished:(ZBPhotoTakerDidFinishedBlock)finished
{
    self.finishedBlock = finished;
    self.allowsEditing = allowsEditing;
    UIImagePickerControllerSourceType imagePickerControllerSourceType = -1;
    switch (source) {
        case ZBPhotoTakerSourceFromCamera:
            imagePickerControllerSourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case ZBPhotoTakerSourceFromGallery:
            imagePickerControllerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            break;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable: imagePickerControllerSourceType])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = imagePickerControllerSourceType;
        controller.allowsEditing = allowsEditing;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: imagePickerControllerSourceType];
        controller.delegate = self;
        [_targetViewController presentViewController: controller animated: YES completion: nil];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image
                   toSize:(CGSize)size
{
//    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSData *imageData = UIImagePNGRepresentation(image);
    UIImage *qualifyChangedImage = [UIImage imageWithData:imageData];
    CGSize sizeResizeTo = size;
    UIImage *resizedImage = [qualifyChangedImage resizedImageToFitInSize:sizeResizeTo scaleIfSmaller:NO];
    return resizedImage;
}

#pragma mark - NavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    CGSize size = CGSizeZero;
    
    if (!CGSizeEqualToSize(_sizeWanted, CGSizeZero)) {
        size = _sizeWanted;
    }else{
        if(_allowsEditing){
//            size = (CGSize){200,200};
//        }else{
            size = (CGSize){480,640};
        }
    }
    
    UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *editedImage   = [info valueForKey:UIImagePickerControllerEditedImage];
    UIImage *processedImage = [self imageWithImage:_allowsEditing? editedImage: originalImage toSize:size];
    _finishedBlock(processedImage);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 
- (void) dealloc{
    NSLog(@"dead!!");
}
@end
