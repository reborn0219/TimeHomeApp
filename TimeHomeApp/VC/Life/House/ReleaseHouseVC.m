//
//  ReleaseHouseVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/10.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ReleaseHouseVC.h"
#import "PhotoWallVC.h"
#import "BMRoomPresenter.h"
#import "UpImageModel.h"
#import "LifeEditVC.h"
#import "GetAddressMapVC.h"
#import "BDMapFWPresenter.h"
#import "LifeSelectListVC.h"
#import "BMCityPresenter.h"
#import "DateUitls.h"
#import "RegularUtils.h"
#import "UserReservePic.h"
#import "HouseTableVC.h"
#import "LocationInfo.h"

/**
 *  城市区域请求
 */
#import "AppSystemSetPresenters.h"
/**
 *  地图
 */
#import "GetAddressMapVC.h"
/**
 *  定位
 */
#import "BDMapFWPresenter.h"
@interface ReleaseHouseVC ()<MapAdrrBackDelegate>
{
    ///上传图片数据
    NSMutableArray * imgArray;
    ///位置
    CLLocationCoordinate2D location;
    AppDelegate * appDlt;
    ///城市区域
    NSMutableArray * arrayDistrict;
    ///选择的区ID
    NSString * districtID;
    ///选择装修
    NSInteger decorattype;
    ///选择朝向
    NSInteger facetype;
    ///房间类型
    NSInteger housetype;
    ///选择产权
    NSString * propertyyear;
    ///产证是否在手
    NSInteger isinhand;
    ///选择建筑年代
    NSString * buildyear;
    /**
     *  定位功能
     */
    BDMapFWPresenter * bdmap;
    /**
     *  定位数据
     */
//    LocationInfo * locationInfo;
    
    ///描述
    NSString * msh;
    
}
/**
 *  房子图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_Pic;
/**
 *  上传图片数量提示
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_PicHint;
/**
 *  没有图片时的上传按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_NoUpPics;
/**
 *  有上传图片时，上传按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_UpPics;
/**
 *  选择区域
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_District;
/**
 *  输入小区控件
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Community;
/**
 *  具体地址录入
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Addrs;
/**
 *  室
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Room;
/**
 *  厅
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Hall;
/**
 *  卫
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Toilet;
/**
 *  面积
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Area;
/**
 *  楼层
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_FloorNum;
/**
 *  总楼层
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_TotalNum;
/**
 *  金额单位
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_AmountUnit;
/**
 *  金额
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Amount;
/**
 *  出售信息部分的视图高度，用于隐出租时隐藏这部分信息
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NSLay_SaleHeight;
/**
 *  出售部分视图，用于隐出租时隐藏这部分信息
 */
@property (weak, nonatomic) IBOutlet UIView *view_SaleView;
/**
 *  装修
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Decoration;
/**
 *  朝向
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Aspect;
/**
 *  商品类型
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Types;
/**
 *  建筑年代
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Builded;
/**
 *  产权 默认70年
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_PropertyRights;
/**
 *  产证是否在手
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_IsHold;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Title;
/**
 *  描述
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Describe;

/**
 *  联系人
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Contact;
/**
 *  手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_PhoneNum;

/**
 *  滚动视图
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/**
 *  内容高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NSLay_ContentViewHeight;




@end

@implementation ReleaseHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
    [self getDistrictData];
 
    [self getLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(imgArray.count>0)
    {
        self.btn_UpPics.hidden=NO;
        self.btn_NoUpPics.hidden=YES;
        self.lab_PicHint.hidden=NO;
        self.lab_PicHint.text=[NSString stringWithFormat:@"您已上传%ld张图片",(unsigned long)imgArray.count];
        UpImageModel * upimg=[imgArray objectAtIndex:0];
        if(![XYString isBlankString:upimg.imgUrl])
        {
            [self.img_Pic sd_setImageWithURL:[NSURL URLWithString:upimg.imgUrl] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
        }
        else
        {
            self.img_Pic.image=upimg.img;
        }
        
    }
    else
    {
        self.btn_UpPics.hidden=YES;
        self.btn_NoUpPics.hidden=NO;
        self.lab_PicHint.hidden=YES;
    }
   
}

#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView {
    
    appDlt=GetAppDelegates;
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    
    
    self.NSLay_ContentViewHeight.constant+=100;
    imgArray=[NSMutableArray new];
    arrayDistrict=[NSMutableArray new];
    msh=@"";
    self.TF_Addrs.enabled=NO;
    isinhand=-1;
    housetype=-1;
    decorattype=-1;
    facetype=-1;
    
    [self.btn_Decoration setTitle:@"简单装修" forState:UIControlStateNormal];
    decorattype=2;
    [self.btn_Aspect setTitle:@"南北通透" forState:UIControlStateNormal];
    facetype=1;
    [self.btn_Types setTitle:@"普通住宅" forState:UIControlStateNormal];
    housetype=1;
    if(self.jmpCode==0)
    {
        self.view_SaleView.hidden=YES;
        self.NSLay_ContentViewHeight.constant=self.NSLay_ContentViewHeight.constant-self.NSLay_SaleHeight.constant;
        self.NSLay_SaleHeight.constant=0;
        self.lab_AmountUnit.text=@"元/月";
        [self.btn_Describe setTitle:@"交通配置等，至少10字" forState:UIControlStateNormal];
        propertyyear=@"";

        buildyear=@"";
        
    }
    else if (self.jmpCode == 1) {
        self.lab_AmountUnit.text=@"万元";
        [self.btn_Builded setTitle:[NSString stringWithFormat:@"%ld",(long)[DateUitls getYearForDate:[NSDate date]]] forState:UIControlStateNormal];
        buildyear=[NSString stringWithFormat:@"%ld",(long)[DateUitls getYearForDate:[NSDate date]]];
        [self.btn_PropertyRights setTitle:@"70年产权" forState:UIControlStateNormal];
        propertyyear=@"70";
        [self.btn_IsHold setTitle:@"是" forState:UIControlStateNormal];
        isinhand=1;
       [self.btn_Describe setTitle:@"小区环境等，至少10字" forState:UIControlStateNormal];
    }
    
    [self.btn_District setTitle:appDlt.userData.countyname forState:UIControlStateNormal];
    districtID=appDlt.userData.countyid;
    self.TF_PhoneNum.text=appDlt.userData.phone;
    self.TF_Community.text=appDlt.userData.communityname;
    
    self.TF_Addrs.text=appDlt.userData.communityaddress;
    location.latitude=[appDlt.userData.lat doubleValue];
    location.longitude=[appDlt.userData.lng doubleValue];
    
    
    ///修改数据赋值
    if(self.changeCdoe==1)
    {
        location.latitude=[self.room.mapy doubleValue];
        location.longitude=[self.room.mapx doubleValue];
        if(self.room.piclist.count > 0)
        {
            UpImageModel * upImg;
            for(int i=0;i<self.room.piclist.count;i++)
            {
                UserReservePic * urp=[self.room.piclist objectAtIndex:i];
                upImg=[UpImageModel new];
                upImg.picID=urp.theID;
                upImg.imgUrl=urp.fileurl;
                upImg.isUpLoad=1;
                [imgArray addObject:upImg];
            }
        }
        [self.btn_District setTitle:self.room.countyname forState:UIControlStateNormal];
        districtID=self.room.countyid;
        
        self.TF_Community.text=([XYString isBlankString:self.room.communityname]?@"":self.room.communityname);
        self.TF_Addrs.text=([XYString isBlankString:self.room.address]?@"":self.room.address);
        self.TF_Room.text=([self.room.bedroom isEqualToString:@"-1"]?@"":self.room.bedroom);
        self.TF_Hall.text=([self.room.livingroom isEqualToString:@"-1"]?@"":self.room.livingroom);
        self.TF_Toilet.text=([self.room.toilef isEqualToString:@"-1"]?@"":self.room.toilef);
        self.TF_Area.text=([self.room.area isEqualToString:@"-1"]?@"":self.room.area);
        self.TF_FloorNum.text=([self.room.floornum isEqualToString:@"-1"]?@"":self.room.floornum);
        self.TF_TotalNum.text=([self.room.allfloornum isEqualToString:@"-1"]?@"":self.room.allfloornum);
        self.TF_Amount.text=(self.room.money.intValue ==-1?@"":[self.room.money stringByReplacingOccurrencesOfString:@".0" withString:@""]);
        self.TF_Title.text=([XYString isBlankString:self.room.title]?@"":self.room.title);
        msh=([XYString isBlankString:self.room.descriptionString]?@"":self.room.descriptionString);
        
        if(msh==nil ||msh.length==0)
        {
            if(_jmpCode==0)
            {
                [self.btn_Describe setTitle:@"交通配置等，至少10字" forState:UIControlStateNormal];
            }
            else
            {
                [self.btn_Describe setTitle:@"小区环境等，至少10字" forState:UIControlStateNormal];
            }
        }
        else
        {
            [self.btn_Describe setTitle:self.room.descriptionString forState:UIControlStateNormal];
        }
        

        
        
        self.TF_Contact.text=([XYString isBlankString:self.room.linkman]?@"":self.room.linkman);
        self.TF_PhoneNum.text=([XYString isBlankString:self.room.linkphone]?@"":self.room.linkphone);
        NSArray * array;
        NSInteger index=0;
        //1 毛坯 2 简装 3 中等装修 4 精装 5 豪装 毛坯、简单装修、中等装修、精装修、豪华装修
        if(![XYString isBlankString:self.room.decorattype])
        {
            decorattype=[self.room.decorattype integerValue];
            NSArray * array=@[@"毛坯",@"简单装修",@"中等装修",@"精装修",@"豪华装修"];
            NSInteger index=0;
            if(decorattype-1>0)
            {
                index=decorattype-1;
            }
            
            [self.btn_Decoration setTitle:[array objectAtIndex:index] forState:UIControlStateNormal];
        }
        if(![XYString isBlankString:self.room.facetype])
        {
            facetype=[self.room.facetype integerValue];
            array=@[@"南北通透",@"东西向",@"朝南",@"朝北",@"朝东",@"朝西"];
            index=0;
            if(facetype-1>0)
            {
                index=facetype-1;
            }
            [self.btn_Aspect setTitle:[array objectAtIndex:index] forState:UIControlStateNormal];
        }
        if(![XYString isBlankString:self.room.housetype])
        {
            housetype=[self.room.housetype integerValue];
            array=@[@"普通住宅",@"经济适用房",@"公寓",@"商住楼",@"酒店式公寓"];
            index=0;
            if(housetype-1>0)
            {
                index=housetype-1;
            }
            
            [self.btn_Types setTitle:[array objectAtIndex:index] forState:UIControlStateNormal];
        }
        if(self.jmpCode==1)
        {

            if(![XYString isBlankString:self.room.buildyear])
            {
                buildyear=self.room.buildyear;
                
                [self.btn_Builded setTitle:buildyear forState:UIControlStateNormal];
            }
            if(![XYString isBlankString:self.room.propertyyear])
            {
                propertyyear=self.room.propertyyear;
                [self.btn_PropertyRights setTitle:[NSString stringWithFormat:@"%@年产权",self.room.propertyyear] forState:UIControlStateNormal];
            }
            if(![XYString isBlankString:self.room.isinhand])
            {
                isinhand=[self.room.isinhand integerValue];
                array=@[@"否",@"是"];
                [self.btn_IsHold setTitle:[array objectAtIndex:isinhand] forState:UIControlStateNormal];
            }
        
        }
        
    }

    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",location.longitude] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",location.latitude] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",_TF_Addrs.text] forKey:@"address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    LocationInfo *locationInfo = [[LocationInfo alloc] init];
//    locationInfo.longitude  = location.longitude;
//    locationInfo.latitude = location.latitude;
//    locationInfo.addres = _TF_Addrs.text;
//    [UserDefaultsStorage saveData:locationInfo forKey:@"LocationInfo"];
    
}

#pragma mark ----------事件处理--------------

////没有图片时点击上传图片事件
- (IBAction)btn_NoUpPicsEvent:(UIButton *)sender {
    PhotoWallVC * photoVC=[[PhotoWallVC alloc] initWithNibName:@"PhotoWallVC" bundle:nil];
    photoVC.imgArray=imgArray;
    photoVC.selectImgMaxNum=8;
    photoVC.title=@"上传照片";
    [self.navigationController pushViewController:photoVC animated:YES];
}
///有图片时上传图片
- (IBAction)btn_UPPicsEvent:(UIButton *)sender {
    PhotoWallVC * photoVC=[[PhotoWallVC alloc] initWithNibName:@"PhotoWallVC" bundle:nil];
    photoVC.selectImgMaxNum=8;
    photoVC.title=@"上传照片";
    photoVC.imgArray=imgArray;
    [self.navigationController pushViewController:photoVC animated:YES];
}
///选择区域事件
- (IBAction)btn_DistrictEvent:(UIButton *)sender {
    if(arrayDistrict==nil)
    {
        return;
    }
    LifeSelectListVC * selectListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeSelectListVC"];
    selectListVC.listData=arrayDistrict;
    NSInteger selectRow=-1;
    NSDictionary * dic;
    for(int i=0;i<arrayDistrict.count;i++)
    {
        dic=[arrayDistrict objectAtIndex:i];
        if([[dic objectForKey:@"id"] integerValue]==[districtID integerValue])
        {
            selectRow=i;
            break;
        }
        
    }
    selectListVC.indexSelected=selectRow;
    selectListVC.title=@"选择区域";
    //列表视图
    selectListVC.cellViewBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        UITableViewCell *cell=(UITableViewCell *)view;
        NSDictionary *dic=(NSDictionary *)data;
        cell.textLabel.text=[dic objectForKey:@"name"];
    };
    //事件
    selectListVC.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        NSDictionary *dic=(NSDictionary *)data;
        [self.btn_District setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        districtID=[dic objectForKey:@"id"];
    };
    [self.navigationController pushViewController:selectListVC animated:YES];
     
}
///小区输入变化事件
- (IBAction)TFCommunityChangeEvent:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>10)
        {
            sender.text=[sender.text substringToIndex:10];
        }
    }
}
///地址输入变化
- (IBAction)TFAddressChange:(UITextField *)sender {
    
}
///选择地址事件，进地图选择位置
- (IBAction)btn_GoMap:(UIButton *)sender {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"BDMapViews" bundle:nil];
    GetAddressMapVC * showMap = [secondStoryBoard instantiateViewControllerWithIdentifier:@"GetAddressMapVC"];
    showMap.delegate=self;
    [self.navigationController pushViewController:showMap animated:YES];
}
///输入室
- (IBAction)TFRoomChangeEvent:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>1)
        {
            sender.text=[sender.text substringToIndex:1];
        }
    }
}
///输入厅
- (IBAction)TFHall_ChangeEvent:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>1)
        {
            sender.text=[sender.text substringToIndex:1];
        }
    }
}
///输入卫
- (IBAction)TFToiletChangeEvent:(UITextField *)sender {

    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>1)
        {
            sender.text=[sender.text substringToIndex:1];
        }
    }

}
///面积
- (IBAction)TFAreaChangeEvent:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>6)
        {
            sender.text=[sender.text substringToIndex:6];
        }
    }
}
///输入楼层
- (IBAction)TFFloorNumChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>2)
        {
            sender.text=[sender.text substringToIndex:2];
        }
    }
}
///输入总楼层
- (IBAction)TFTotalNumChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>2)
        {
            sender.text=[sender.text substringToIndex:2];
        }
    }

}
///输入金额
- (IBAction)TFAmountChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>15)
        {
            sender.text=[sender.text substringToIndex:15];
        }
    }
}
/**装修选择 毛坯、简单装修、中等装修、精装修、豪华装修，默认简单装修
装修类型：1 毛坯 2 简装 3 中等装修 4 精装 5 豪装
 */
- (IBAction)btn_DecorationEvent:(UIButton *)sender {
    NSArray * array=@[@"毛坯",@"简单装修",@"中等装修",@"精装修",@"豪华装修"];
    LifeSelectListVC * selectListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeSelectListVC"];

    if(!selectListVC.listData)
    {
        selectListVC.listData=[NSMutableArray new];
    }
    [selectListVC.listData addObjectsFromArray:array];

    selectListVC.indexSelected=decorattype-1;
    selectListVC.title=@"选择装修";
    //列表视图
    selectListVC.cellViewBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        UITableViewCell *cell=(UITableViewCell *)view;
        NSString *dic=(NSString *)data;
        cell.textLabel.text=dic;
    };
    //事件
    selectListVC.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        NSString *dic=(NSString *)data;
        [self.btn_Decoration setTitle:dic forState:UIControlStateNormal];
        decorattype=index.row+1;
    };
    [self.navigationController pushViewController:selectListVC animated:YES];
}
/**朝向选择
 南北通透、东西向、朝南、朝北、朝东、朝西，默认南北通透
 */
- (IBAction)btn_AspectEvent:(UIButton *)sender {
    NSArray * array=@[@"南北通透",@"东西向",@"朝南",@"朝北",@"朝东",@"朝西"];
    LifeSelectListVC * selectListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeSelectListVC"];
    if(!selectListVC.listData)
    {
        selectListVC.listData=[NSMutableArray new];
    }
    [selectListVC.listData addObjectsFromArray:array];
    
    selectListVC.indexSelected=facetype-1;
    selectListVC.title=@"选择朝向";
    //列表视图
    selectListVC.cellViewBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        UITableViewCell *cell=(UITableViewCell *)view;
        NSString *dic=(NSString *)data;
        cell.textLabel.text=dic;
    };
    //事件
    selectListVC.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        NSString *dic=(NSString *)data;
        [self.btn_Aspect setTitle:dic forState:UIControlStateNormal];
        facetype=index.row+1;
    };
    [self.navigationController pushViewController:selectListVC animated:YES];
}
/**房产类型选择
 普通住宅、经济适用房、公寓、商住楼、酒店式公寓，默认普通住宅
 1普通住宅2经济适用房3公寓4商住楼5酒店式公寓
 */
- (IBAction)btn_Types:(UIButton *)sender {
    NSArray * array=@[@"普通住宅",@"经济适用房",@"公寓",@"商住楼",@"酒店式公寓"];
    LifeSelectListVC * selectListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeSelectListVC"];
    if(!selectListVC.listData)
    {
        selectListVC.listData=[NSMutableArray new];
    }
    [selectListVC.listData addObjectsFromArray:array];
    
    selectListVC.indexSelected=housetype-1;
    selectListVC.title=@"选择房产类型";
    //列表视图
    selectListVC.cellViewBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        UITableViewCell *cell=(UITableViewCell *)view;
        NSString *dic=(NSString *)data;
        cell.textLabel.text=dic;
    };
    //事件
    selectListVC.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        NSString *dic=(NSString *)data;
        [self.btn_Types setTitle:dic forState:UIControlStateNormal];
        housetype=index.row+1;
    };
    [self.navigationController pushViewController:selectListVC animated:YES];
}
///建筑年代选择
- (IBAction)btn_BuildedEvent:(UIButton *)sender {
    NSInteger year=[DateUitls getYearForDate:[NSDate date]];
    NSMutableArray * array=[NSMutableArray new];
    for(NSInteger i=0;i<30;i++)
    {
        [array addObject:[NSString stringWithFormat:@"%ld",(year-i)]];
    }
    LifeSelectListVC * selectListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeSelectListVC"];
    selectListVC.listData=array;
    if(!selectListVC.listData)
    {
        selectListVC.listData=[NSMutableArray new];
        [selectListVC.listData addObjectsFromArray:array];
    }
    NSInteger select=-1;
    for(int i=0;i<array.count;i++)
    {
        if([[array objectAtIndex:i] isEqualToString:buildyear])
        {
            select=i;
            break;
        }
    }
    selectListVC.indexSelected=select;
    selectListVC.title=@"选择建筑年代";
    //列表视图
    selectListVC.cellViewBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        UITableViewCell *cell=(UITableViewCell *)view;
        NSString *dic=(NSString *)data;
        cell.textLabel.text=dic;
    };
    //事件
    selectListVC.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        NSString *dic=(NSString *)data;
        [self.btn_Builded setTitle:dic forState:UIControlStateNormal];
        buildyear=dic;
    };
    [self.navigationController pushViewController:selectListVC animated:YES];
}
/**产权选择
 70年产权、50年产品、40年产权，默认70年产权
 */
- (IBAction)btn_PropertyEvent:(UIButton *)sender {
    NSArray * array=@[@"70年产权",@"50年产权",@"40年产权"];
    LifeSelectListVC * selectListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeSelectListVC"];
    if(!selectListVC.listData)
    {
        selectListVC.listData=[NSMutableArray new];
    }
    [selectListVC.listData addObjectsFromArray:array];
    NSInteger select=-1;
    for(int i=0;i<array.count;i++)
    {
        if([[array objectAtIndex:i] hasPrefix:propertyyear])
        {
            select=i;
            break;
        }
    }
    selectListVC.indexSelected=select;
    selectListVC.title=@"选择产权";

    //列表视图
    selectListVC.cellViewBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        UITableViewCell *cell=(UITableViewCell *)view;
        NSString *dic=(NSString *)data;
        cell.textLabel.text=dic;
        
    };
    //事件
    selectListVC.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        NSString *dic=(NSString *)data;
        [self.btn_PropertyRights setTitle:dic forState:UIControlStateNormal];
//        propertyyear=dic;
        if(index.row==0)
        {
            propertyyear=@"70";
        }
        else if (index.row==1)
        {
            propertyyear=@"50";
        }
        else if (index.row==2)
        {
            propertyyear=@"40";
        }
    };
    [self.navigationController pushViewController:selectListVC animated:YES];
}
///产证是否在手选择 产证是否在手 1 是 0 否
- (IBAction)btn_ISHoldEvent:(UIButton *)sender {
    NSArray * array=@[@"否",@"是"];
    LifeSelectListVC * selectListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeSelectListVC"];
    if(!selectListVC.listData)
    {
        selectListVC.listData=[NSMutableArray new];
    }
    [selectListVC.listData addObjectsFromArray:array];
    
    selectListVC.indexSelected=isinhand;
    selectListVC.title=@"产证是否在手";
    //列表视图
    selectListVC.cellViewBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        UITableViewCell *cell=(UITableViewCell *)view;
        NSString *dic=(NSString *)data;
        cell.textLabel.text=dic;
    };
    //事件
    selectListVC.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        NSString *dic=(NSString *)data;
        [self.btn_IsHold setTitle:dic forState:UIControlStateNormal];
        isinhand=index.row;
    };
    [self.navigationController pushViewController:selectListVC animated:YES];
    
}
///输入标题
- (IBAction)TFTitleChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>20)
        {
            sender.text=[sender.text substringToIndex:20];
        }
    }

}
///进入描述编辑
- (IBAction)btn_DescribeEvent:(UIButton *)sender {
    
    LifeEditVC * editVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeEditVC"];
    editVC.content=self.btn_Describe.titleLabel.text;
    editVC.minLenght=10;
    editVC.maxLenght=500;
    editVC.jmpCode=self.jmpCode;
    
    if(_jmpCode==0)
    {
        editVC.tishi=@"交通配置等，至少10字";
    }
    else
    {
       editVC.tishi=@"小区环境等，至少10字";
    }
   
    editVC.viewBlock=^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        if([self.btn_Describe.titleLabel.text isEqualToString:(NSString *)data])
        {
            return ;
        }
        msh=(NSString*)data;
        [self.btn_Describe setTitle:(NSString *)data forState:UIControlStateNormal];
        
    };
    [self.navigationController pushViewController:editVC animated:YES];
}
///输入联系人名称
- (IBAction)TFContactChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>4)
        {
            sender.text=[sender.text substringToIndex:4];
        }
    }

}
///输入手机号
- (IBAction)TFPhoneNumChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>11)
        {
            sender.text=[sender.text substringToIndex:11];
        }
    }

}

/**
 *  保存事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_SaveEvent:(UIButton *)sender {
    if(self.changeCdoe==1)
    {
        [self sumbitChangeForFlag:@"1"];
        return;
    }
    [self sumbitDataForFlag:@"1"];
}
/**
 *  发布事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_ReleaseHouse:(UIButton *)sender {
    if(self.changeCdoe==1)
    {
        [self sumbitChangeForFlag:@"0"];
        return;
    }
    [self sumbitDataForFlag:@"0"];
    
}
#pragma mark -----------地图获取地址回调--------
-(void)goBackAddr:(NSString *)addr location:(CLLocationCoordinate2D) loc
{
    location=loc;
    self.TF_Addrs.text=addr;

    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",location.longitude] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",location.latitude] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",self.TF_Addrs.text] forKey:@"address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    LocationInfo *locationInfo = [[LocationInfo alloc] init];
//    locationInfo.latitude = location.latitude;
//    locationInfo.longitude = location.longitude;
//    locationInfo.addres = _TF_Addrs.text;
//    [UserDefaultsStorage saveData:locationInfo forKey:@"LocationInfo"];
    
}
#pragma mark ---------网络--------

/**
 token	用户令牌
 sertype	信息类型：0 出租 1 买卖 2 求租 3 求购
 countyid	区域id
 communityname	社区名称
 mapx	坐标X
 mapy	坐标Y
 address	地址
 title	标题
 description	描述
 area	面积
 floornum	楼层
 allfloornum	总楼层数
 bedroom	卧室数
 livingroom	客厅数
 toilef	卫数
 decorattype	装修类型：1 毛坯 2 简装 3 中等装修 4 精装 5 豪装
 buildyear	建造年份
 facetype	房间朝向：1 南北通透 2 东西通透 3 东向 4 西向 5 南向 6 北向 7 东北向 8 东南向 9 西北向 10 西南向
 housetype	房间类型：1普通住宅2经济适用房3公寓4商住楼5酒店式公寓
 propertyyear	产权年份
 isinhand	产证是否在手 1 是 0 否
 money	金额
 linkman	联系人
 linkphone	联系电话
 flag	0 已发布 1 已保存
 picids	上传成功后资源文件ids
 */
-(void)sumbitDataForFlag:(NSString *)flag
{
    if([flag isEqualToString:@"0"])
    {
        
        if(self.TF_Community.text.length==0)
        {
            [self showToastMsg:@"您还没有填写小区名称" Duration:5.0];
            return;
        }
        
        if(self.TF_Addrs.text.length==0)
        {
            [self showToastMsg:@"您还没有填写地址" Duration:5.0];
            return;
        }
        if(self.TF_Room.text.length==0)
        {
            [self showToastMsg:@"您还没有填写室" Duration:5.0];
            return;
        }
//        if(self.TF_Hall.text.length==0)
//        {
//            [self showToastMsg:@"您还没有填写厅" Duration:5.0];
//            return;
//        }
//        if(self.TF_Toilet.text.length==0)
//        {
//            [self showToastMsg:@"您还没有填写卫" Duration:5.0];
//            return;
//        }
        if(self.TF_Area.text.length==0)
        {
            [self showToastMsg:@"您还没有填写面积" Duration:5.0];
            return;
        }
        if(self.TF_FloorNum.text.length==0)
        {
            [self showToastMsg:@"您还没有填写楼层" Duration:5.0];
            return;
        }
        if(self.TF_TotalNum.text.length==0)
        {
            [self showToastMsg:@"您还没有填写总楼层" Duration:5.0];
            return;
        }
        if(self.TF_Amount.text.length==0)
        {
            [self showToastMsg:@"您还没有填写金额" Duration:5.0];
            return;
        }
        if(self.TF_Title.text.length==0)
        {
            [self showToastMsg:@"您还没有填写标题" Duration:5.0];
            return;
        }
        if(self.TF_Contact.text.length==0)
        {
            [self showToastMsg:@"您还没有填写联系人" Duration:5.0];
            return;
        }
        if(self.TF_PhoneNum.text.length==0)
        {
            [self showToastMsg:@"您还没有填写手机号" Duration:5.0];
            return;
        }
        
        
        
        if(self.TF_Community.text.length<1)
        {
            [self showToastMsg:@"小区名称不能少于1个字" Duration:5.0];
            return;
        }
        if([self.TF_Room.text hasPrefix:@"0"])
        {
            [self showToastMsg:@"室不能为0" Duration:5.0];
            return;
        }
//        if([self.TF_Hall.text hasPrefix:@"0"])
//        {
//            [self showToastMsg:@"厅不能为0" Duration:5.0];
//            return;
//        }
//        if([self.TF_Toilet.text hasPrefix:@"0"])
//        {
//            [self showToastMsg:@"卫不能为0" Duration:5.0];
//            return;
//        }
        if([self.TF_Area.text hasPrefix:@"0"])
        {
            [self showToastMsg:@"面积不能为0" Duration:5.0];
            return;
        }
        if([self.TF_FloorNum.text hasPrefix:@"0"])
        {
            [self showToastMsg:@"楼层数不能为0" Duration:5.0];
            return;
        }
        if([self.TF_TotalNum.text hasPrefix:@"0"])
        {
            [self showToastMsg:@"总楼层数不能为0" Duration:5.0];
            return;
        }
        if([self.TF_FloorNum.text integerValue]>[self.TF_TotalNum.text integerValue])
        {
            [self showToastMsg:@"楼层数不能大于总楼层数" Duration:5.0];
            return;
        }
        if([self.TF_Amount.text hasPrefix:@"0"])
        {
            [self showToastMsg:@"金额不能为0" Duration:5.0];
            return;
        }
        if(self.TF_Title.text.length<4)
        {
            [self showToastMsg:@"标题不能少于4个字" Duration:5.0];
            return;
        }
        if(self.TF_Contact.text.length<2)
        {
            [self showToastMsg:@"联系人不能少于2个字" Duration:5.0];
            return;
        }
        
        if(![RegularUtils isPhoneNum:self.TF_PhoneNum.text])
        {
            [self showToastMsg:@"手机号格式错误" Duration:5.0];
            return;
        }

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
    NSDictionary * dic=@{@"sertype":[NSString stringWithFormat:@"%d",self.jmpCode],
                         @"countyid":districtID,
                         @"communityname":self.TF_Community.text,
                         @"mapx":[NSString stringWithFormat:@"%lf",location.longitude],
                         @"mapy":[NSString stringWithFormat:@"%lf",location.latitude],
                         @"address":self.TF_Addrs.text,
                         @"title":self.TF_Title.text,
                         @"description":msh,
                         @"area":self.TF_Area.text,
                         @"floornum":self.TF_FloorNum.text,
                         @"allfloornum":self.TF_TotalNum.text,
                         @"bedroom":self.TF_Room.text,
                         @"livingroom":self.TF_Hall.text,
                         @"toilef":self.TF_Toilet.text,
                         @"decorattype":[NSString stringWithFormat:@"%ld",(long)decorattype],
                         @"buildyear":buildyear,
                         @"facetype":[NSString stringWithFormat:@"%ld",(long)facetype],
                         @"housetype":[NSString stringWithFormat:@"%ld",(long)housetype],
                         @"propertyyear":propertyyear,
                         @"isinhand":[NSString stringWithFormat:@"%ld",(long)isinhand],
                         @"money":self.TF_Amount.text,
                         @"linkman":self.TF_Contact.text,
                         @"linkphone":self.TF_PhoneNum.text,
                         @"flag":flag,
                         @"picids":picIDs};
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    [BMRoomPresenter addResidence:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                [self showToastMsg:@"提交成功" Duration:5.0];
                if(self.changeCdoe==1)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    if([flag isEqualToString:@"0"])//发布
                    {
                        HouseTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"HouseTableVC"];
                        htVc.jmpCode=self.jmpCode;
                        htVc.isFromeRelease=YES;
                        htVc.title=self.jmpCode==0?@"出租":@"出售";
                        [self.navigationController pushViewController:htVc animated:YES];
                        
                    }
                    else//保存
                    {
                        //我发布的房源
//                        THMyPublishHouseListViewController *houseVC = [[THMyPublishHouseListViewController alloc]init];
//                        houseVC.isFromeRelease=YES;
//                        houseVC.publishType = 0;
//                        [self.navigationController pushViewController:houseVC animated:YES];
                    }
                }
            }
            else
            {
                [self showToastMsg:data Duration:5.0];
                
            }
            
        });
        
    } withInfo:dic];
}
/**
 id	记录id
 countyid	区域id
 communityname	社区名称
 mapx	坐标X
 mapy	坐标Y
 address	地址
 title	标题
 description	描述
 area	面积
 floornum	楼层
 allfloornum	总楼层数
 bedroom	卧室数
 livingroom	客厅数
 toilef	卫数
 decorattype	装修类型：1 毛坯 2 简装 3 中等装修 4 精装 5 豪装
 buildyear	建造年份
 facetype	房间朝向：1 南北通透 2 东西通透 3 东向 4 西向 5 南向 6 北向 7 东北向 8 东南向 9 西北向 10 西南向
 housetype	房间类型：1普通住宅2经济适用房3公寓4商住楼5酒店式公寓
 propertyyear	产权年份
 isinhand	产证是否在手 1 是 0 否
 money	金额
 linkman	联系人
 linkphone	联系电话
 flag	0 已发布 1 已保存
 picids	上传成功后资源文件ids
 */
-(void)sumbitChangeForFlag:(NSString *)flag
{
        
    if([flag isEqualToString:@"0"])
    {
        
        if(self.TF_Community.text.length==0)
        {
            [self showToastMsg:@"您还没有填写小区名称" Duration:5.0];
            return;
        }
        
        if(self.TF_Addrs.text.length==0)
        {
            [self showToastMsg:@"您还没有填写地址" Duration:5.0];
            return;
        }
        if(self.TF_Room.text.length==0)
        {
            [self showToastMsg:@"您还没有填写室" Duration:5.0];
            return;
        }
//        if(self.TF_Hall.text.length==0)
//        {
//            [self showToastMsg:@"您还没有填写厅" Duration:5.0];
//            return;
//        }
//        if(self.TF_Toilet.text.length==0)
//        {
//            [self showToastMsg:@"您还没有填写卫" Duration:5.0];
//            return;
//        }
        if(self.TF_Area.text.length==0)
        {
            [self showToastMsg:@"您还没有填写面积" Duration:5.0];
            return;
        }
        if(self.TF_FloorNum.text.length==0)
        {
            [self showToastMsg:@"您还没有填写楼层" Duration:5.0];
            return;
        }
        if(self.TF_TotalNum.text.length==0)
        {
            [self showToastMsg:@"您还没有填写总楼层" Duration:5.0];
            return;
        }
        if(self.TF_Amount.text.length==0)
        {
            [self showToastMsg:@"您还没有填写金额" Duration:5.0];
            return;
        }
        if(self.TF_Title.text.length==0)
        {
            [self showToastMsg:@"您还没有填写标题" Duration:5.0];
            return;
        }
        if(self.TF_PhoneNum.text.length==0)
        {
            [self showToastMsg:@"您还没有填写手机号" Duration:5.0];
            return;
        }
        
        
        
        if(self.TF_Community.text.length<1)
        {
            [self showToastMsg:@"小区名称不能少于1个字" Duration:5.0];
            return;
        }
        if([self.TF_Room.text hasPrefix:@"0"])
        {
            [self showToastMsg:@"室不能为0" Duration:5.0];
            return;
        }
//        if([self.TF_Hall.text hasPrefix:@"0"])
//        {
//            [self showToastMsg:@"厅不能为0" Duration:5.0];
//            return;
//        }
//        if([self.TF_Toilet.text hasPrefix:@"0"])
//        {
//            [self showToastMsg:@"卫不能为0" Duration:5.0];
//            return;
//        }
        if([self.TF_Area.text hasPrefix:@"0"])
        {
            [self showToastMsg:@"面积不能为0" Duration:5.0];
            return;
        }
        if([self.TF_FloorNum.text hasPrefix:@"0"])
        {
            [self showToastMsg:@"楼层数不能为0" Duration:5.0];
            return;
        }
        if([self.TF_TotalNum.text hasPrefix:@"0"])
        {
            [self showToastMsg:@"总楼层数不能为0" Duration:5.0];
            return;
        }
        if([self.TF_FloorNum.text integerValue]>[self.TF_TotalNum.text integerValue])
        {
            [self showToastMsg:@"楼层数不能大于总楼层数" Duration:5.0];
            return;
        }
        if([self.TF_Amount.text hasPrefix:@"0"])
        {
            [self showToastMsg:@"金额不能为0" Duration:5.0];
            return;
        }
        if(self.TF_Title.text.length<4)
        {
            [self showToastMsg:@"标题不能少于4个字" Duration:5.0];
            return;
        }
        
        if(![RegularUtils isPhoneNum:self.TF_PhoneNum.text])
        {
            [self showToastMsg:@"手机号格式错误" Duration:5.0];
            return;
        }
        
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
    NSDictionary * dic=@{@"id":self.room.theID,
                         @"countyid":districtID,
                         @"communityname":self.TF_Community.text,
                         @"mapx":[NSString stringWithFormat:@"%lf",location.longitude],
                         @"mapy":[NSString stringWithFormat:@"%lf",location.latitude],
                         @"address":self.TF_Addrs.text,
                         @"title":self.TF_Title.text,
                         @"description":msh,
                         @"area":self.TF_Area.text,
                         @"floornum":self.TF_FloorNum.text,
                         @"allfloornum":self.TF_TotalNum.text,
                         @"bedroom":self.TF_Room.text,
                         @"livingroom":self.TF_Hall.text,
                         @"toilef":self.TF_Toilet.text,
                         @"decorattype":[NSString stringWithFormat:@"%ld",(long)decorattype],
                         @"buildyear":buildyear,
                         @"facetype":[NSString stringWithFormat:@"%ld",(long)facetype],
                         @"housetype":[NSString stringWithFormat:@"%ld",(long)housetype],
                         @"propertyyear":propertyyear,
                         @"isinhand":[NSString stringWithFormat:@"%ld",(long)isinhand],
                         @"money":self.TF_Amount.text,
                         @"linkman":self.TF_Contact.text,
                         @"linkphone":self.TF_PhoneNum.text,
                         @"flag":flag,
                         @"picids":picIDs};
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    
    [BMRoomPresenter changeResidence:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                [self showToastMsg:@"修改成功" Duration:5.0];
                if(self.changeCdoe==1)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    if([flag isEqualToString:@"0"])//发布
                    {
                        HouseTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"HouseTableVC"];
                        htVc.jmpCode=self.jmpCode;
                        htVc.isFromeRelease=YES;
                        htVc.title=self.jmpCode==0?@"出租":@"出售";
                        [self.navigationController pushViewController:htVc animated:YES];
                        
                    }
                    else//保存
                    {
                        //我发布的房源
//                        THMyPublishHouseListViewController *houseVC = [[THMyPublishHouseListViewController alloc]init];
//                        houseVC.isFromeRelease=YES;
//                        houseVC.publishType = 0;
//                        [self.navigationController pushViewController:houseVC animated:YES];
                    }

                }
            }
            else
            {
                [self showToastMsg:data Duration:5.0];
                
            }
            
        });
        
    } withInfo:dic];
}



///获取城市区域
-(void)getDistrictData
{
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BMCityPresenter getCityCounty:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                NSArray * array=(NSArray *)data;
                [arrayDistrict removeAllObjects];
                [arrayDistrict addObjectsFromArray:array];
            }
            else
            {
                [self showToastMsg:data Duration:5.0];
                
            }
        });
    } withCityID:appDlt.userData.cityid];
}
/**
 *  定位
 */
- (void)getLocation {
    
    @WeakObj(self);
    if(bdmap==nil)
    {
        bdmap=[BDMapFWPresenter new];
    }
    
    

    [bdmap getLocationInfoForupDateViewsBlock:^(id  _Nullable data, ResultCode resultCode) {
        [bdmap stopLocation];
        
        if (resultCode==SucceedCode) {

            LocationInfo *locationInfo = (LocationInfo *)data;

            if(appDlt.userData.cityid.intValue == 0) {
                
                [AppSystemSetPresenters getCityIDName:locationInfo.cityName UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if(resultCode==SucceedCode)
                        {
                            appDlt.userData.cityid = data;
                            [appDlt saveContext];
                            
                        }else{
                            
                            [selfWeak showToastMsg:data Duration:5.0];
                        }
                        
                    });
                    
                }];
            }
            
        }
        

    }];
    
}


@end
