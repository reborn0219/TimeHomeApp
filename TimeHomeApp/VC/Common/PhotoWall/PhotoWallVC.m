//
//  PhotoWallVC.m
//  TimeHomeApp
//
//  Created by us on 16/4/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PhotoWallVC.h"
#import "PhotoWallCell.h"
#import "LCActionSheet.h"
#import "CommunityManagerPresenters.h"
#import "PopListVC.h"
#import "TZImagePickerController.h"
#import "ZZPhotoKit.h"
#import "ImgCollectionCell.h"
#import "AppSystemSetPresenters.h"
#import "ReleaseReservePresenter.h"
#import "UpImageModel.h"
#import "ImageUitls.h"
#import "TOCropViewController.h"
#import "UIImage+ImageRotate.h"

@interface PhotoWallVC ()<TZImagePickerControllerDelegate,TOCropViewControllerDelegate>
{
    NSInteger Count;
    ///最后一个添加按钮
    UpImageModel *lastImg;
    ///是否上传了，YES是，NO不是
    BOOL isUpLoadOK;
    ///添加图片事件 YES是，NO 不是
    BOOL isADDImg;
    ///要上传的图片张数
    NSInteger upCount;
}

@end

@implementation PhotoWallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)backButtonClick {
    
    [super backButtonClick];
    
    if(!isADDImg)
    {
        [self.imgArray removeLastObject];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isUpLoad==1"];
        NSArray *arry= [self.imgArray filteredArrayUsingPredicate:predicate];
        [self.imgArray removeAllObjects];
        [self.imgArray addObjectsFromArray:arry];
    }
    isADDImg=!isADDImg;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    if(!isADDImg)
//    {
//        [self.imgArray removeLastObject];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isUpLoad==1"];
//        NSArray *arry= [self.imgArray filteredArrayUsingPredicate:predicate];
//        [self.imgArray removeAllObjects];
//        [self.imgArray addObjectsFromArray:arry];
//    }
//    isADDImg=!isADDImg;
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark ---初始化-----
-(void)initView
{
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    if(self.imgArray==nil)
    {
        self.imgArray=[NSMutableArray new];
    }
    lastImg=[UpImageModel new];
    lastImg.img=[UIImage imageNamed:@"个人设置_头像_上传照片_添加照片"];
    lastImg.isUpLoad=0;
    [self.imgArray addObject:lastImg];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoWallCell" bundle:nil]
        forCellWithReuseIdentifier:@"PhotoWallCell"];
    isADDImg=NO;
    Count=self.imgArray.count-1;
    Count=Count<0?0:Count;
}
/**
 *  返回实例
 *
 *  @return return value description
 */
+(PhotoWallVC *)getInstance
{
    PhotoWallVC * photoWallVC= [[PhotoWallVC alloc] initWithNibName:@"PhotoWallVC" bundle:nil];
    return photoWallVC;
}

#pragma mark - UICollectionViewDataSource methods----------

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH_SCALE(1/3.4), WIDTH_SCALE(1/3.4));
}

- (NSInteger)collectionView:(UICollectionView *)theCollectionView numberOfItemsInSection:(NSInteger)theSectionIndex {
    return self.imgArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PhotoWallCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoWallCell" forIndexPath:indexPath];
    UpImageModel * upImg=[self.imgArray objectAtIndex:indexPath.item];
    if([XYString isBlankString:upImg.imgUrl])
    {
        photoCell.img_Pic.image=upImg.img;
    }
    else
    {
        [photoCell.img_Pic sd_setImageWithURL:[NSURL URLWithString:upImg.imgUrl] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
    }
    photoCell.lab_Text.hidden=YES;
    photoCell.btn_Del.hidden=YES;
    photoCell.indexPath=indexPath;
    photoCell.img_Pic.contentMode=UIViewContentModeScaleAspectFill;
    
    if(upImg.isUpLoad==2)
    {
        photoCell.lab_Text.hidden=NO;
        photoCell.lab_Text.text=@"上传失败";

    }
    if(indexPath.item==0&&self.imgArray.count>1)
    {
        photoCell.lab_Text.hidden=NO;
        photoCell.lab_Text.text=@"封面";
    }
    if(self.imgArray.count>1&&(indexPath.item<(self.imgArray.count-1)))
    {
        photoCell.btn_Del.hidden=NO;
        
    }
    if(indexPath.item==(self.imgArray.count-1))
    {
        photoCell.img_Pic.contentMode=UIViewContentModeCenter;
    }
    ///删除事件
    photoCell.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
    {
        
        [self.imgArray removeObjectAtIndex:index.item];
        [self.collectionView reloadData];
    };
    
    return photoCell;
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    ///交换数据
    UpImageModel *upimg = self.imgArray[fromIndexPath.item];
    [self.imgArray removeObjectAtIndex:fromIndexPath.item];
    [self.imgArray insertObject:upimg atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.item==(self.imgArray.count-1))
    {
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    if(toIndexPath.item==(self.imgArray.count-1))
    {
        return NO;
    }
    if(fromIndexPath.item==(self.imgArray.count-1))
    {
        return NO;
    }

    return YES;
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will end drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did end drag");
    Count = 0;
    [self.collectionView reloadData];
}
#pragma mark --------------事件处理------------------
////确认事件
- (IBAction)btn_OkEvent:(UIButton *)sender {
    [self upLoadImgForImg];
}




-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==========didSelectItemAtIndexPath======");
    if(indexPath.item==(self.imgArray.count-1))
    {
        [self addImgEvent];
    }
    else
    {
//        [self tapPicture:indexPath.item];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoWallCell *cell=(PhotoWallCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    NSLog(@"==========didUnhighlightItemAtIndexPath======");
    
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *fillColor = [UIColor colorWithRed:0.529 green:0.808 blue:0.922 alpha:1];
    PhotoWallCell *cell=(PhotoWallCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:fillColor];
    NSLog(@"==========didHighlightItemAtIndexPath======");
    
}


///添加图片事件
-(void)addImgEvent
{
    
    upCount=0;
    isADDImg=YES;
    if(self.imgArray.count>=self.selectImgMaxNum+1)
    {
        [self showToastMsg:[NSString stringWithFormat:@"最多能选%ld张图片" ,(long)self.selectImgMaxNum] Duration:5.0];
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
            
            [THIndicatorVC sharedTHIndicatorVC].isStarting=NO;
            ZZCameraController *cameraController = [[ZZCameraController alloc]init];
            cameraController.takePhotoOfMax = self.selectImgMaxNum-self.imgArray.count+1;
            cameraController.isSaveLocal = NO;
            [cameraController showIn:self result:^(id responseObject){
                
                NSArray *array = (NSArray *)responseObject;
                isADDImg=NO;
                upCount=array.count;
                if(array!=nil&&array.count>0)
                {
                    
                    UpImageModel * upImage;
                    [self.imgArray removeLastObject];
                    Count=self.imgArray.count-1;//上传计数初值
                    Count=Count<0?0:Count;
                    UIImage * img;
                    for(int i=0;i<array.count;i++)
                    {
                        upImage=[UpImageModel new];
                        img=[array objectAtIndex:i];
                        img=[ImageUitls imageCompressForWidth:img targetWidth:PIC_PIXEL_W];
                        img=[ImageUitls reduceImage:img percent:PIC_SCALING];
                        upImage.img=img;
                        upImage.isUpLoad = 0;
                        [self.imgArray addObject:upImage];
                    }
                   
                    [self.imgArray addObject:lastImg];
                    [self.collectionView reloadData];
                }
            }];
            
        }
        else if (buttonIndex==1)//相册
        {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.selectImgMaxNum-self.imgArray.count+1 delegate:self];

            imagePickerVc.pickerDelegate = self;
            
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        }
        else
        {
            isADDImg=NO;
        }
    }];
    [sheet setTextColor:UIColorFromRGB(0xffffff)];
    [sheet show];
}

#pragma mark TZImagePickerControllerDelegate
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
    isADDImg=NO;
    
    //修改---------------------------
    if(self.imgArray==nil)
    {
        self.imgArray=[NSMutableArray new];
        [self.imgArray addObject:lastImg];
    }
    Count=self.imgArray.count-1;
    Count=Count<0?0:Count;
    [_collectionView reloadData];
    //修改---------------------------


}
/**
 *  用户选择好了图片，如果assets非空，则用户选择了原图
 *
 *  @param picker 相册
 *  @param photos 选中的图片
 *  @param assets
 */
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    
    isADDImg=NO;
    upCount = photos.count;
    if(photos!=nil&&photos.count>0)
    {
        
        UpImageModel * upImage;
        [self.imgArray removeLastObject];
        Count=self.imgArray.count-1;//上传计数初值
        Count=Count<0?0:Count;
        UIImage * img;
        for(int i=0;i<photos.count;i++)
        {
            upImage=[UpImageModel new];
            img=[photos objectAtIndex:i];
            img=[ImageUitls imageCompressForWidth:img targetWidth:PIC_PIXEL_W];
            img=[ImageUitls reduceImage:img percent:PIC_SCALING];
            upImage.img=img;
            upImage.isUpLoad=0;
            [self.imgArray addObject:upImage];
        }
        [self.imgArray addObject:lastImg];
    }
    
    [self.collectionView reloadData];
    
}

///上传图片
-(void)upLoadImgForImg
{
    
    if(self.imgArray.count==0)
    {
        isADDImg=NO;
        
        
        [self.imgArray removeLastObject];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isUpLoad==1"];
        NSArray *arry= [self.imgArray filteredArrayUsingPredicate:predicate];
        [self.imgArray removeAllObjects];
        [self.imgArray addObjectsFromArray:arry];
        isADDImg = YES;
        
         [self.navigationController popViewControllerAnimated:YES];
//        [self showToastMsg:@"没有可上传的图片" Duration:5];
        return;
    }
    if(Count==(self.imgArray.count-1))
    {
        isADDImg=NO;
        
        
        [self.imgArray removeLastObject];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isUpLoad==1"];
        NSArray *arry= [self.imgArray filteredArrayUsingPredicate:predicate];
        [self.imgArray removeAllObjects];
        [self.imgArray addObjectsFromArray:arry];
        isADDImg = YES;
        
         [self.navigationController popViewControllerAnimated:YES];
//        [self showToastMsg:@"没有可上传的图片" Duration:5];
        return;
    }
    
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    ///延时关闭加载动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
    });
    UpImageModel *upImg;
    ///上传完成个数据
    __block NSInteger okCount=0;
    int start = Count == 0 ? 0 : (int)(Count+1);
    dispatch_group_t group = dispatch_group_create();
    for(NSInteger i=start;i<(self.imgArray.count-1);i++)
    {
        upImg=[self.imgArray objectAtIndex:i];
        upImg.index=i;
        
        if(upImg.isUpLoad==1||upImg.img==nil)
        {
            continue;
        }
        dispatch_group_enter(group);
        [AppSystemSetPresenters upLoadPicFile:upImg.img UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                okCount++;
                NSLog(@"okCount====%ld",(long)okCount);
                if(resultCode==SucceedCode)
                {
                    NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                    
                    upImg.picID=(NSString *)picID;
                    upImg.isUpLoad=1;
                    
                }
                else
                {
                    upImg.isUpLoad=2;
                    [self showToastMsg:data Duration:5.0];
                }
            });
            dispatch_group_leave(group);
        }];
    }
    ///都上传成功后处理
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        isUpLoadOK=YES;
        if([[THIndicatorVC sharedTHIndicatorVC] isStarting])
        {
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
        }
        isADDImg=NO;

        [self.imgArray removeLastObject];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isUpLoad==1"];
        NSArray *arry= [self.imgArray filteredArrayUsingPredicate:predicate];
        [self.imgArray removeAllObjects];
        [self.imgArray addObjectsFromArray:arry];
        isADDImg = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
    });
    Count=self.imgArray.count-1;//上传计数初值
    Count=Count<0?0:Count;
}
///上传单张图片
-(void)upLoadImgForInde:(NSInteger) index
{
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    UpImageModel *upImg;
    upImg=[self.imgArray objectAtIndex:index];
    [AppSystemSetPresenters upLoadPicFile:upImg.img UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                
                upImg.picID=(NSString *)picID;
                upImg.isUpLoad=1;
                
            }
            else
            {
                upImg.isUpLoad=2;
                [self showToastMsg:data Duration:5.0];
                [self.collectionView reloadData];
            }
            
        });
        
    }];
}

////看大图
-(void)tapPicture:(NSInteger) index
{
    isADDImg=YES;
    UpImageModel * upimg=self.imgArray[index];
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:upimg.img];
    cropController.delegate = self;
    [self presentViewController:cropController animated:YES completion:nil];
    
    
}

#pragma mark - Cropper Delegate - 编辑图片
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.centerX_sd, self.view.centerY_sd, 0, 0) completion:^{
        
    }];
}


@end
