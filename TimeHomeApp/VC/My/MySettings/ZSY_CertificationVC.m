//
//  ZSY_CertificationVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/9/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_CertificationVC.h"
#import "UIButtonImageWithLable.h"
#import "LCActionSheet.h"
#import "UIView+Layout.h"
#import "ZZPhotoKit.h"
#import "TZImagePickerController.h"
//图片剪裁库
#import "TOCropViewController.h"
//图片处理工具
#import "ImageUitls.h"
#import "MySettingAndOtherLogin.h"
#import "AppSystemSetPresenters.h"
#import "Getverified.h"
@interface ZSY_CertificationVC ()<TZImagePickerControllerDelegate, TOCropViewControllerDelegate>
@property (nonatomic, strong) UIImage *addImage;
@property (nonatomic, strong) TZImagePickerController *imagePickerVC;
@property (nonatomic, strong) Getverified *model;

/**
 图片id
 */
@property (nonatomic, copy) NSString *resourceid;
@end

@implementation ZSY_CertificationVC
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    //如果从发帖页面推出，则销毁这个页面
    if ([_IDStr isEqualToString:@"postPush"]) {
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
        
        [navigationArray removeObjectAtIndex: 1];  // 移除指定的controller
        self.navigationController.viewControllers = navigationArray;
        
    }
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:GeRenSheZhi];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":GeRenSheZhi}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"身份认证";
    AppDelegate *ap = GetAppDelegates;
    NSLog(@"%@",ap.userData.token);
    self.submitButton.backgroundColor = kNewRedColor;
    [_addImageButton setTopImage:[UIImage imageNamed:@"个人设置-身份认证-添加证件审核照加号"] withTitle:@"添加证件审核照" forState:UIControlStateNormal];
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [MySettingAndOtherLogin getMyVerifiedWithUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        @WeakObj(self)
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if (resultCode == SucceedCode) {
                ///成功
                NSDictionary *dict = (NSDictionary *)data;
                //                [_dataSource removeAllObjects];
                
                NSLog(@"-----%@",[dict objectForKey:@"map"]);
                _model = [Getverified mj_objectWithKeyValues:[dict objectForKey:@"map"]];
                
                if ([_model.state isEqualToString:@"0"]) {
                    [selfWeak showToastMsg:@"您的申请正在审核中,请耐心等待" Duration:3.0];
                }else if ([_model.state isEqualToString:@"1"]) {
                    AppDelegate *appDele = GetAppDelegates;
                    appDele.userData.isvaverified = @"1";
                    [appDele saveContext];
                    [selfWeak showToastMsg:@"您已认证通过,请不要再次提交身份信息" Duration:3.0];
                }else if ([_model.state isEqualToString:@"-1"]) {
                    
                }
                
            }else {
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
            }
        });
    }];

}
- (IBAction)addImage:(id)sender {
    [self.view endEditing:YES];
    
    @WeakObj(self);
    // 类方法
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        if(buttonIndex==0)//拍照
        {
            /**
             *  最多能选择数
             */
            ZZCameraController *cameraController = [[ZZCameraController alloc]init];
            cameraController.takePhotoOfMax = 1;
            cameraController.isSaveLocal = NO;
            cameraController.cameraSourceType = ZZImageSourceForSingle;
            cameraController.isCanCustom = YES;
            [cameraController showIn:self result:^(id responseObject){
                
                NSLog(@"responseObject==%@",responseObject);
                
                UIImage *image = (UIImage *)responseObject;
                UIImage *newImg = [ImageUitls reduceImage:image percent:PIC_SCALING];
                _addImage = newImg;
                @WeakObj(self);
                [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                
                [AppSystemSetPresenters upLoadPicFile:newImg UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                        
                        if(resultCode == SucceedCode) {//图片上传成功
                            
                            [_showPicButton setBackgroundImage:_addImage forState:UIControlStateNormal];
                            _addImageButton.hidden = YES;
                            
                            NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                            
                            _resourceid = (NSString *)picID;
                            
                        }else {//图片上传失败
                            _addImageButton.hidden = NO;
                            if ([data isKindOfClass:[NSString class]]) {
                                if (![XYString isBlankString:data]) {
                                    [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                                }else {
                                    [selfWeak showToastMsg:@"图片上传失败" Duration:3.0];
                                }
                            }
                        }
                    });
                }];

            }];
            
            
        }else if (buttonIndex==1)//相册
        {
            _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:selfWeak];
            _imagePickerVC.pickerDelegate = selfWeak;
            [self presentViewController:_imagePickerVC animated:YES completion:^{
                _addImageButton.hidden = YES;
                
            }];
        }
    }];
    [sheet setTextColor:UIColorFromRGB(0xffffff)];
    [sheet show];

}
#pragma mark TZImagePickerControllerDelegate
// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    _addImageButton.hidden = NO;
}
/**
 *  用户选择好了图片，如果assets非空，则用户选择了原图
 *
 *  @param picker 相册
 *  @param photos 选中的图片
 *  @param assets
 */
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    
    
    @WeakObj(self);
    _imagePickerVC = nil;
    
    [GCDQueue executeInGlobalQueue:^{
        [GCDQueue executeInMainQueue:^{
            
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:photos[0]];
            cropController.delegate = selfWeak;
            cropController.defaultAspectRatio = TOCropViewControllerAspectRatioSquare;
            cropController.rotateClockwiseButtonHidden = NO;
            cropController.rotateButtonsHidden = YES;
            cropController.aspectRatioLocked = YES;
            [selfWeak presentViewController:cropController animated:YES completion:nil];
            
        }];
    }];
    
}

#pragma mark - Cropper Delegate - 编辑图片
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.centerX, self.view.centerY, 0, 0) completion:^{
        UIImage *newImg = [ImageUitls reduceImage:image percent:PIC_SCALING];
        
        @WeakObj(self);
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        
        [AppSystemSetPresenters upLoadPicFile:newImg UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if(resultCode == SucceedCode) {//图片上传成功
                    
                    _addImage = newImg;

                    [_showPicButton setBackgroundImage:_addImage forState:UIControlStateNormal];
                    _addImageButton.hidden = YES;
                    
                    NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                    
                    _resourceid = (NSString *)picID;
                    
                }else {//图片上传失败
                    //                    _resourceid = @"";
                    _addImageButton.hidden = YES;
                    if ([data isKindOfClass:[NSString class]]) {
                        if (![XYString isBlankString:data]) {
                            [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                        }else {
                            [selfWeak showToastMsg:@"图片上传失败" Duration:3.0];
                        }
                    }
                }
                
                
            });
            
        }];

    }];
}
/**
 *  取消编辑图片
 */
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.centerX, self.view.centerY, 0, 0) completion:nil];
    
}

- (IBAction)submitClick:(id)sender {

    if ([_model.state isEqualToString:@"0"]) {
        [self showToastMsg:@"您的申请正在审核中,请耐心等待" Duration:3.0];
    }else if ([_model.state isEqualToString:@"1"]) {
        [self showToastMsg:@"您已认证通过,请不要再次提交身份信息" Duration:3.0];
    }else if ([_model.state isEqualToString:@"-1"]) {
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        [MySettingAndOtherLogin addMyVerifiedWithPicId:_resourceid AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if (resultCode == SucceedCode) {
                    
                    [selfWeak showToastMsg:@"您的实名认证已提交" Duration:3.0];
                    
                }else {
                    
                    [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                }
                
            });
        }];
        
    }
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [MySettingAndOtherLogin addMyVerifiedWithPicId:_resourceid AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                [selfWeak showToastMsg:@"您的实名认证已提交" Duration:3.0];
                
            }else {
                
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
            }
            
        });
    }];
}

@end
