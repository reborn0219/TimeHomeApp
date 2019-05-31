//
//  ZZCameraPickerViewController.h
//  ZZFramework
//
//  Created by Yuan on 15/12/18.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface ZZCameraPickerViewController : UIViewController

/** 选择的图片宽高 */
@property (nonatomic, copy) NSString *selectImageWidth;
@property (nonatomic, copy) NSString *selectImageHeight;

@property (assign, nonatomic) BOOL isSavelocal;

@property (assign, nonatomic) NSInteger takePhotoOfMax;
@property (assign, nonatomic) ZZImageType imageType;

@property (strong, nonatomic) void (^CameraResult)(id responseObject);
/**
 *  相机类型（系统相机，自定义多选相机）
 */
@property (nonatomic, assign) ZZImageSourceType cameraSourceType;
/**
 *  单选相机是否支持编辑
 */
@property (nonatomic, assign) BOOL isCanCustom;
/**
 *  单选相机编辑时编辑框的大小（自定义多选相机忽略此属性,默认为正方形）
 */
@property (nonatomic, assign) CameraImageAspectRatio imageAspectRatio;

@property (nonatomic, assign) BOOL rotateClockwiseButtonHidden;
@property (nonatomic, assign) BOOL rotateButtonsHidden;
@property (nonatomic, assign) BOOL aspectRatioLocked;

@end
