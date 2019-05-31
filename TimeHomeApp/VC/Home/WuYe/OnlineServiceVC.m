//
//  OnlineServiceVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/2.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "OnlineServiceVC.h"
#import "LCActionSheet.h"
#import "CommunityManagerPresenters.h"
#import "PopListVC.h"
#import "TZImagePickerController.h"
#import "ZZPhotoKit.h"
#import "ImgCollectionCell.h"
#import "AppSystemSetPresenters.h"
#import "ReleaseReservePresenter.h"
#import "UpImageModel.h"
#import "RegularUtils.h"
#import "RepairDevTypeModel.h"
#import "CommunityManagerPresenters.h"
#import "UserReservePic.h"
#import "THMyRepairedListsViewController.h"
#import "ImageUitls.h"

@interface OnlineServiceVC ()<TZImagePickerControllerDelegate,ZZBrowserPickerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>
{
    ///公共设备类型数据
    NSArray * publicDevArray;
    ///家用设备类型数据
    NSArray * homeDevArray;
    ///公共地址数据
    NSArray * publicAddresArray;
    ///家用地址数据
    NSArray * homeAddresArray;
    ///图片数组
    NSMutableArray *imgArray;
    ///上传计数
    NSInteger Count;
    ///YES 公共 NO 家用
    BOOL isPublic;
    
    AppDelegate *appDlgt;
    ////报修逻辑处理
    ReleaseReservePresenter * releasePresenter;
    ///选中的设备分类ID
    NSString * devTypeID;
    ///选中的公共地址ID
    NSString * pAddresID;
    ///选中的家用地址ID
    NSString * hAddresID;
}
/**
 *  公共设施
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_PublicDev;
/**
 *  公共选中状态
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_PublicSelect;
/**
 *  家用设施
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_HouseholdDev;

/**
 *  家用选择状态
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_HouseholdSelect;
/**
 *  选择设备类型
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_SelectDevType;
/**
 *  设备维修价格
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Pic;
/**
 *  设备价格控件高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naLay_PicHeight;

/**
 *  报修详述
 */
@property (weak, nonatomic) IBOutlet UITextView *TV_Content;
/**
 *  报修详述输入字数
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_ContentNum;
/**
 *  报修手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Phone;
/**
 *  报修地址
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_AddrText;

///图片显示
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation OnlineServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [TalkingData trackPageBegin:@"zaixianbaoxiu"];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:ZaiXianBaoXiu];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"zaixianbaoxiu"];
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":ZaiXianBaoXiu}];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getDevType];
    [self getPublicAddress];
    [self getHomeAddress];
}

#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    appDlgt=GetAppDelegates;
    imgArray=[NSMutableArray new];
    releasePresenter=[ReleaseReservePresenter new];
    
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImgCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ImgCollectionCell"];
    self.TV_Content.delegate=self;
    self.TF_Phone.text=appDlgt.userData.phone;
    isPublic=YES;
    
    
    if(self.jmpCode==1)///修改赋值
    {
        if(![XYString isBlankString:self.userInfo.type])
        {
            if([self.userInfo.type integerValue]==0)
            {
                isPublic=NO;
            }
            else
            {
                isPublic=YES;
            }
        }
        if(![XYString isBlankString:self.userInfo.typeID])
        {
            devTypeID=self.userInfo.typeID;
        }
        if(![XYString isBlankString:self.userInfo.typeID])
        {
            [self.btn_SelectDevType setTitle:self.userInfo.typeName forState:UIControlStateNormal];
        }
        if(![XYString isBlankString:self.userInfo.feedback])
        {
            self.TV_Content.text=self.userInfo.feedback;
            self.lab_ContentNum.text=[NSString stringWithFormat:@"%ld/200",(unsigned long)self.userInfo.feedback.length];
        }
        if(self.userInfo.piclist.count > 0)
        {
            UpImageModel * upImg;
            for(int i=0;i<self.userInfo.piclist.count;i++)
            {
                UserReservePic * urp=[self.userInfo.piclist objectAtIndex:i];
                upImg=[UpImageModel new];
                upImg.picID=urp.theID;
                upImg.imgUrl=urp.fileurl;
                upImg.isUpLoad=1;
                [imgArray addObject:upImg];
                [self.collectionView reloadData];
            }
        }
        if(![XYString isBlankString:self.userInfo.phone])
        {
            self.TF_Phone.text=self.userInfo.phone;
        }
        if(isPublic)
        {
            if(![XYString isBlankString:self.userInfo.addressid])
            {
                pAddresID=self.userInfo.addressid;
            }
            
        }
        else
        {
            if(![XYString isBlankString:self.userInfo.residenceid])
            {
                hAddresID=self.userInfo.residenceid;
            }
            self.lab_Pic.text=[NSString stringWithFormat:@"参考价格 : %@",self.userInfo.pricedesc];
        }
        if(![XYString isBlankString:self.userInfo.address])
        {
            [self.btn_AddrText setTitle:self.userInfo.address forState:UIControlStateNormal];
        }
        else
        {
            [self.btn_AddrText setTitle:@"" forState:UIControlStateNormal];
        }
        
        
    }
    if(isPublic)
    {
        self.btn_PublicDev.layer.borderColor=PURPLE_COLOR.CGColor;
        self.img_PublicSelect.image=[UIImage imageNamed:@"单选_选中"];
        
        self.btn_HouseholdDev.layer.borderColor=LINE_COLOR.CGColor;
        self.img_HouseholdSelect.image=[UIImage imageNamed:@"单选_未选中"];
        self.lab_Pic.hidden=YES;
        self.naLay_PicHeight.constant=0;
    }
    else
    {
        self.btn_HouseholdDev.layer.borderColor=PURPLE_COLOR.CGColor;
        self.img_HouseholdSelect.image=[UIImage imageNamed:@"单选_选中"];
        
        self.btn_PublicDev.layer.borderColor=LINE_COLOR.CGColor;
        self.img_PublicSelect.image=[UIImage imageNamed:@"单选_未选中"];
        self.lab_Pic.hidden=NO;
        self.naLay_PicHeight.constant=15;
    }

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
    if(![XYString isBlankString:upImg.imgUrl])
    {
        [cell.img_Pic sd_setImageWithURL:[NSURL URLWithString:upImg.imgUrl] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
    }
    else
    {
        cell.img_Pic.image=upImg.img;
    }
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

#pragma mark----------切换设施类型后初始化数据------

-(void)initWeiXiuType
{
    if(self.jmpCode==1)
    {
        return;
    }
    
    self.lab_Pic.text = @"参考价格 : 暂无";
    devTypeID = @"";
    self.TV_Content.text = @"请详细说明已损坏设施的具体情况（不能少于5个字）";
    [self.btn_SelectDevType setTitle:@"请选择报修设施" forState:UIControlStateNormal];
    
}
#pragma mark----------事件处理-------

/**
 *  选择公共设施事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_PublicDevEvent:(UIButton *)sender {
    
    [self initWeiXiuType];
    isPublic=YES;
    self.btn_PublicDev.layer.borderColor=PURPLE_COLOR.CGColor;
    self.img_PublicSelect.image=[UIImage imageNamed:@"单选_选中"];
    
    self.btn_HouseholdDev.layer.borderColor=LINE_COLOR.CGColor;
    self.img_HouseholdSelect.image=[UIImage imageNamed:@"单选_未选中"];
    self.lab_Pic.hidden=YES;
    self.naLay_PicHeight.constant=0;
}
/**
 *  选择家用设施事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_HouseholdDevEvent:(UIButton *)sender {
    [self initWeiXiuType];

    isPublic=NO;
    self.btn_HouseholdDev.layer.borderColor=PURPLE_COLOR.CGColor;
    self.img_HouseholdSelect.image=[UIImage imageNamed:@"单选_选中"];
    
    self.btn_PublicDev.layer.borderColor=LINE_COLOR.CGColor;
    self.img_PublicSelect.image=[UIImage imageNamed:@"单选_未选中"];
    self.lab_Pic.hidden=NO;
    self.naLay_PicHeight.constant=15;
}
/**
 *  选择设备类型事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_SelectDevTypeEvent:(UIButton *)sender {
    
    NSArray * listData;
    if(isPublic)
    {
        listData=publicDevArray;
    }
    else{
        listData=homeDevArray;
    }
    if(listData==nil||listData.count==0)
    {
        [self showToastMsg:@"未获取到设备分类,不能使用维修发布,请联系物业管理人员" Duration:5.0];
        return;
    }
    NSInteger heigth= listData.count>10?(SCREEN_HEIGHT/2):(listData.count*50.0);
    PopListVC * popList=[PopListVC getInstance];
    popList.nsLay_TableHeigth.constant=heigth;
    @WeakObj(popList);
    [popList showVC:self listData:listData cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        RepairDevTypeModel *devType =( RepairDevTypeModel *)data;
        devTypeID=devType.ID;
        [sender setTitle:devType.name forState:UIControlStateNormal];
        self.lab_Pic.text=[NSString stringWithFormat:@"参考价格 : %@",devType.pricedesc];
        [popListWeak dismissVC];
        
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        UITableViewCell * cell=(UITableViewCell *)view;
        RepairDevTypeModel *devType =( RepairDevTypeModel *)data;
        cell.textLabel.text=devType.name;
        cell.textLabel.numberOfLines=0;
    }];

}
/**
 *  拍照事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_TakingPicEvent:(UIButton *)sender {
    
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
                    UIImage * img;
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

/**
 *  手机号输入变化
 *
 *  @param sender <#sender description#>
 */
- (IBAction)TV_PhoneChange:(UITextField *)sender {
    
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>11)
        {
            sender.text=[sender.text substringToIndex:11];
        }
    }

}
/**
 *  地址选择事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_AddrSelectEvent:(UIButton *)sender {
    NSArray * listData;
    if(isPublic)
    {
        listData=publicAddresArray;
    }
    else{
        listData=homeAddresArray;
    }
    if(listData==nil||listData.count==0)
    {
        [self showToastMsg:@"未获取到地址分类,不能使用维修发布,请联系物业管理人员" Duration:5.0];
        return;
    }
    NSInteger heigth= listData.count>10?(SCREEN_HEIGHT/2):(listData.count*50.0);
    PopListVC * popList=[PopListVC getInstance];
    popList.nsLay_TableHeigth.constant=heigth;
    @WeakObj(popList);
    [popList showVC:self listData:listData cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        NSDictionary *devAddr;
        if(isPublic)
        {
           devAddr =(NSDictionary *)data;
            /**
             ,”list”:[{
             “id”: ”12122”
             ,”name”:”广场东”
             }]
             */
            pAddresID=[devAddr objectForKey:@"id"];
            [sender setTitle:[devAddr objectForKey:@"name"] forState:UIControlStateNormal];
        }
        else{
           devAddr =(NSDictionary *)data;
            /**
             ,“list”:[{
             ”id”:”12“
             ,”communityname”:”金谈固家园”
             ,”propertyname”:”恒祥物业”
             ,”name”:”1号楼 3单元506”
             ,”builtuparea”:120.6
             ,”usearea”:100.6
             ,”expiretime”:”2016-06-30”
             ,”isinstall”:1
             }]
             */
            hAddresID=[devAddr objectForKey:@"id"];
            NSString * name=[NSString stringWithFormat:@"%@%@",[devAddr objectForKey:@"communityname"],[devAddr objectForKey:@"name"]];
            [sender setTitle:name forState:UIControlStateNormal];
        }
        [popListWeak dismissVC];
        
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        UITableViewCell * cell=(UITableViewCell *)view;
        NSDictionary *devAddr=(NSDictionary *)data;;
        if(isPublic)
        {
            
            /**
             ,”list”:[{
             “id”: ”12122”
             ,”name”:”广场东”
             }]
             */
            cell.textLabel.text=[devAddr objectForKey:@"name"];
        }
        else{
            /**
             ,“list”:[{
             ”id”:”12“
             ,”communityname”:”金谈固家园”
             ,”propertyname”:”恒祥物业”
             ,”name”:”1号楼 3单元506”
             ,”builtuparea”:120.6
             ,”usearea”:100.6
             ,”expiretime”:”2016-06-30”
             ,”isinstall”:1
             }]
             */
            NSString * name=[NSString stringWithFormat:@"%@%@",[devAddr objectForKey:@"communityname"],[devAddr objectForKey:@"name"]];
            cell.textLabel.text=name;
        }
        
        cell.textLabel.numberOfLines=0;
    }];

}




/**
 *  上传报修信息
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_RepairEvent:(UIButton *)sender {
    if(self.jmpCode==1)
    {
        [self sumbitChangeData];
        return;
    }
    [self sumbitData];
}

#pragma mark -----------TZImagePickerControllerDelegate-------

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


#pragma mark ------------UITextViewDelegate实现-----------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(nonnull UITextView *)textView
{
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
    if ([self.TV_Content.text isEqualToString:@"请详细说明已损坏设施的具体情况（不能少于5个字）"]) {
        self.TV_Content.text=@"";
    }
    self.TV_Content.textColor=UIColorFromRGB(0x8e8e8e);
}
-(void)textViewDidChange:(UITextView *)textView
{
    UITextRange * selectedRange = textView.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        self.lab_ContentNum.text=[NSString stringWithFormat:@"%ld/200",(unsigned long)self.TV_Content.text.length];
        if (self.TV_Content.text.length>200) {
            self.TV_Content.text=[textView.text substringToIndex:200];
            [self showToastMsg:@"输入内容超过200字了" Duration:5.0];
            self.lab_ContentNum.text=[NSString stringWithFormat:@"%d/200",200];
            return;
        }
        
    }
    
}

//请详细说明已损坏设施的具体情况（不能少于5个字）

#pragma mark ----------------------网络数据--------------------------
///提交报修
-(void)sumbitData
{
    if(![RegularUtils isPhoneNum:self.TF_Phone.text])//验证手机号正确
    {
        [self showToastMsg:@"手机号不正确,请重新输入" Duration:5.0];
        return;
    }
    if([self.TV_Content.text isEqualToString:@"请详细说明已损坏设施的具体情况（不能少于5个字）"])
    {
        [self showToastMsg:@"您还没有填写详细描述" Duration:5.0];
        return;
    }
    if(self.TV_Content.text.length<5)
    {
        [self showToastMsg:@"填写详细描述不能少于5个字" Duration:5.0];
        return;
    }
    if(devTypeID==nil||devTypeID.length==0)
    {
        [self showToastMsg:@"请选择报修设施" Duration:5.0];
        return;
    }
    if(isPublic)
    {
        if(pAddresID==nil||pAddresID.length==0)
        {
            [self showToastMsg:@"请选择报修地址" Duration:5.0];
            return;
        }
        hAddresID=@"0";
    }
    else{
        if(hAddresID==nil||hAddresID.length==0)
        {
            [self showToastMsg:@"请选择报修地址" Duration:5.0];
            return;
        }
        pAddresID=@"0";
    }
    NSMutableString * picIDs=[NSMutableString new];
    [picIDs appendString:@""];
    UpImageModel * upImg;
    for(int i=0;i<imgArray.count;i++)
    {
        upImg=[imgArray objectAtIndex:i];
        [picIDs appendString:upImg.picID];
        if(i<imgArray.count-1)
        {
            [picIDs appendString:@","];
        }
        
    }
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    @WeakObj(self);
    [releasePresenter addReserveForTypeId:devTypeID phone:self.TF_Phone.text feedback:self.TV_Content.text picids:picIDs residenceid:hAddresID addressed:pAddresID andReservedate:@"" upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                [selfWeak showToastMsg:@"报修成功" Duration:5.0];
//                [selfWeak.navigationController popViewControllerAnimated:YES];
//                if(selfWeak.jmpCode==1)
//                {
//                    [selfWeak.navigationController popViewControllerAnimated:YES];
//                }
//                else
//                {
                    //我的维修
                    THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
                    subVC.isFromRelease=YES;
                    
                    [selfWeak.navigationController pushViewController:subVC animated:YES];
//                }
            }
            else
            {
                [selfWeak showToastMsg:data Duration:5.0];
            }
            
        });
    }];

}

///提交报修
-(void)sumbitChangeData
{
    if(![RegularUtils isPhoneNum:self.TF_Phone.text])//验证手机号正确
    {
        [self showToastMsg:@"手机号不正确,请重新输入" Duration:5.0];
        return;
    }
    if([self.TV_Content.text isEqualToString:@"请详细说明已损坏设施的具体情况（不能少于5个字）"])
    {
        [self showToastMsg:@"您还没有填写详细描述" Duration:5.0];
        return;
    }
    if(self.TV_Content.text.length<5)
    {
        [self showToastMsg:@"填写详细描述不能少于5个字" Duration:5.0];
        return;
    }
    if(devTypeID==nil||devTypeID.length==0)
    {
        [self showToastMsg:@"请选择报修设施" Duration:5.0];
        return;
    }
    if(isPublic)
    {
        if(pAddresID==nil||pAddresID.length==0)
        {
            [self showToastMsg:@"请选择报修地址" Duration:5.0];
            return;
        }
        hAddresID=@"0";
    }
    else{
        if(hAddresID==nil||hAddresID.length==0)
        {
            [self showToastMsg:@"请选择报修地址" Duration:5.0];
            return;
        }
        pAddresID=@"0";
    }
    NSMutableString * picIDs=[NSMutableString new];
    [picIDs appendString:@""];
    UpImageModel * upImg;
    for(int i=0;i<imgArray.count;i++)
    {
        upImg=[imgArray objectAtIndex:i];
        [picIDs appendString:upImg.picID];
        if(i<imgArray.count-1)
        {
            [picIDs appendString:@","];
        }
        
    }
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    @WeakObj(self);
    
    
 
    [releasePresenter changeToReserveForTypeId:devTypeID phone:self.TF_Phone.text feedback:self.TV_Content.text picids:picIDs residenceid:hAddresID addressed:pAddresID reserveid:self.userInfo.theID andReservedate:@"" upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                [selfWeak showToastMsg:@"提交成功" Duration:5.0];
                
                    if(selfWeak.jmpCode==1)
                    {
                        //我的维修
                        THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
                        subVC.isFromRelease=YES;
                        
                        [selfWeak.navigationController pushViewController:subVC animated:YES];
                    }
                    else
                    {
                        [selfWeak.navigationController popViewControllerAnimated:YES];
                    }
                
            }
            else
            {
                [selfWeak showToastMsg:data Duration:5.0];
            }
            
        });

    }];
    
}


///上传图片
-(void)upLoadImgForImg
{
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
                if(resultCode==SucceedCode)
                {
                    NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                    
                    upImg.picID=(NSString *)picID;
                    upImg.isUpLoad=1;
                }
                else
                {
                    upImg.isUpLoad=2;
                    [self showToastMsg:[NSString stringWithFormat:@"第%ld张图片上传失败了",(long)i] Duration:5.0];
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
                [self showToastMsg:@"上传失败" Duration:5.0];
                [self.collectionView reloadData];
            }
            
        });
        
    }];
}
////获取设备
-(void)getDevType
{
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];

    [releasePresenter getReserveTypeForupDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                NSArray * devList=(NSArray *)data;
                NSLog(@"dev===%@",devList);
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type BEGINSWITH[c] %@", @"1"];
                publicDevArray = [devList filteredArrayUsingPredicate:predicate];
                
                predicate = [NSPredicate predicateWithFormat:@"type BEGINSWITH[c] %@", @"0"];
                homeDevArray = [devList filteredArrayUsingPredicate:predicate];
            }
            else
            {
//                [selfWeak showToastMsg:data Duration:5.0];
//                [selfWeak showToastMsg:@"获取维修设备类型失败!" Duration:5.0];
            }
            
        });
    }];

}
///获取公共设备地址
-(void)getPublicAddress
{
    //@WeakObj(self);
    [releasePresenter getReserveAddressForupDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultCode==SucceedCode)
            {
                publicAddresArray=(NSArray *)data;
            }
            else
            {
//                [selfWeak showToastMsg:@"获取公共维修地址失败!" Duration:5.0];
            }
            
        });
    }];
}
///个人地址
-(void)getHomeAddress
{

    [CommunityManagerPresenters getUserResidenceUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultCode==SucceedCode)
            {
                homeAddresArray=(NSArray *)data;

            }
            else
            {
//                [selfWeak showToastMsg:@"获取家用维修地址失败!" Duration:5.0];
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
