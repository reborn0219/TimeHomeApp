//
//  THPicUploadViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THPicUploadViewController.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
//网络请求
#import "AppSystemSetPresenters.h"
#import "THMyInfoPresenter.h"

#import "THPicHomeGridView.h"
//图片剪裁库
#import "TOCropViewController.h"

#import "UserPhotoWall.h"

#import "LCActionSheet.h"
#import "ZZPhotoKit.h"
//图片处理工具
#import "ImageUitls.h"

@interface THPicUploadViewController () <TZImagePickerControllerDelegate ,THPicHomeGridViewDelegate,TOCropViewControllerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    /**
     *  最大选择图片数
     */
    NSInteger selectCounts;
    /**
     *  选择的图片索引
     */
    NSInteger selectImageIndex;
    /**
     *  是否改动过图片
     */
    NSInteger isChanged;
    
    TZImagePickerController *imagePickerVc;
    
    BOOL isFirstSelected;
}
/**
 *  确定按钮
 */
@property (nonatomic, strong) UIButton *confirmButton;
/**
 *  图片排列视图
 */
@property (nonatomic, strong) THPicHomeGridView *mainView;
/**
 *  图片model数组
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIImagePickerController* picker;

@end

@implementation THPicUploadViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    
    selectCounts = 8;
    isChanged = 0;
    
    self.navigationItem.title = @"上传照片";
    _dataArray = [[NSMutableArray alloc]init];
    
    [self setupMainView];
    [self setUpBottomButton];
    
    /**
     *  获得照片墙，包含头像图片
     */
    THIndicatorVC *indicator = [THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];//加载动画
    [THMyInfoPresenter getPhotoWallUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicator stopAnimating];
            
            if(resultCode == SucceedCode)
            {
                [_dataArray addObjectsFromArray:(NSArray *)data];
                [_mainView removeFromSuperview];
                [self setupMainView];
                [self.view bringSubviewToFront:_confirmButton];
                
            }else {
                //                [self showToastMsg:@"获取照片墙失败" Duration:3.0];
            }
            
        });
        
    }];
    
}

/**
 *  创建图片按钮的View
 */
-(void)setupMainView{
    _mainView = [[THPicHomeGridView alloc]initWithFrame:self.view.frame];
    _mainView.gridViewDelegate = self;
    _mainView.showsVerticalScrollIndicator = NO;

    @WeakObj(self);

    @WeakObj(_mainView)
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];//加载动画
    [_mainView setUpGridModelsArray:_dataArray complete:^(id data) {
        
        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
        
        [selfWeak.view addSubview:_mainViewWeak];

    }];

}

#pragma mark - THPicHomeGridViewDelegate
/**
 *  点击图片事件
 *
 *  @param gridView 图片所在视图
 *  @param index    图片索引
 */
- (void)homeGrideView:(THPicHomeGridView *)gridView selectItemAtIndex:(NSInteger)index
{
//    [_mainView removeFromSuperview];
    selectImageIndex = index;
    
    if (_dataArray.count > 0) {

        THHomeGridViewListItemView *item = gridView.itemsArray[index];

        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:item.itemButton.currentBackgroundImage];
        cropController.delegate = self;
        cropController.defaultAspectRatio = TOCropViewControllerAspectRatioSquare;
        cropController.rotateClockwiseButtonHidden = NO;
//        cropController.rotateButtonsHidden = YES;
        cropController.aspectRatioLocked = YES;
        [self presentViewController:cropController animated:YES completion:nil];
    }

}

/**
 *  点击加号进入相册选择界面
 *
 *  @param gridView 所在视图
 */
- (void)homeGrideViewmoreItemButtonClicked:(THPicHomeGridView *)gridView {

    @WeakObj(self);
    
    if(_dataArray.count >= 8)
    {
        [self showToastMsg:@"图片选择数已达到最大" Duration:3.0];
        return;
    }
    
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
//            NSInteger count = (selectCounts - _dataArray.count) > 0 ? (selectCounts - _dataArray.count) : 0;
            [THIndicatorVC sharedTHIndicatorVC].isStarting=NO;
            ZZCameraController *cameraController = [[ZZCameraController alloc]init];
            cameraController.isSaveLocal = NO;
            cameraController.cameraSourceType = ZZImageSourceForSingle;
            cameraController.isCanCustom = YES;
            [cameraController showIn:selfWeak result:^(id responseObject){
                NSLog(@"responseObject==%@",responseObject);
                //返回结果集
                UIImage *image = (UIImage *)responseObject;

                [self uploadImage:image];

            }];
            

        }else if (buttonIndex==1)//相册
        {
            [selfWeak pickPhotoButtonClick:nil];
        }
    }];
    [sheet setTextColor:UIColorFromRGB(0xffffff)];
    [sheet show];
    

}
/**
 *  图片删除和重排后调用的方法
 *
 *  @param gridView 所在视图
 */
- (void)homeGrideViewDidChangeItems:(THPicHomeGridView *)gridView
{
    [_dataArray removeAllObjects];
    isChanged = 1;
    for (int i = 0; i < gridView.itemsArray.count - 1 ; i++) {
        THHomeGridViewListItemView *item = (THHomeGridViewListItemView *)[gridView.itemsArray objectAtIndex:i];
        [_dataArray addObject:item.photoWall];
    }
    [_mainView removeFromSuperview];
    [self setupMainView];
    [self.view bringSubviewToFront:_confirmButton];

}

#pragma mark - Cropper Delegate - 编辑图片
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.centerX, self.view.centerY, 0, 0) completion:^{
        
        THIndicatorVC * indicator = [THIndicatorVC sharedTHIndicatorVC];//加载动画
        [indicator startAnimating:self.tabBarController];
        
        UIImage *newImg =[ImageUitls imageCompressForWidth:image targetWidth:PIC_HEAD_WH];
        
        newImg = [ImageUitls reduceImage:newImg percent:PIC_SCALING];
        
        UserPhotoWall *photowall = _dataArray[selectImageIndex];
        photowall.image = image;
        [_dataArray replaceObjectAtIndex:selectImageIndex withObject:photowall];
        
        [_mainView removeFromSuperview];
        [self setupMainView];
        [self.view bringSubviewToFront:_confirmButton];

        [AppSystemSetPresenters upLoadPicFile:newImg UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (resultCode == SucceedCode) {
                    
                    isChanged = 1;

                    NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                    
                    UserPhotoWall *photowall = _dataArray[selectImageIndex];
                    photowall.theID = picID;
                    photowall.image = image;
                    [_dataArray replaceObjectAtIndex:selectImageIndex withObject:photowall];
                    
                }else {
                    
                    if ([data isKindOfClass:[NSString class]]) {
                        if (![XYString isBlankString:data]) {
                            [self showToastMsg:(NSString *)data Duration:3.0];
                        }else {
                            [self showToastMsg:@"图片上传失败" Duration:3.0];
                        }
                    }
                    
                }
                
                isFirstSelected = NO;
                
                [_mainView removeFromSuperview];
                [self setupMainView];
                [self.view bringSubviewToFront:_confirmButton];
                
                [indicator stopAnimating];
                
            });
            
        }];
        
    }];
    
}

/**
 *  取消编辑图片
 */
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.centerX, self.view.centerY, 0, 0) completion:nil];

    if (isFirstSelected) {
        
//        [_dataArray removeLastObject];
        [_dataArray removeObjectAtIndex:0];
    }
    
    isFirstSelected = NO;
    [_mainView removeFromSuperview];
    [self setupMainView];
    [self.view bringSubviewToFront:_confirmButton];
}

#pragma mark Click Event
/**
 *  进入相册方法
 *
 *  @param sender
 */
- (void) pickPhotoButtonClick:(UIButton *)sender {
    
    /**
     *  最多能选择数
     */
//    NSInteger count = (selectCounts - _dataArray.count) > 0 ? (selectCounts - _dataArray.count) : 0;
    
    imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.pickerDelegate = self;
    [self presentViewController:imagePickerVc animated:YES completion:^{
//        [_mainView removeFromSuperview];
    }];
    
}

#pragma mark TZImagePickerControllerDelegate
// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [_mainView removeFromSuperview];
    [self setupMainView];
    [self.view bringSubviewToFront:_confirmButton];
}
/**
 *  用户选择好了图片，如果assets非空，则用户选择了原图
 *
 *  @param picker 相册
 *  @param photos 选中的图片
 *  @param assets
 */
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    
    UserPhotoWall *photowall = [[UserPhotoWall alloc]init];
    photowall.image = photos[0];
//    [_dataArray addObject:photowall];
    [_dataArray insertObject:photowall atIndex:0];
    
//    selectImageIndex = _dataArray.count - 1;
    selectImageIndex = 0;

    @WeakObj(self);
    imagePickerVc = nil;
    isFirstSelected = YES;
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

/**
 *  底部按钮
 */
- (void)setUpBottomButton {
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = DEFAULT_BOLDFONT(15);
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmButton.backgroundColor = kNewRedColor;
    [_confirmButton addTarget:self action:@selector(confirmUpLoadClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(WidthSpace(84)));
    }];

}

#pragma mark - 上传图片

/**
 上传图片

 @param image 剪裁后的图片
 */
- (void)uploadImage:(UIImage *)image {
    
    THIndicatorVC * indicator = [THIndicatorVC sharedTHIndicatorVC];//加载动画
    [indicator startAnimating:self.tabBarController];
    
    UIImage *newImg =[ImageUitls imageCompressForWidth:image targetWidth:PIC_HEAD_WH];
    
    newImg = [ImageUitls reduceImage:newImg percent:PIC_SCALING];
    
    UserPhotoWall *photowall = [[UserPhotoWall alloc]init];
    photowall.image = image;
    [_dataArray insertObject:photowall atIndex:0];
    
    [AppSystemSetPresenters upLoadPicFile:newImg UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{

            if (resultCode == SucceedCode) {
                
                isChanged = 1;

                NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                
                UserPhotoWall *photowall = [[UserPhotoWall alloc]init];
                photowall.theID = picID;
                photowall.image = image;
//                [_dataArray addObject:photowall];
//                [_dataArray insertObject:photowall atIndex:0];
                [_dataArray replaceObjectAtIndex:0 withObject:photowall];

            }else {
                
                if ([data isKindOfClass:[NSString class]]) {
                    if (![XYString isBlankString:data]) {
                        [self showToastMsg:(NSString *)data Duration:3.0];
                    }else {
                        [self showToastMsg:@"图片上传失败" Duration:3.0];
                    }
                }
                
            }
            
            [_mainView removeFromSuperview];
            [self setupMainView];
            [self.view bringSubviewToFront:_confirmButton];
            
            [indicator stopAnimating];
            
        });
        
    }];
    
}

/**
 *  底部按钮点击方法，确定上传
 */
- (void)confirmUpLoadClick {

    if (isChanged == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (_dataArray.count == 0) {
        [self showToastMsg:@"请选择照片" Duration:3.0];
        return;
    }
    
    @WeakObj(self);
    
    /**
     存放picID数组
     */
    NSMutableArray *picIDs = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < _dataArray.count; i++) {
        UserPhotoWall *photowall = _dataArray[i];
        if (![XYString isBlankString:photowall.theID]) {
            [picIDs addObject:photowall.theID];
        }
    }
    
    NSString *imageString = [picIDs componentsJoinedByString:@","];
    
    THIndicatorVC * indicator = [THIndicatorVC sharedTHIndicatorVC];//加载动画
    [indicator startAnimating:self.tabBarController];
    /**
      *  保存照片墙
      */
    [THMyInfoPresenter savePhotoWallpicids:imageString UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {

        dispatch_async(dispatch_get_main_queue(), ^{

            [indicator stopAnimating];

            if(resultCode == SucceedCode)
            {
                [selfWeak showToastMsg:@"上传成功" Duration:3.0];
                if (selfWeak.callBack) {
                    selfWeak.callBack();
                }
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
            }

        });
        
    }];
    
}


@end
