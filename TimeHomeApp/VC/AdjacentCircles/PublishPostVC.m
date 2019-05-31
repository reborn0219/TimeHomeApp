//
//  PublishPostVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PublishPostVC.h"
#import "PostPresenter.h"
#import "RecommendTopicModel.h"
///vcs
#import "TZImagePickerController.h"
#import "LCActionSheet.h"
#import "ZZCameraController.h"

///cells
#import "PhotoWallCell.h"
#import "PublishPostReView.h"
///models
#import "AppSystemSetPresenters.h"
#import "ImageUitls.h"
#import "UpImageModel.h"
#import "ChatPresenter.h"

@interface PublishPostVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

{
    NSMutableArray * imgList;
    NSInteger currentCount;
    NSMutableArray * imgIDs;
    RecommendTopicModel * RTML;
    UITextView * tempTV;
    BOOL isFirst;
}
@property (nonatomic,retain)UICollectionView *collectionV;

@end

@implementation PublishPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirst = YES;
    self.publishBtn.layer.borderWidth = 1;
    self.publishBtn.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
    imgList = [[NSMutableArray alloc]initWithCapacity:0];
    imgIDs = [[NSMutableArray alloc]initWithCapacity:0];
    
    UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-(44+statuBar_Height)-45) collectionViewLayout:flowlayout];
    [self.collectionV setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    self.collectionV.delegate = self;
    self.collectionV.dataSource =self;
    [self.collectionV registerNib:[UINib nibWithNibName:@"PhotoWallCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoWallCell"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"PublishPostReView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PublishPostReView"];
    [self.view addSubview:_collectionV];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    @WeakObj(self)
    [PostPresenter getTopicInfo:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode)
            {
                
                RTML = data;
                [selfWeak.collectionV reloadData];
            }
        });
        
        
    } withTopicID:[self.topicID stringByReplacingOccurrencesOfString:@"'" withString:@""]];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UICollectionViewDelgate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PhotoWallCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoWallCell" forIndexPath:indexPath];
    UpImageModel * upImg=[imgList objectAtIndex:indexPath.item];
    if([XYString isBlankString:upImg.imgUrl])
    {
        photoCell.img_Pic.image=upImg.img;
    }
    else
    {
        [photoCell.img_Pic sd_setImageWithURL:[NSURL URLWithString:upImg.imgUrl] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
    }

    if (upImg.isUpLoad==0) {
        photoCell.lab_Text.hidden=YES;
        
    }else if(upImg.isUpLoad ==1)
    {
        photoCell.lab_Text.hidden=NO;

        photoCell.lab_Text.text = @"上传成功";

    }else if(upImg.isUpLoad == 2)
    {
        photoCell.lab_Text.hidden=NO;

        photoCell.lab_Text.text = @"上传失败";

    }
    photoCell.btn_Del.hidden=NO;
    photoCell.indexPath=indexPath;
    photoCell.img_Pic.contentMode=UIViewContentModeScaleAspectFill;
   
    ///删除事件
    photoCell.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
    {
        [imgList removeObjectAtIndex:index.item];
        [self.collectionV reloadData];
    };
    return photoCell;
    
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0,0);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(SCREEN_WIDTH, 348);
    
    
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    
    return 0.1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-40)/4.0f,(SCREEN_WIDTH-40)/4.0f);
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imgList.count;
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5,5,5,5);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        
        PublishPostReView * pubPostReView  =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PublishPostReView"forIndexPath:indexPath];
       [ pubPostReView.imgV sd_setImageWithURL:[NSURL URLWithString:RTML.picurl] placeholderImage:PLACEHOLDER_IMAGE];
        
        if (isFirst) {
            pubPostReView.contentTV.text = [NSString stringWithFormat:@"关于%@,你想说点什么呢？",RTML.title];
        }
        pubPostReView.contentTV.textColor = TEXT_COLOR;
        tempTV = pubPostReView.contentTV;
        pubPostReView.contentTV.delegate = self;
        
        pubPostReView.IntroductionLB.text = RTML.remarks;
        
        
        if (RTML.isfollow.boolValue) {
            
            [pubPostReView.followBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_已注"] forState:UIControlStateNormal];
            [pubPostReView.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        }else
        {
            
            [pubPostReView.followBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_注"] forState:UIControlStateNormal];
            [pubPostReView.followBtn setTitle:@"加关注" forState:UIControlStateNormal];
        }

        @WeakObj(self)
        @WeakObj(pubPostReView)
        
        pubPostReView.followBlock = ^(id  _Nullable data_1,ResultCode resultCode)
        {

            
            UIButton * guanzhuBtn = (UIButton *)data_1;
            [guanzhuBtn setEnabled:NO];
            //            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
            //            [indicator startAnimating:self];
            if (!RTML.isfollow.boolValue) {
                
                
                NSLog(@"点击关注或取消关注");
                [PostPresenter addFollowTopic:RTML.recommendTopicID WithCallBack:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [guanzhuBtn setEnabled:YES];
                        
                        // [indicator stopAnimating];
                        if (resultCode == SucceedCode) {
                            [selfWeak showToastMsg:data Duration:2.5];
                            RTML.isfollow = @"1";
                            [pubPostReViewWeak.followBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_已注"] forState:UIControlStateNormal];
                            [pubPostReViewWeak.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"checkfollow" object:@{RTML.recommendTopicID:RTML.isfollow}];

                        }
                    });
                    
                }];
                
            }else
            {
                [PostPresenter removeFollowTopic:RTML.recommendTopicID WithCallBack:^(id  _Nullable data, ResultCode resultCode) {
                    
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        //[indicator stopAnimating];
                        [guanzhuBtn setEnabled:YES];
                        
                        if (resultCode == SucceedCode) {
                            
                            [selfWeak showToastMsg:data Duration:2.5];
                            RTML.isfollow = @"0";
                            [pubPostReViewWeak.followBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_注"] forState:UIControlStateNormal];
                            [pubPostReViewWeak.followBtn setTitle:@"加关注" forState:UIControlStateNormal];

                            [[NSNotificationCenter defaultCenter]postNotificationName:@"checkfollow" object:@{RTML.recommendTopicID:RTML.isfollow}];

//                            RTML.isfllow = @"0";
//                            [selfWeak reloadFollowTopics];
                        }
                    });
                }];
                
            }

            
//            if (RTML.isfollow.boolValue) {
//                ///取消关注
//                [ChatPresenter removeUserFollow:RTML.recommendTopicID withBlock:^(id  _Nullable data, ResultCode resultCode) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        [selfWeak showToastMsg:data Duration:2.5];
//                        RTML.isfollow = @"0";
//                        [pubPostReViewWeak.followBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_注"] forState:UIControlStateNormal];
//                        [pubPostReViewWeak.followBtn setTitle:@"加关注" forState:UIControlStateNormal];
//
//                        
//                    });
//                }];
//                
//                
//                
//            }else
//            {
//                ///关注
//                [ChatPresenter addUserFollow:RTML.recommendTopicID withBlock:^(id  _Nullable data, ResultCode resultCode) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        [selfWeak showToastMsg:data Duration:2.5];
//                        RTML.isfollow = @"1";
//                        [pubPostReViewWeak.followBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_已注"] forState:UIControlStateNormal];
//                        [pubPostReViewWeak.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
//
//                    });
//                }];
//                
//            }
        };
        
        
        pubPostReView.imgBlock = ^(id  _Nullable data,ResultCode resultCode)
        {
            // 类方法
            @WeakObj(self)
            if(imgList.count==9){
                [selfWeak showToastMsg:@"最多上传9张图片" Duration:2.5f];
                return ;
            }
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
                
                if (buttonIndex == 0) {
                    
                    /** 相机授权判断 */
                    if (![self canOpenCamera]) {
                        return ;
                    };
                    
                    /**
                     *  最多能选择数
                     */
                    @WeakObj(self)
                    NSInteger count = (9 - imgList.count) > 0 ? (9 - imgList.count) : 0;
                    [THIndicatorVC sharedTHIndicatorVC].isStarting=NO;
                    ZZCameraController *cameraController = [[ZZCameraController alloc]init];
                    cameraController.takePhotoOfMax = count;
                    cameraController.isSaveLocal = NO;
                    //            cameraController.imageType = ZZImageTypeOfThumb;
                    [cameraController showIn:selfWeak result:^(id responseObject){
                        //返回结果集
                        currentCount = imgList.count-1;

                        NSArray *array = (NSArray *)responseObject;
                        if(array!=nil && array.count>0)
                        {
                            for(int i = 0 ;i < array.count;i++)
                            {
                                UpImageModel *upImg = [[UpImageModel alloc]init];
                                
                                upImg.img = [array objectAtIndex:i];
                                
                                upImg.img=[ImageUitls imageCompressForWidth:upImg.img targetWidth:PIC_PIXEL_W];
                                upImg.img=[ImageUitls reduceImage:upImg.img percent:PIC_SCALING];

                                NSLog(@"%@",upImg.img);
                                upImg.isUpLoad = 0;
                                [imgList addObject:upImg];
                                
                            }
                            [selfWeak.collectionV reloadData];
                            [selfWeak upLoadImgForImg];

                        }
                        
                    }];
                    
                    
                }
                if (buttonIndex == 1) {
                    //从相册选择
                    [selfWeak pickPhotoButtonClick];
                }
            }];
            [sheet setTextColor:UIColorFromRGB(0xffffff)];
            [sheet show];
        };
        
        return pubPostReView;
    }else if([kind isEqual:UICollectionElementKindSectionFooter]){
        
        return [UICollectionReusableView new];;
        
    }else
    {
        return [UICollectionReusableView new];
    }
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UpImageModel *upImg = [imgList objectAtIndex:indexPath.row];
    if (upImg.isUpLoad!=1) {
        [self upLoadImgForInde:indexPath.row];
    }
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (isFirst) {
        textView.text = @"";
        isFirst = NO;
    }
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%@",textView);
    NSInteger number = [textView.text length];
    
    UITextRange * selectedRange = textView.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        
      
        if (number >= 500) {
            [self showToastMsg:@"字符个数不能大于500" Duration:2.5f];
            textView.text = [textView.text substringToIndex:500];
            tempTV.text = textView.text;
        }
    }
   
}
#pragma mark Click Event
/**
 *  进入相册方法
 *
 *  @param sender
 */
- (void)pickPhotoButtonClick{
    
   
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:imgList.count>9?0:(9-imgList.count) delegate:self];
    @WeakObj(self)
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets)
    {
        
        currentCount = imgList.count-1;
        for (int i =0; i<photos.count;i++) {
            
            UpImageModel *upImg = [[UpImageModel alloc]init];
            upImg.img = [photos objectAtIndex:i];
            upImg.img=[ImageUitls imageCompressForWidth:upImg.img targetWidth:PIC_PIXEL_W];
            upImg.img=[ImageUitls reduceImage:upImg.img percent:PIC_SCALING];
            

            upImg.isUpLoad = 0;
            [imgList addObject:upImg];
        }
        
        [selfWeak.collectionV reloadData];
        [selfWeak upLoadImgForImg];

    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];

}
///上传图片
-(void)upLoadImgForImg
{
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    ///延时关闭加载动画
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([[THIndicatorVC sharedTHIndicatorVC] isStarting])
        {
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
        }
        
    });
    
    UpImageModel *upImg;
    @WeakObj(self)
    for(NSInteger i = currentCount>0?currentCount:0;i<imgList.count;i++)
    {
        upImg=[imgList objectAtIndex:i];
        
        [AppSystemSetPresenters upLoadPicFile:upImg.img withUsedtype:@"32" UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"dispatch_group_aasync==============%ld",i);
                if(i==(imgList.count-1))
                {
                    if([[THIndicatorVC sharedTHIndicatorVC] isStarting])
                    {
                        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                    }
                }
                if(resultCode==SucceedCode)
                {
                    upImg.picID=(NSString *)data;
                    upImg.isUpLoad=1;
                    [selfWeak.collectionV reloadData];

                }
                else
                {
                    upImg.isUpLoad=2;
                    [selfWeak showToastMsg:data Duration:5.0];
                    [selfWeak.collectionV reloadData];
                }
                
            });
            
        }];
        
    }
}

///上传单张图片
-(void)upLoadImgForInde:(NSInteger) index
{
    UpImageModel *upImg;
    upImg=[imgList objectAtIndex:index];
    [AppSystemSetPresenters upLoadPicFile:upImg.img withUsedtype:@"32"  UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultCode==SucceedCode)
            {
                upImg.picID=(NSString *)data;
                upImg.isUpLoad=1;
                
            }
            else
            {
                upImg.isUpLoad=2;
                [self showToastMsg:data Duration:5.0];
                [self.collectionV reloadData];
            }
            
        });
        
    }];
}

#pragma mark TZImagePickerControllerDelegate
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
   
}

- (IBAction)publishAction:(id)sender {
    
    UIButton * tempBtn = sender;
    tempBtn.enabled = NO;
    
    if ((imgList.count==0||imgList==nil)&&(isFirst)) {
        [self showToastMsg:@"说点什么吧！" Duration:2.5f];
        tempBtn.enabled = YES;
        return;

    }
   if(isFirst)
   {
       tempTV.text = @"";
   }
    [imgIDs removeAllObjects];
    for (int i =0; i<imgList.count; i++) {
        UpImageModel *upImg = [imgList objectAtIndex:i];
        
        if (upImg.isUpLoad==1) {
            [imgIDs addObject:upImg.picID];
        }

    }
    
    @WeakObj(self)
    NSString * picIDs = [imgIDs componentsJoinedByString:@","];
    NSLog(@"图片ids=====%@",picIDs);
//    NSLog(@"图片ids=====%@",[self.topicID stringByReplacingOccurrencesOfString:@"'" withString:@""])

    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
    [indicator startAnimating:self.tabBarController];

    [PostPresenter addTopicPosts:[self.topicID stringByReplacingOccurrencesOfString:@"'" withString:@""] withPicIDs:picIDs andContent:tempTV.text andCallBack:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",data);
            [indicator stopAnimating];
            tempBtn.enabled = YES;
            
            if (resultCode == SucceedCode) {
                
                
                NSString * addinte = [data objectForKey:@"addinte"];
                ///
                if(addinte.integerValue == 0 )
                {
                    [selfWeak showToastMsg:@"发表成功！" Duration:2.5f];

                }else
                {
                    [selfWeak showToastMsg:[NSString stringWithFormat:@"首次发布圈子贴子成功，积分增加%@分！",addinte] Duration:4.0f];

                }
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }else if (resultCode == FailureCode)
            {
                [selfWeak showToastMsg:data Duration:2.5f];

            }
        });
        
      
    }];
    
}
@end
