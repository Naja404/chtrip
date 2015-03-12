//
//  ZBPhotoTaker.h
//  XChat
//
//  Created by Zhou Bin on 14-2-25.
//  Copyright (c) 2014年 Zhou.Bin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZBPhotoTakerSource){
    ZBPhotoTakerSourceFromCamera = 0,
    ZBPhotoTakerSourceFromGallery
};

typedef void (^ZBPhotoTakerDidFinishedBlock)(UIImage *image);

@interface ZBPhotoTaker : NSObject <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,readwrite) ZBPhotoTakerSource source;           //照片来源
@property(nonatomic,readwrite) BOOL allowsEditing;                  //允许剪裁 ?
@property(readwrite) CGSize sizeWanted;                              //调整尺寸到
@property(nonatomic,weak) UIViewController *targetViewController;   //用于present照片视图的控制器
@property(nonatomic,strong) ZBPhotoTakerDidFinishedBlock finishedBlock;

- (instancetype)initWithViewController:(UIViewController *)viewController;

- (void)takePhotoFrom:(ZBPhotoTakerSource)source
        allowsEditing:(BOOL)allowsEditing
             finished:(ZBPhotoTakerDidFinishedBlock)finished;
@end
