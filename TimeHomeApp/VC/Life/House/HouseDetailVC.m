//
//  HouseDetailVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "HouseDetailVC.h"
#import "UserReservePic.h"
#import "DateUitls.h"
#import "ShowMapVC.h"
#import "SysPresenter.h"
#import "ChatViewController.h"
#import "YYCollectionPresent.h"
#import "SDCycleScrollView.h" //轮播图
@interface HouseDetailVC ()<SDCycleScrollViewDelegate,SDPhotoBrowserDelegate>
{
    
}
/**
 *  图片轮播
 */
@property (weak, nonatomic) IBOutlet SDCycleScrollView *banner;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
/**
 *  新旧
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_NAOD;
/**
 *  用于隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_NAODWidth;

/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Price;
/**
 *  日期
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Date;
/**
 *  用于隐藏
 */
@property (weak, nonatomic) IBOutlet UIView *view_HouseInfo;
/**
 *  房屋信息高度，用于隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_HouseHeight;
/**
 *  房屋信息距顶部控件距离，用于隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_HouseTop;

/**
 *  户型
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_HouseType;
/**
 *  面积
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Area;
/**
 *  朝向
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Towards;
/**
 *  楼层
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_floor;
/**
 *  类型
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Type;
/**
 *  装修
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Decoration;
/**
 *  用于隐藏，建筑年代和产权行
 */
@property (weak, nonatomic) IBOutlet UIView *view_PropertyRight;
/**
 *  建筑年代
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Building;
/**
 *  产权
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_PropertRight;
/**
 *  用于隐藏，产证手行
 */
@property (weak, nonatomic) IBOutlet UIView *view_InHand;
/**
 *  产证是否在手
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_InHand;

/**
 *  建筑年代和产权行高，用于隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_PropertRightHeight;
/**
 *  用于隐藏，产证高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_InHandHeight;



/**
 *  小区
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Biotope;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Addrs;
/**
 *  详情
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Detail;
/**
 *  名字，手机号
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_NamePhone;
/**
 *  内容高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_ContentHeight;
/**
 *  收藏按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *collection_Button;

@property (weak, nonatomic) IBOutlet UIView *firstLineView;


@end

@implementation HouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setBannerData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark --------初始化----------
-(void)initView
{
    
    if(_jumCode==2){
        self.nsLay_ContentHeight.constant-=self.nsLay_HouseHeight.constant;
        self.nsLay_HouseHeight.constant=0;
        self.nsLay_HouseTop.constant=0;
        self.view_HouseInfo.hidden=YES;
        
        [self setUserMarketData];
        self.title = @"物品详情";
        
    }else if(_jumCode==0){
        self.nsLay_NAODWidth.constant=0;
        self.lab_NAOD.hidden=YES;
        
        self.nsLay_HouseHeight.constant=self.nsLay_HouseHeight.constant-self.nsLay_InHandHeight.constant-self.nsLay_PropertRightHeight.constant-2;
        
        self.nsLay_InHandHeight.constant=0;
        self.nsLay_PropertRightHeight.constant=0;
        self.view_InHand.hidden=YES;
        self.view_PropertyRight.hidden=YES;
        
        [self setChuZhuData];
        
    }else if(_jumCode==1){
        self.nsLay_NAODWidth.constant=0;
        self.lab_NAOD.hidden=YES;
        [self setChuShouData];
    }
    
}

///设备轮播图
-(void)setBannerData{
    self.banner.delegate = self;
    self.banner.placeholderImage = [UIImage imageNamed:@"图片加载失败@2x.png"];
    self.banner.autoScroll = NO;
    
    if(self.room){
        NSURL *url;
        UserReservePic *urPic;
        NSMutableArray *urlArray = [NSMutableArray array];
        
        if(self.room.piclist==nil ||self.room.piclist.count==0){
            NSArray *images = @[
                                @"未上传照片@2x.png",
                                ];
            self.banner.autoScroll = NO;
            self.banner.localizationImageNamesGroup = images;
        }else{
            for(int i=0;i<self.room.piclist.count;i++){
                urPic=[self.room.piclist objectAtIndex:i];
                url = [NSURL URLWithString:urPic.fileurl];
                [urlArray addObject:url];
            }
            
            if (self.room.piclist.count > 1) {
                self.banner.autoScroll = YES;
            }else {
                self.banner.autoScroll = NO;
            }
            self.banner.imageURLStringsGroup = urlArray;
        }
    }
}
///出租数据设置
-(void)setChuZhuData
{
    if(self.room)
    {
        self.lab_Title.text=self.room.title;
        self.lab_Price.text=[NSString stringWithFormat:@"%@元/月",[self.room.money stringByReplacingOccurrencesOfString:@".0" withString:@""]];
        self.lab_Date.text=[DateUitls stringFromDate:[DateUitls DateFromString:self.room.releasedate DateFormatter:@"yyyy-MM-dd HH:mm:ss"] DateFormatter:@"yyyy-MM-dd HH:mm"];
        self.lab_HouseType.text=[NSString stringWithFormat:@"%@室%@厅%@卫",self.room.bedroom,self.room.livingroom,self.room.toilef];
        self.lab_Area.text=[NSString stringWithFormat:@"%@平米",self.room.area];
        NSArray *toward= @[@"南北通透",@"东西向",@"朝南",@"朝北",@"朝东",@"朝西"];
        if([self.room.facetype integerValue]-1>=0)
        {
            self.lab_Towards.text=[toward objectAtIndex:[self.room.facetype integerValue]-1];
        }
        self.lab_floor.text=[NSString stringWithFormat:@"%@/%@层",self.room.floornum,self.room.allfloornum];
        
        NSArray * array=@[@"普通住宅",@"经济适用房",@"公寓",@"商住楼",@"酒店式公寓"];
        if([self.room.housetype integerValue]-1>=0 && self.room.housetype.integerValue < array.count)
        {
            self.lab_Type.text=[array objectAtIndex:[self.room.housetype integerValue]-1];
        }
        array=@[@"普通住宅",@"经济适用房",@"公寓",@"商住楼",@"酒店式公寓"];
        if([self.room.housetype integerValue]-1>=0 && self.room.housetype.integerValue < array.count)
        {
            self.lab_Type.text=[array objectAtIndex:[self.room.housetype integerValue]-1];
        }
        array=@[@"毛坯",@"简单装修",@"中等装修",@"精装修",@"豪华装修"];
        if([self.room.decorattype integerValue]-1>=0 && self.room.housetype.integerValue < array.count)
        {
            self.lab_Decoration.text=[array objectAtIndex:[self.room.decorattype integerValue]-1];
        }
        
        self.lab_Biotope.text=self.room.communityname;
        self.lab_Addrs.text=self.room.address;
        self.lab_Detail.text=[XYString isBlankString:self.room.descriptionString]?@"暂无":self.room.descriptionString;
        self.lab_NamePhone.text=[NSString stringWithFormat:@"%@\n%@",self.room.linkman,self.room.linkphone];
        
        AppDelegate *appDelegate = GetAppDelegates;
        
        if (![XYString isBlankString:self.room.userid]) {
            
            if (self.room.userid.intValue != appDelegate.userData.userID.intValue) {
                
                _collection_Button.hidden = NO;
                _firstLineView.hidden = NO;
                if ([_room.isfollow isEqualToString:@"1"]) {
                    
                    [_collection_Button setImage:[UIImage imageNamed:@"已收藏_房源详情_图标-拷贝"] forState:UIControlStateNormal];
                    
                }else {
                    
                    [_collection_Button setImage:[UIImage imageNamed:@"收藏_房源详情_图标"] forState:UIControlStateNormal];
                    
                }
                
            }else {
                
                _collection_Button.hidden = YES;
                _firstLineView.hidden = YES;
            }
            
        }else {
            
            _collection_Button.hidden = YES;
            _firstLineView.hidden = YES;
            
        }
        
        
    }
}
///出售数据
-(void)setChuShouData
{
    [self setChuZhuData];
    self.lab_Price.text=[NSString stringWithFormat:@"%@万元",[self.room.money stringByReplacingOccurrencesOfString:@".0" withString:@""]];
    self.lab_Building.text=self.room.buildyear;
    self.lab_PropertRight.text=self.room.propertyyear;
    NSArray * array=@[@"否",@"是"];
    if([self.room.isinhand integerValue]>=0)
    {
        self.lab_InHand.text=[array objectAtIndex:[self.room.isinhand integerValue]];
    }
    AppDelegate *appDelegate = GetAppDelegates;
    
    if (![XYString isBlankString:self.room.userid]) {
        
        if (self.room.userid.intValue != appDelegate.userData.userID.intValue) {
            
            _collection_Button.hidden = NO;
            _firstLineView.hidden = NO;
            if ([_room.isfollow isEqualToString:@"1"]) {
                
                [_collection_Button setImage:[UIImage imageNamed:@"已收藏_房源详情_图标-拷贝"] forState:UIControlStateNormal];
                
            }else {
                
                [_collection_Button setImage:[UIImage imageNamed:@"收藏_房源详情_图标"] forState:UIControlStateNormal];
                
            }
            
        }else {
            
            _collection_Button.hidden = YES;
            _firstLineView.hidden = YES;
        }
        
    }else {
        
        _collection_Button.hidden = YES;
        _firstLineView.hidden = YES;
        
    }
    
    
}
///设置二手物品数据
-(void)setUserMarketData
{
    self.lab_Title.text=self.room.name;
    self.lab_Price.text=[NSString stringWithFormat:@"%@元",[self.room.money stringByReplacingOccurrencesOfString:@".0" withString:@""]];
    self.lab_Date.text=[DateUitls stringFromDate:[DateUitls DateFromString:self.room.releasedate DateFormatter:@"yyyy-MM-dd HH:mm:ss"] DateFormatter:@"yyyy-MM-dd HH:mm"];
    self.lab_Biotope.text=self.room.communityname;
    self.lab_Addrs.text=self.room.address;
    self.lab_Detail.text=[XYString isBlankString:self.room.descriptionString]?@"暂无":self.room.descriptionString;
    self.lab_NamePhone.text=[NSString stringWithFormat:@"%@\n%@",self.room.linkman,self.room.linkphone];
    
    NSString *string = @"";
    if (self.room.newness.intValue <= 4 && self.room.newness.intValue > 0) {
        string = @"五成新以下";
    }else {
        switch (self.room.newness.intValue) {
            case 5:
            {
                string = @"五成新";
            }
                break;
            case 6:
            {
                string = @"六成新";
            }
                break;
            case 7:
            {
                string = @"七成新";
            }
                break;
            case 8:
            {
                string = @"八成新";
            }
                break;
            case 9:
            {
                string = @"九成新";
            }
                break;
            case 10:
            {
                string = @"全新";
            }
                break;
            default:
                break;
        }
    }
    _lab_NAOD.text = string;
    
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    if (![XYString isBlankString:self.room.userid]) {
        
        if (self.room.userid.intValue != appDelegate.userData.userID.intValue) {
            
            _collection_Button.hidden = NO;
            _firstLineView.hidden = NO;
            
            if ([_room.isfollow isEqualToString:@"1"]) {
                
                [_collection_Button setImage:[UIImage imageNamed:@"已收藏_房源详情_图标-拷贝"] forState:UIControlStateNormal];
                
            }else {
                
                [_collection_Button setImage:[UIImage imageNamed:@"收藏_房源详情_图标"] forState:UIControlStateNormal];
                
            }
            
        }else {
            
            _collection_Button.hidden = YES;
            _firstLineView.hidden = YES;
            
        }
        
    }else {
        
        _collection_Button.hidden = YES;
        _firstLineView.hidden = YES;
    }
    
    
    
}

#pragma mark --------事件处理----------

/**
 *  进入地图事件
 *
 *  @param sender 
 */
- (IBAction)btn_AddrMapEvent:(UIButton *)sender {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"BDMapViews" bundle:nil];
    ShowMapVC * carMap= [secondStoryBoard instantiateViewControllerWithIdentifier:@"ShowMapVC" ];
    carMap.jumpCode=2;
    carMap.title=@"查看地图";
    BMKPoiInfo * poiInfo=[BMKPoiInfo new];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.room.mapy doubleValue];
    coordinate.longitude = [self.room.mapx doubleValue];
    poiInfo.pt=coordinate;
    poiInfo.address=self.room.address;
    poiInfo.name=self.room.communityname;
    carMap.poiInfo=poiInfo;
    [self.navigationController pushViewController:carMap animated:YES];
}
/**
 *  聊天
 *
 *  @param sender
 */
- (IBAction)btn_CallPhone:(UIButton *)sender {
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    if (![XYString isBlankString:self.room.userid]) {
        
        if (self.room.userid.intValue != appDelegate.userData.userID.intValue) {
            ChatViewController *chatC =[[ChatViewController alloc] initWithChatType:XMMessageChatSingle];
            chatC.navigationItem.title = @"";
            chatC.ReceiveID = self.room.userid;
            chatC.chatterThumb = @"";
            [self.navigationController pushViewController:chatC animated:YES];
        }else {
            [self showToastMsg:@"不能和自己聊天" Duration:2.0];
        }
        
    }else {
        [self showToastMsg:@"不能和自己聊天" Duration:2.0];
    }
    
}
/**
 *  打电话
 *
 *  @param sender
 */
- (IBAction)btn_ChatEvent:(UIButton *)sender {
    
    //    SysPresenter * sysPresenter=[SysPresenter new];
    NSString * phone=self.room.linkphone;
    //    [sysPresenter callMobileNum:phone superview:self.view];
    [SysPresenter callPhoneStr:phone withVC:self];
    
}
/**
 *  收藏
 *
 *  @param sender
 */
- (IBAction)btn_Collect:(UIButton *)sender {
    
    if (self.refreshDataBlock) {
        self.refreshDataBlock();
    }
    
    NSLog(@"收藏");
    
    int type = 1;
    //_jumCode  0.出租 1.出售 2.二手物品
    if (_jumCode == 0 || _jumCode == 1) {
        type = 1;
    }
    if (_jumCode == 2) {
        type = 0;
    }
    
    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    
    if ([_room.isfollow isEqualToString:@"1"]) {
        
        [YYCollectionPresent removeSerfollowWithID:_room.theID type:[NSString stringWithFormat:@"%d",type] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                if(resultCode == SucceedCode)
                {
                    [selfWeak showToastMsg:@"取消成功" Duration:3.0];
                    _room.isfollow = @"0";
                    [sender setImage:[UIImage imageNamed:@"收藏_房源详情_图标"] forState:UIControlStateNormal];
                    
                }else {
                    
                    if ([data isKindOfClass:[NSString class]]) {
                        if (![XYString isBlankString:data]) {
                            [selfWeak showToastMsg:data Duration:3.0];
                            return ;
                        }
                    }
                    [selfWeak showToastMsg:@"取消失败" Duration:3.0];
                    
                }
                
            });
            
        }];
        
    }else {
        
        //0 二手信息 1 二手房产 2 二手车位
        [YYCollectionPresent addSerfollowWithID:_room.theID type:[NSString stringWithFormat:@"%d",type] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                if(resultCode == SucceedCode)
                {
                    [selfWeak showToastMsg:@"收藏成功" Duration:3.0];
                    _room.isfollow = @"1";
                    [sender setImage:[UIImage imageNamed:@"已收藏_房源详情_图标-拷贝"] forState:UIControlStateNormal];
                    
                }else {
                    if ([data isKindOfClass:[NSString class]]) {
                        if (![XYString isBlankString:data]) {
                            [selfWeak showToastMsg:data Duration:3.0];
                            return ;
                        }
                    }
                    [selfWeak showToastMsg:@"收藏失败" Duration:3.0];
                    
                }
                
            });
            
        }];
    }
    
    
    
    
}

///轮播图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.room.piclist.count > 0) {
        [self tapPicture:index];
    }
}


-(void)tapPicture:(NSInteger) index
{
    NSInteger count = self.room.piclist.count;
    //    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    //    UserReservePic *urPic;
    //    for (int i = 0; i<count; i++) {
    //
    //        NSString *url;
    //        MJPhoto *photo = [[MJPhoto alloc] init];
    //        urPic=[self.room.piclist objectAtIndex:i];
    //        url = urPic.fileurl;
    //        photo.url = [NSURL URLWithString:url];
    ////        photo.srcImageView = self.banner.viewsArray[index]; // 来源于哪个UIImageView
    //        [photos addObject:photo];
    //
    //    }
    //
    //    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    //    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    //    browser.photos = photos; // 设置所有的图片
    //    [browser show];
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    //    browser.sourceImagesContainerView = self.banner;
    browser.imageCount = count;
    browser.currentImageIndex = index;
    browser.delegate = self;
    [browser show]; // 展示图片浏览器
    
}
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UserReservePic *urPic = self.room.piclist[index];
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urPic.fileurl] placeholderImage:[UIImage imageNamed:@"图片加载失败@2x.png"]];
    return imageView.image;
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    UserReservePic *urPic = self.room.piclist[index];
    return [NSURL URLWithString:urPic.fileurl];
}

@end
