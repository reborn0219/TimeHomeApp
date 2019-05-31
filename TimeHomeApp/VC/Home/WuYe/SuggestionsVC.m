//
//  SuggestionsVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/2.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SuggestionsVC.h"
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

@interface SuggestionsVC ()<TZImagePickerControllerDelegate,ZZBrowserPickerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>
{
    ///物业列表数据
    NSArray * wuyeArray;
    ///选中的物业id
    NSString * wuyeID;
    ///图片数组
    NSMutableArray *imgArray;
    ///上传计数
    NSInteger Count;

}

/**
 *  提示语
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Prompt;

/**
 *  选择物业
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_SelectWY;
/**
 *  投诉内容
 */
@property (weak, nonatomic) IBOutlet UITextView *TV_Content;
/**
 *  投诉内容字数
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_ContentNum;
///图片内容父视图
@property (weak, nonatomic) IBOutlet UIView *view_imgBg;
///图片集合
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SuggestionsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [TalkingData trackPageBegin:@"jianyitousu"];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:JianYiTouSu];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"jianyitousu"];
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":JianYiTouSu}];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getWuYeData];
}

#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    self.lab_Prompt.text=@"提出您对物业的意见或建议\n以便物业为您提供更优质的服务";
    imgArray=[NSMutableArray new];
    
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImgCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ImgCollectionCell"];
    
    self.TV_Content.delegate=self;
    self.lab_ContentNum.text=@"0/100";

}
#pragma mark - ---------UICollection协议实现--------------
/**
 *  返回集合个数
 *
 *  @param view    <#view description#>
 *  @param section section description
 *
 *  @return return value 返回集合个数
 */
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [imgArray count];
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
    ImgCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImgCollectionCell" forIndexPath:indexPath];
    UpImageModel * upImg=[imgArray objectAtIndex:indexPath.row];
    cell.img_Pic.image=upImg.img;
    cell.indexPath=indexPath;
    cell.lab_TiShi.hidden=YES;
    if(upImg.isUpLoad==2)
    {
        cell.lab_TiShi.hidden=NO;
    }
    
    cell.eventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
    {
        [imgArray removeObjectAtIndex:index.row];
        [self.collectionView reloadData];
    };
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH_SCALE(1/5), WIDTH_SCALE(1/5));
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImgCollectionCell *cell=(ImgCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.backgroundView setBackgroundColor:UIColorFromRGB(0xffffff)];
    
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImgCollectionCell *cell=(ImgCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.backgroundView setBackgroundColor:UIColorFromRGB(0x818181)];
}

//事件处理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UpImageModel * upImg=[imgArray objectAtIndex:indexPath.row];
    if(upImg.isUpLoad==2)
    {
        [self upLoadImgForInde:indexPath.row];
    }

}


#pragma mark TZImagePickerControllerDelegate
/// 用户点击了取消
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
    
    if(photos!=nil&&photos.count>0)
    {
        
        UpImageModel * upImage;
        Count=imgArray.count-1;//上传计数初值
        Count=Count<0?0:Count;
        UIImage *img;
        for(int i=0;i<photos.count;i++)
        {
            upImage=[UpImageModel new];
            img=[photos objectAtIndex:i];
            img=[ImageUitls imageCompressForWidth:img targetWidth:PIC_PIXEL_W];
            img=[ImageUitls reduceImage:img percent:PIC_SCALING];
            
            
            upImage.img=img;
            upImage.isUpLoad=0;
            [imgArray addObject:upImage];
        }
        [self upLoadImgForImg];

        [self.collectionView reloadData];
        
    }

    [self.collectionView reloadData];
    
}

#pragma mark ------------事件----------
///提交
- (IBAction)btn_Sumbit:(UIButton *)sender {
    [self upSuggestions];
}


/**
 *  选择物业事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_SelectWYEvent:(UIButton *)sender {
    if(wuyeArray!=nil&&wuyeArray.count>0)
    {

        NSInteger heigth= [wuyeArray count]>10?(SCREEN_HEIGHT/2):(wuyeArray.count*50.0);
        PopListVC * popList=[PopListVC getInstance];
        popList.nsLay_TableHeigth.constant=heigth;
        @WeakObj(popList);
        [popList showVC:self listData:wuyeArray cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
            NSDictionary *dic =( NSDictionary *)data;
            wuyeID=[dic objectForKey:@"id"];
            [sender setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
            [popListWeak dismissVC];
            
        } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
            UITableViewCell * cell=(UITableViewCell *)view;
            NSDictionary *dic =( NSDictionary *)data;
            cell.textLabel.text=[dic objectForKey:@"name"];
            cell.textLabel.numberOfLines=0;
        }];

    }
    else
    {
        [self showToastMsg:@"没有找到物业,请重试" Duration:5.0];
    }
    
    
}
/**
 *  拍照事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)bnt_TakingPicEvent:(UIButton *)sender {
    if(imgArray.count>=4)
    {
        [self showToastMsg:@"最多能选四张图片" Duration:5.0];
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
            cameraController.takePhotoOfMax = 4-imgArray.count;
            cameraController.isSaveLocal = NO;
            [cameraController showIn:self result:^(id responseObject){

                NSArray *array = (NSArray *)responseObject;
                if(array!=nil&&array.count>0)
                {
                    
                    UpImageModel * upImage;
                    Count=imgArray.count-1;//上传计数初值
                    Count=Count<0?0:Count;
                    UIImage *img;
                    for(int i=0;i<array.count;i++)
                    {
                        upImage=[UpImageModel new];
                        img=[array objectAtIndex:i];
                        img=[ImageUitls imageCompressForWidth:img targetWidth:PIC_PIXEL_W];
                        img=[ImageUitls reduceImage:img percent:PIC_SCALING];
                        upImage.img=img;
                        upImage.isUpLoad=0;
                        [imgArray addObject:upImage];
                    }

                    [self upLoadImgForImg];
                    
                    [self.collectionView reloadData];
  
                }
                
            }];

        }
        else if (buttonIndex==1)//相册
        {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4-imgArray.count delegate:self];
            
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
                
            }];
            
            [self presentViewController:imagePickerVc animated:YES completion:nil];

        }
    }];
    [sheet setTextColor:UIColorFromRGB(0xffffff)];
    [sheet show];
    

}
#pragma mark ------------UITextViewDelegate实现-----------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(nonnull UITextView *)textView {
    
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height- ( textView.contentOffset.y + textView.bounds.size.height- textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
    if ([self.TV_Content.text isEqualToString:@"在此输入您的意见或建议"]) {
        self.TV_Content.text=@"";
    }
    self.TV_Content.textColor=UIColorFromRGB(0x818181);
}
-(void)textViewDidChange:(UITextView *)textView {
    
    UITextRange * selectedRange = textView.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        self.lab_ContentNum.text=[NSString stringWithFormat:@"%ld/100",(unsigned long)self.TV_Content.text.length];
        if (self.TV_Content.text.length>100) {
            self.TV_Content.text=[textView.text substringToIndex:100];
            [self showToastMsg:@"输入内容超过100字了" Duration:5.0];
             self.lab_ContentNum.text=[NSString stringWithFormat:@"%d/100",100];
            return;
        }
        
    }
    
}



#pragma mark ----------------------网络数据--------------------------
///获取物业数据
-(void)getWuYeData
{
    if(wuyeArray.count>0)
    {
        return;
    }
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [CommunityManagerPresenters getCompropertyUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode==SucceedCode)
            {
                wuyeArray=(NSArray *)data;
            }
            else
            {
//                [self showToastMsg:data Duration:5.0];
                
            }
            
        });

    }];
}
///上传图片
-(void)upLoadImgForImg
{
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    UpImageModel *upImg;
    for(NSInteger i=Count;i<imgArray.count;i++)
    {
        upImg=[imgArray objectAtIndex:i];
        
        if(upImg.isUpLoad==1||upImg.img==nil)
        {
            continue;
        }
            [AppSystemSetPresenters upLoadPicFile:upImg.img UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"dispatch_group_async==============%ld",(long)i);
                    if(i==(imgArray.count-1))
                    {
                        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                        [self showToastMsg:@"图片上传成功" Duration:5];
                    }
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

    
}
///上传单张图片
-(void)upLoadImgForInde:(NSInteger) index
{
    UpImageModel *upImg;
    upImg=[imgArray objectAtIndex:index];
    [AppSystemSetPresenters upLoadPicFile:upImg.img UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
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
///提交建议
-(void)upSuggestions
{
    if([XYString isBlankString:wuyeID])
    {
        [self showToastMsg:@"您还没选择要投诉的物业" Duration:3.0];
        return;
    }
    if([self.TV_Content.text isEqualToString:@"在此输入您的意见或建议"])
    {
        [self showToastMsg:@"您还没有填写投诉内容" Duration:3.0];
        return;
    }
    if(self.TV_Content.text.length<5)
    {
        [self showToastMsg:@"投诉内容不能少于5个字" Duration:3.0];
        return;
    }
    NSMutableString * picIDs=[NSMutableString new];
    [picIDs appendString:@""];
    UpImageModel * upImg;
    
    if (imgArray.count > 0) {
        
        for(int i=0;i<imgArray.count;i++)
        {
            upImg=[imgArray objectAtIndex:i];
            [picIDs appendString:upImg.picID];
            if(i<imgArray.count-1)
            {
                [picIDs appendString:@","];
            }
            
        }
    }
    
    @WeakObj(self);
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    ReleaseReservePresenter * reservePresenter=[ReleaseReservePresenter new];
    [reservePresenter addComplaintForPropertyid:wuyeID content:self.TV_Content.text picids:picIDs upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                [selfWeak showToastMsg:@"提交成功" Duration:5.0];
                if (selfWeak.callBack) {
                    selfWeak.callBack();
                }
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [selfWeak showToastMsg:data Duration:5.0];
                
            }
            
        });

    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
