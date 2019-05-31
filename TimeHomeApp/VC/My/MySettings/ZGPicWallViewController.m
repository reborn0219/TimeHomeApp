//
//  ZGPicWallViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/8/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZGPicWallViewController.h"

#import "UserPhotoWall.h"

#import "picWallCollectionViewCell.h"

#import "THMyInfoPresenter.h"

#import "AppSystemSetPresenters.h"

#import "LCActionSheet.h"

#import "ZZCameraController.h"

#import "ImageUitls.h"

#import "TZImagePickerController.h"

#import "TOCropViewController.h"

#import "SDPhotoBrowser.h"

@interface ZGPicWallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,TOCropViewControllerDelegate,SDPhotoBrowserDelegate>{
    
    UICollectionView *collection_;
    
    NSMutableArray *dataArr_;
    
    TZImagePickerController *imagePickerVc;
    
    /**
     *  选择的图片索引
     */
    NSInteger selectImageIndex;
}

@end

@implementation ZGPicWallViewController

#pragma mark - http request method

-(void)httpRequest{
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
                [dataArr_ addObjectsFromArray:(NSArray *)data];
                
                UserPhotoWall *wall = [[UserPhotoWall alloc]init];
                wall.image = [UIImage imageNamed:@"个人设置_头像_上传照片_添加照片"];
                wall.isSelected = YES;
                [dataArr_ addObject:wall];
                
                [collection_ reloadData];
                
            }else {
                //[self showToastMsg:@"获取照片墙失败" Duration:3.0];
            }
        });
    }];
}

#pragma mark - extend method

-(void)configNavigation{
    
    self.title = @"头像";
}

-(void)configUI{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    
    collection_ = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    collection_.delegate = self;
    collection_.dataSource = self;
    collection_.backgroundColor = BLACKGROUND_COLOR;
    
    [self.view addSubview:collection_];
    
    [collection_ registerNib:[UINib nibWithNibName:@"picWallCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:@"picWallCollectionViewCell"];
    
}

#pragma mark - life cycle method

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArr_ = [NSMutableArray array];
    
    [self configNavigation];
    [self configUI];
    [self httpRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ---------UICollection协议实现--------------
/**
 *  返回集合个数
 *
 *  @param view    view description
 *  @param section section description
 *
 *  @return return value 返回集合个数
 */
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return dataArr_.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/**
 *  处理每项视图数据
 *
 *  @param collectionView collectionView description
 *  @param indexPath      indexPath description
 *
 *  @return return value cell
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserPhotoWall *photowall = (UserPhotoWall *)dataArr_[indexPath.item];
    picWallCollectionViewCell *picWall = [collectionView dequeueReusableCellWithReuseIdentifier:@"picWallCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        picWall.top = @"0";
    }else{
        picWall.top = @"1";
    }
    picWall.model = photowall;
    
    //@WeakObj(picWall);
    picWall.deleteButtonDidClickBlock= ^(NSInteger cityIndex){
        
        [dataArr_ removeObjectAtIndex:indexPath.item];
        [collection_ reloadData];
        [self savePicWall:@"1"];
    };
        
    return picWall;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 40) / 3, (SCREEN_WIDTH - 40) / 3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}

//事件处理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.item == dataArr_.count - 1) {
        
        @WeakObj(self);
        
        if(dataArr_.count > 8)
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
                //            cameraController.takePhotoOfMax = count;
                cameraController.isSaveLocal = NO;
                cameraController.cameraSourceType = ZZImageSourceForSingle;
                cameraController.isCanCustom = YES;
                cameraController.aspectRatioLocked = YES;
                //            cameraController.imageType = ZZImageTypeOfThumb;
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
    }else{
        
//        UserPhotoWall *wall = dataArr_[indexPath.item];
//
//        [dataArr_ removeObjectAtIndex:indexPath.item];
//        [dataArr_ insertObject:wall atIndex:0];
//
//        [collection_ reloadData];
//
//        [self savePicWall];
        
        if (indexPath.item >= 0) {
            SDPhotoBrowser *browser = [SDPhotoBrowser sharedInstanceSDPhotoBrower];
            browser.sourceImagesContainerView = self.view;
            browser.isFromPhotoWall = YES;
            [browser getUserHeader:indexPath.item+1];
            
            @WeakObj(browser);
            browser.saveButtonDidClickBlock= ^(NSInteger index){
                
                [browserWeak hidden];
                UserPhotoWall *wall = dataArr_[index];
                
                [dataArr_ removeObjectAtIndex:index];
                [dataArr_ insertObject:wall atIndex:0];
                [collection_ reloadData];
                [self savePicWall:@"0"];
            };
            
            browser.imageCount = dataArr_.count - 1;
            browser.currentImageIndex = indexPath.item;
            browser.delegate = self;
            [browser show]; // 展示图片浏览器
        }
        
    }
}

#pragma  mark - 放大图片功能  返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    picWallCollectionViewCell *cell = (picWallCollectionViewCell *)[collection_ cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    return cell.picWall.image;
}
//返回高质量图片的url
//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
//
//    UserPhotoWall *photowall = (UserPhotoWall *)dataArr_[index];
//    return [NSURL URLWithString:photowall.fileurl];
//}

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

#pragma mark - Cropper Delegate - 编辑图片
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0) completion:^{
        
        [self uploadImage:image];
    }];
}
/**
 *  取消编辑图片
 */
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0) completion:nil];
    
    [collection_ reloadData];
}

#pragma mark TZImagePickerControllerDelegate
// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
    [collection_ reloadData];
}
/**
 *  用户选择好了图片，如果assets非空，则用户选择了原图
 *
 *  @param picker 相册
 *  @param photos 选中的图片
 *  @param assets
 */
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    
    //    selectImageIndex = _dataArray.count - 1;
    selectImageIndex = 0;
    
    @WeakObj(self);
    imagePickerVc = nil;
//    isFirstSelected = YES;
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
    [dataArr_ insertObject:photowall atIndex:0];
    
    [AppSystemSetPresenters upLoadPicFile:newImg UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                
                UserPhotoWall *photowall = [[UserPhotoWall alloc]init];
                photowall.theID = picID;
                photowall.image = image;
                [dataArr_ replaceObjectAtIndex:0 withObject:photowall];
                
                [self savePicWall:@"1"];
            }else {
                
                if ([data isKindOfClass:[NSString class]]) {
                    if (![XYString isBlankString:data]) {
                        [self showToastMsg:(NSString *)data Duration:3.0];
                    }else {
                        [self showToastMsg:@"图片上传失败" Duration:3.0];
                    }
                }
            }
            [collection_ reloadData];
            [indicator stopAnimating];
        });
    }];
}

/**
 *  保存照片墙
 */
- (void)savePicWall:(NSString *)back {
    
    @WeakObj(self);
    /**
     存放picID数组
     */
    NSMutableArray *picIDs = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < dataArr_.count; i++) {
        UserPhotoWall *photowall = dataArr_[i];
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
                
                if ([back isEqualToString:@"0"]) {
                    
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                }
            }
            else
            {
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
            }
            
        });
        
    }];
    
}

@end
