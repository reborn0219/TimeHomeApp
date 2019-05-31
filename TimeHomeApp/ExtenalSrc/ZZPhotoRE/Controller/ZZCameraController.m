//
//  ZZCameraController.m
//  ZZFramework
//
//  Created by Yuan on 15/12/18.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import "ZZCameraController.h"
#import "ZZCameraPickerViewController.h"

@interface ZZCameraController()

@property (strong,nonatomic) ZZCameraPickerViewController *cameraPickerController;

@property (nonatomic, strong) UIImagePickerController* picker;

@property (nonatomic, copy) ZZCameraResult systemCameraResult;

@end

@implementation ZZCameraController

-(ZZCameraPickerViewController *)cameraPickerController
{
    if (!_cameraPickerController) {
        _cameraPickerController = [[ZZCameraPickerViewController alloc]init];
    }
    return _cameraPickerController;
}
/**
 *  显示
 *
 *  @param controller 当前控制器
 *  @param result     返回数组或图片
 */
-(void)showIn:(UIViewController *)controller result:(ZZCameraResult)result
{
    
    self.cameraPickerController.CameraResult = result;
    //设置连拍最大张数
    self.cameraPickerController.takePhotoOfMax = self.takePhotoOfMax;
    //设置返回图片类型
    self.cameraPickerController.imageType = self.imageType;
    self.cameraPickerController.isSavelocal = self.isSaveLocal;

    self.cameraPickerController.cameraSourceType = self.cameraSourceType;

    self.cameraPickerController.isCanCustom = self.isCanCustom;
    
    if (![XYString isBlankString:_selectImageWidth]) {
        self.cameraPickerController.selectImageWidth = _selectImageWidth;
    }
    if (![XYString isBlankString:_selectImageHeight]) {
        self.cameraPickerController.selectImageHeight = _selectImageHeight;
    }
    
    self.cameraPickerController.imageAspectRatio = self.imageAspectRatio;
    
    self.cameraPickerController.rotateClockwiseButtonHidden = self.rotateClockwiseButtonHidden;
    self.cameraPickerController.rotateButtonsHidden = self.rotateButtonsHidden;
    self.cameraPickerController.aspectRatioLocked = self.aspectRatioLocked;
    
    [controller presentViewController:self.cameraPickerController animated:YES completion:nil];

}


@end
