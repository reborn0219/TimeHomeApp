//
//  L_SuggestionViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_SuggestionViewController.h"
#import "LCActionSheet.h"

#import "ZZPhotoKit.h"

#import "TZImagePickerController.h"
//图片剪裁库
#import "TOCropViewController.h"
//图片处理工具
#import "ImageUitls.h"
//网络请求
#import "AppSystemSetPresenters.h"
#import "MySettingAndOtherLogin.h"

#import "UIView+Layout.h"

#import "RegularUtils.h"
#import "GraffitiViewController.h"

@interface L_SuggestionViewController () <UITextViewDelegate, TZImagePickerControllerDelegate, TOCropViewControllerDelegate>
{
    AppDelegate *appdelegate;
}
/**
 输入内容
 */
@property (weak, nonatomic) IBOutlet UITextView *textView;

/**
 添加图片背景
 */
@property (weak, nonatomic) IBOutlet UIView *addBgView;

/**
 添加图片label
 */
@property (weak, nonatomic) IBOutlet UILabel *addImageLabel;

/**
 加号
 */
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

/**
 添加图片按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

/**
 电话，QQ输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *textField;

/**
 输入框背景view
 */
@property (weak, nonatomic) IBOutlet UIView *tfBgview;

@property (nonatomic, strong) UILabel *placeHolderLabel;

/**
 相册选择器
 */
@property (nonatomic, strong) TZImagePickerController *imagePickerVC;

/**
 图片id
 */
@property (nonatomic, copy) NSString *resourceid;

/**
 机型
 */
@property (weak, nonatomic) IBOutlet UILabel *iPhoneTypeLabel;

@end

@implementation L_SuggestionViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[GraffitiViewController class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _addBgView.layer.borderWidth = 1;
    _addBgView.layer.borderColor = LINE_COLOR.CGColor;
    
    _tfBgview.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
    _tfBgview.layer.borderWidth = 1;
    
    _placeHolderLabel = [[UILabel alloc] init];
    [_textView addSubview:_placeHolderLabel];
    _placeHolderLabel.text = @"说一下您碰到的问题吧";
    _placeHolderLabel.font = DEFAULT_FONT(16);
    _placeHolderLabel.textColor = TEXT_COLOR;
    _placeHolderLabel.sd_layout.leftEqualToView(_textView).topSpaceToView(_textView,8).widthIs(200).heightIs(18);
    
    appdelegate = GetAppDelegates;
    _iPhoneTypeLabel.text = [NSString stringWithFormat:@"您的机型为：%@",[appdelegate iphoneType]];
    
    if (_drawImage != nil) {
        
//        [_addImageButton layoutIfNeeded];
//        [_addImageButton setBackgroundColor:CLEARCOLOR];
//        _addImageButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//        _addImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        _addImageButton.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
//        _addImageButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
//        
//        [_addImageButton setImage:_drawImage forState:UIControlStateNormal];
//        return;

        ///有图片表示从截图反馈跳转 上传图片
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:_drawImage];
        cropController.delegate = self;
        cropController.defaultAspectRatio = TOCropViewControllerAspectRatioSquare;
        cropController.rotateClockwiseButtonHidden = NO;
        cropController.aspectRatioLocked = YES;
        [self presentViewController:cropController animated:YES completion:nil];

//        UIImage *newImg = [ImageUitls reduceImage:_drawImage percent:PIC_SCALING];
//        @WeakObj(self);
//        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
//        [AppSystemSetPresenters upLoadPicFile:newImg UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
//                
//                if(resultCode == SucceedCode) {//图片上传成功
//                    
//                    _addImageView.hidden = YES;
//                    _addImageLabel.hidden = YES;
//                    
//                    NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
//                    
//                    _resourceid = (NSString *)picID;
//                    [_addImageButton setBackgroundColor:[UIColor whiteColor]];
//                    [_addImageButton setBackgroundImage:_drawImage forState:UIControlStateNormal];
//                    
//                }else {//图片上传失败
//                    
//                    if ([data isKindOfClass:[NSString class]]) {
//                        if (![XYString isBlankString:data]) {
//                            [selfWeak showToastMsg:(NSString *)data Duration:3.0];
//                        }else {
//                            [selfWeak showToastMsg:@"图片上传失败" Duration:3.0];
//                        }
//                    }
//                }
//            });
//        }];
    }
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 25);
    
    UIImage *image = [UIImage imageNamed:@"返回"];
    [button setBackgroundImage:[image imageWithColor:TITLE_TEXT_COLOR] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)backButtonClick {
    
    if (_drawImage == nil) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        for (UIViewController *vc in marr) {
            if ([vc isKindOfClass:[GraffitiViewController class]]) {
                [marr removeObject:vc];
                break;
            }
        }
        self.navigationController.viewControllers = marr;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _placeHolderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([XYString isBlankString:_textView.text]) {
        _placeHolderLabel.hidden = NO;
    }else {
        _placeHolderLabel.hidden = YES;
    }
}

/**
 添加图片
 */
- (IBAction)addImageButtonDidTouch:(UIButton *)sender {
    
    NSLog(@"添加图片");
    [self.view endEditing:YES];

    @WeakObj(self);
    // 类方法
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        if(buttonIndex==0)//拍照
        {
            /** 相机授权判断 */
            if (![self canOpenCamera]) {
                return ;
            };
            
            
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
                
                @WeakObj(self);
                [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                
                [AppSystemSetPresenters upLoadPicFile:newImg UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                        
                        if(resultCode == SucceedCode) {//图片上传成功
                            
                            _addImageView.hidden = YES;
                            _addImageLabel.hidden = YES;
                            
                            NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                            
                            _resourceid = (NSString *)picID;

                            [_addImageButton setBackgroundColor:[UIColor whiteColor]];
                            [_addImageButton setBackgroundImage:(UIImage *)responseObject forState:UIControlStateNormal];
                            
                        }else {//图片上传失败
                            
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
                
            }];
        }
    }];
    [sheet setTextColor:UIColorFromRGB(0xffffff)];
    [sheet show];

    
}
#pragma mark TZImagePickerControllerDelegate
// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
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
            //        cropController.rotateButtonsHidden = YES;
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
                    
                    _addImageView.hidden = YES;
                    _addImageLabel.hidden = YES;
                    
                    NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                    
                    _resourceid = (NSString *)picID;

                    [_addImageButton setBackgroundColor:[UIColor whiteColor]];
                    [_addImageButton setBackgroundImage:image forState:UIControlStateNormal];
                    
                    
                }else {//图片上传失败
                    
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

/**
 提交
 */
- (IBAction)submitButtonDidTouch:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if ([XYString isBlankString:_textView.text]) {
        [self showToastMsg:@"请填写您遇到的问题" Duration:3.0];
        return;
    }
    
    if ([XYString isBlankString:_textField.text]) {
        [self showToastMsg:@"请填写您的QQ、邮件或电话" Duration:3.0];
        return;
    }
    
//    if (![RegularUtils isQQ:_textField.text] && ![RegularUtils isMobileNumber:_textField.text] && ![RegularUtils isValidateEmail:_textField.text]) {
    if (![RegularUtils isQQ:_textField.text] && ![RegularUtils isValidateEmail:_textField.text]) {

        [self showToastMsg:@"请填写正确的QQ、邮件或电话" Duration:3.0];
        return;
    }
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
// 11-10周四增,新增title，随便传，不为空即可
    [MySettingAndOtherLogin addMyFeedBackWithType:@"9999" andContent:_textView.text andPicID:[XYString IsNotNull:_resourceid] andLinkinfo:_textField.text andPhonemodel:[appdelegate iphoneType] andTitle:@"title" andUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                

                [self showToastMsg:data Duration:3.0];

                
            }
            
        });
        
    }];
    
}

@end
