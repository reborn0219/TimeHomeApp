//
//  ReleaseUsedMarketVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ReleaseUsedMarketVC.h"
#import "UpImageModel.h"
#import "BMCityPresenter.h"
#import "PhotoWallVC.h"
#import "LifeSelectListVC.h"
#import "GetAddressMapVC.h"
#import "LifeEditVC.h"
#import "BMReplacePresenter.h"
#import "RegularUtils.h"
#import "UserReservePic.h"
#import "HouseTableVC.h"
#import "BDMapFWPresenter.h"

#import "AppSystemSetPresenters.h"

@interface ReleaseUsedMarketVC ()<MapAdrrBackDelegate>
{
    
    ///上传图片数据
    NSMutableArray * imgArray;
    ///位置
    CLLocationCoordinate2D location;
    AppDelegate * appDlt;
    ///城市区域
    NSMutableArray * arrayDistrict;
    ///物品类型
    NSMutableArray * arrayType;
    ///选择的区ID
    NSString * districtID;
    ///选择的类型id
    NSString * typeID;
    ///新旧程度
    NSString * newOld;
    ///描述
    NSString * msh;
    
//    LocationInfo *locationInfo;
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
 *  标题
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Title;
/**
 *  描述
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Describe;


/**
 *  物业类别
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Type;
/**
 *  新旧
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_newOld;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UITextField *btn_Price;


/**
 *  联系人
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Contact;
/**
 *  手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_PhoneNum;




@end

@implementation ReleaseUsedMarketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
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
    if(arrayType.count==0)//获取类型
    {
        [self getTypeData];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(arrayDistrict.count==0)//获取区
    {
        [self getDistrictData];
    }
    
}
#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    
    appDlt=GetAppDelegates;
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    self.title = @"发布物品信息";
    NSLog(@"title===%@",self.title);
    
    imgArray=[NSMutableArray new];
    arrayDistrict=[NSMutableArray new];
    arrayType=[NSMutableArray new];
   
    [self.btn_District setTitle:appDlt.userData.countyname forState:UIControlStateNormal];
    districtID=appDlt.userData.countyid;
    self.TF_PhoneNum.text=appDlt.userData.phone;
    self.TF_Community.text=appDlt.userData.communityname;
    msh=@"";
    self.TF_Addrs.enabled=NO;
    
    self.TF_Addrs.text=appDlt.userData.communityaddress;
    location.latitude=[appDlt.userData.lat doubleValue];
    location.longitude=[appDlt.userData.lng doubleValue];
    

    
    if(self.changeCdoe==1)//修改
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
        if (self.room.money.floatValue > 0) {
            
            self.btn_Price.text=([XYString isBlankString:self.room.money]?@"":[self.room.money stringByReplacingOccurrencesOfString:@".0" withString:@""]);
        }
        self.TF_Title.text=([XYString isBlankString:self.room.name]?@"":self.room.name);
        
        
        [self.btn_Describe setTitle:([XYString isBlankString:self.room.descriptionString]?@"补充物品来历和亮点":self.room.descriptionString) forState:UIControlStateNormal];
        msh=([XYString isBlankString:self.room.descriptionString]?@"":self.room.descriptionString);
        self.TF_Contact.text=([XYString isBlankString:self.room.linkman]?@"":self.room.linkman);
        self.TF_PhoneNum.text=([XYString isBlankString:self.room.linkphone]?@"":self.room.linkphone);
        if(![XYString isBlankString:self.room.newness])
        {
            newOld=self.room.newness;
            ///0 全部 4 五成新一下 5 成新 6、8、9、10全新
            NSArray * array=@[@"全新", @"九成新", @"八成新", @"七成新 ", @"六成新",@"五成新",@"五成新以下"];
            NSInteger index=0;
            if([newOld integerValue]==0||[newOld integerValue]<4)
            {
                [self.btn_newOld setTitle:@"" forState:UIControlStateNormal];
            }
            else
            {
                if((10-[newOld integerValue])>=0)
                {
                    index=10-[newOld integerValue];
                    [self.btn_newOld setTitle:[array objectAtIndex:index] forState:UIControlStateNormal];
                }
            }
            
            
 
        }
        if(![XYString isBlankString:self.room.typeName])
        {
            [self.btn_Type setTitle:self.room.typeName forState:UIControlStateNormal];
            typeID=self.room.typeId;
        }
        
    }

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

#pragma mark ----------事件--------------
///没有片上传
- (IBAction)btnNoUpPicsEvent:(UIButton *)sender {
    PhotoWallVC * photoVC=[[PhotoWallVC alloc] initWithNibName:@"PhotoWallVC" bundle:nil];
    photoVC.imgArray=imgArray;
    photoVC.selectImgMaxNum=8;
    photoVC.title=@"上传照片";
    [self.navigationController pushViewController:photoVC animated:YES];
}
///上传图片
- (IBAction)btn_UpPiceEvent:(UIButton *)sender {
    PhotoWallVC * photoVC=[[PhotoWallVC alloc] initWithNibName:@"PhotoWallVC" bundle:nil];
    photoVC.selectImgMaxNum=8;
    photoVC.title=@"上传照片";
    photoVC.imgArray=imgArray;
    [self.navigationController pushViewController:photoVC animated:YES];
}


///选择城市区
- (IBAction)btn_DistrictEvent:(UIButton *)sender {
    if(arrayDistrict.count==0)
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

///小区名称变化
- (IBAction)tFCommunNameChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>10)
        {
            sender.text=[sender.text substringToIndex:10];
        }
    }

}
///地址变化
- (IBAction)TFAddressChange:(UITextField *)sender {
    
    
    
}

///进地图选地址
- (IBAction)btn_ToMapEvent:(UIButton *)sender {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"BDMapViews" bundle:nil];
    GetAddressMapVC * showMap = [secondStoryBoard instantiateViewControllerWithIdentifier:@"GetAddressMapVC"];
    showMap.delegate=self;
    [self.navigationController pushViewController:showMap animated:YES];

}

///标题输入变化
- (IBAction)TFTitleChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>10)
        {
            sender.text=[sender.text substringToIndex:10];
        }
    }

}

///进入描述编辑
- (IBAction)btnDescribeEvent:(UIButton *)sender {
    LifeEditVC * editVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeEditVC"];
    editVC.content=self.btn_Describe.titleLabel.text;
    editVC.minLenght=10;
    editVC.maxLenght=500;
    editVC.jmpCode=-1;
    editVC.tishi=@"补充物品来历和亮点";
    editVC.viewBlock=^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        if([self.btn_Describe.titleLabel.text isEqualToString:(NSString *)data])
        {
            return ;
        }
        msh=(NSString * )data;
        [self.btn_Describe setTitle:(NSString *)data forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:editVC animated:YES];
}

////物品类型选择
- (IBAction)btnTypeEvent:(UIButton *)sender {
    if(arrayType.count==0)
    {
        return;
    }
    LifeSelectListVC * selectListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeSelectListVC"];
    selectListVC.listData=arrayType;
    NSInteger selectRow=-1;
    NSDictionary * dic;
    for(int i=0;i<arrayType.count;i++)
    {
        dic=[arrayType objectAtIndex:i];
        if([[dic objectForKey:@"id"] integerValue]==[typeID integerValue])
        {
            selectRow=i;
            break;
        }
        
    }
    
    selectListVC.indexSelected=selectRow;
    selectListVC.title=@"选择物品类型";
    //列表视图
    selectListVC.cellViewBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        UITableViewCell *cell=(UITableViewCell *)view;
        NSDictionary *dic=(NSDictionary *)data;
        /**
         “id“:“12”
         ,”typename”:”物品类型名称“
         */
        cell.textLabel.text=[dic objectForKey:@"typename"];
    };
    //事件
    selectListVC.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        NSDictionary *dic=(NSDictionary *)data;
        [self.btn_Type setTitle:[dic objectForKey:@"typename"] forState:UIControlStateNormal];
        typeID=[dic objectForKey:@"id"];
        
    };
    [self.navigationController pushViewController:selectListVC animated:YES];
    
}

///新旧选择
- (IBAction)btn_NewOldEvent:(UIButton *)sender {
     ///0 全部 4 五成新一下 5 成新 6、8、9、10全新
    NSArray * array=@[@"全新", @"九成新", @"八成新", @"七成新 ", @"六成新",@"五成新",@"五成新以下"];
    LifeSelectListVC * selectListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeSelectListVC"];
    if(!selectListVC.listData)
    {
        selectListVC.listData=[NSMutableArray new];
    }
    [selectListVC.listData addObjectsFromArray:array];
    
    NSInteger select=-1;
    for(int i=0;i<array.count;i++)
    {
        if([[array objectAtIndex:i] isEqualToString:self.btn_newOld.titleLabel.text])
        {
            select=i;
            break;
        }
    }
    selectListVC.indexSelected=select;
    selectListVC.title=@"选择新旧";
    //列表视图
    selectListVC.cellViewBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        UITableViewCell *cell=(UITableViewCell *)view;
        NSString *dic=(NSString *)data;
        cell.textLabel.text=dic;
    };
    //事件
    selectListVC.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        NSString *dic=(NSString *)data;
        [self.btn_newOld setTitle:dic forState:UIControlStateNormal];
        newOld=[NSString stringWithFormat:@"%d",(10-index.row)];
    };
    [self.navigationController pushViewController:selectListVC animated:YES];

    
}

///价格变化
- (IBAction)TFPriceChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>15)
        {
            sender.text=[sender.text substringToIndex:15];
        }
    }
}

///名字输入变化
- (IBAction)TFContactChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>4)
        {
            sender.text=[sender.text substringToIndex:4];
        }
    }
}

///手机号输入变化
- (IBAction)TFphoneChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>11)
        {
            sender.text=[sender.text substringToIndex:11];
        }
    }
}

///保存草稿
- (IBAction)btn_SaveEvent:(UIButton *)sender {
    if(self.changeCdoe==1)
    {
        [self sumbitChangeDataForFlag:@"1"];
        return;
    }
    [self sumbitDataForFlag:@"1"];
}
///提交发布
- (IBAction)btn_SumbitEvent:(UIButton *)sender {
    if(self.changeCdoe==1)
    {
        [self sumbitChangeDataForFlag:@"0"];
        return;
    }
    [self sumbitDataForFlag:@"0"];
    
}

#pragma mark-----------------网络------------------
///提交数据
/**
 typeid	物品类型id
 countyid	区域id
 communityname	社区名称
 mapx	x坐标
 mapy	y坐标
 address	地址
 newness	新旧程度 0 全部 4 五成新一下 5 成新 6、8、9、10全新
 name	物品名称
 description	描述
 money	金额
 linkman	联系人
 linkphone	联系人电话
 flag	0 已发布 1 已保存
 picids	图片资源表id 逗号拼接字符
 */
-(void)sumbitDataForFlag:(NSString *)flag
{
    
    if([flag isEqualToString:@"0"])
    {
        if(self.TF_Community.text.length==0)
        {
            [self showToastMsg:@"您还没有填写小区名称" Duration:5];
            return;
        }
        if(self.TF_Addrs.text.length==0)
        {
            [self showToastMsg:@"您还没有填写地址" Duration:5];
            return;
        }
        if(self.TF_Title.text.length==0)
        {
            [self showToastMsg:@"您还没有填写物品描述" Duration:5];
            return;
        }
        if(typeID == nil)
        {
            [self showToastMsg:@"您还没有选择物品类型" Duration:5];
            return;
        }
        if(newOld==nil)
        {
            [self showToastMsg:@"您还没有选择物品新旧程度" Duration:5];
            return;
        }
        if(self.btn_Price.text.length==0)
        {
            [self showToastMsg:@"您还没有填写物品价格" Duration:5];
            return;
        }
        if(self.TF_Contact.text.length==0)
        {
            [self showToastMsg:@"您还没有填写联系人名称" Duration:5];
            return;
        }
        if(self.TF_PhoneNum.text.length==0)
        {
            [self showToastMsg:@"您还没有填写联系人电话" Duration:5];
            return;
        }
        if(self.TF_Community.text.length<1)
        {
            [self showToastMsg:@"填写小区名称不能少于1个字" Duration:5];
            return;
        }
        if(self.TF_Contact.text.length<2)
        {
            [self showToastMsg:@"姓名不能少于2个字" Duration:5.0];
            return;
        }
        
        if(![RegularUtils isPhoneNum:self.TF_PhoneNum.text])
        {
            [self showToastMsg:@"手机号格式错误" Duration:5.0];
            return;
        }
        
    }

    else{
        
        if(typeID==nil)
        {
            typeID=@"";
    
        }
        if(newOld==nil)
        {
            newOld=@"";
  
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
    NSDictionary * dic=@{@"typeid":typeID,
                         @"countyid":districtID,
                         @"communityname":self.TF_Community.text,
                         @"mapx":[NSString stringWithFormat:@"%lf",location.longitude],
                         @"mapy":[NSString stringWithFormat:@"%lf",location.latitude],
                         @"address":self.TF_Addrs.text,
                         @"newness":newOld,
                         @"name":self.TF_Title.text,
                         @"description":msh,
                         @"money":self.btn_Price.text,
                         @"linkman":self.TF_Contact.text,
                         @"linkphone":self.TF_PhoneNum.text,
                         @"flag":flag,
                         @"picids":picIDs
                         };

    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BMReplacePresenter addUsedInfo:^(id  _Nullable data, ResultCode resultCode) {

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
//                        htVc.isFromeRelease = YES;
                        htVc.jmpCode=2;
                        htVc.title=@"跳蚤市场";
                        [self.navigationController pushViewController:htVc animated:YES];
                        
                    }
                    else//保存
                    {
                        //我发布的房源
//                        THMyPublishHouseListViewController *houseVC = [[THMyPublishHouseListViewController alloc]init];
//                        houseVC.isFromeRelease = YES;
//                        houseVC.publishType = 1;
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
///修改数据
/**
 id	记录id
 typeid	物品类型id
 countyid	区域id
 mapx	x坐标
 mapy	y坐标
 address	地址
 newness	新旧程度 0 全部 4 五成新一下 5 成新 6、8、9、10全新
 name	物品名称
 description	描述
 money	金额
 linkman	联系人
 linkphone	联系人电话
 flag	0 已发布 1 已保存
 picids	图片资源表id 逗号拼接字符
 */
-(void)sumbitChangeDataForFlag:(NSString *)flag
{
    if([flag isEqualToString:@"0"])
    {
        if(self.TF_Community.text.length==0)
        {
            [self showToastMsg:@"您还没有填写小区名称" Duration:5];
            return;
        }
        if(self.TF_Addrs.text.length==0)
        {
            [self showToastMsg:@"您还没有填写地址" Duration:5];
            return;
        }
        if(self.TF_Title.text.length==0)
        {
            [self showToastMsg:@"您还没有填写物品描述" Duration:5];
            return;
        }
        if(typeID==nil)
        {
            [self showToastMsg:@"您还没有选择物品类型" Duration:5];
            return;
        }
        if(newOld==nil)
        {
            [self showToastMsg:@"您还没有选择物品新旧程度" Duration:5];
            return;
        }
        if(self.btn_Price.text.length==0)
        {
            [self showToastMsg:@"您还没有填写物品价格" Duration:5];
            return;
        }
        if(self.TF_Contact.text.length==0)
        {
            [self showToastMsg:@"您还没有填写联系人名称" Duration:5];
            return;
        }
        if(self.TF_PhoneNum.text.length==0)
        {
            [self showToastMsg:@"您还没有填写联系人电话" Duration:5];
            return;
        }
        if(self.TF_Community.text.length<1)
        {
            [self showToastMsg:@"填写小区名称不能少于1个字" Duration:5];
            return;
        }
        if(self.TF_Contact.text.length<2)
        {
            [self showToastMsg:@"姓名不能少于2个字" Duration:5.0];
            return;
        }
        
        if(![RegularUtils isPhoneNum:self.TF_PhoneNum.text])
        {
            [self showToastMsg:@"手机号格式错误" Duration:5.0];
            return;
        }
        
    }
    else
    {
        if(typeID==nil)
        {
            typeID=@"";
            
        }
        if(newOld==nil)
        {
            newOld=@"";
            
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
    NSDictionary * dic=@{
                         @"typeid":typeID,
                         @"communityname":self.TF_Community.text,
                         @"countyid":districtID,
                         @"id":self.room.theID,
                         @"mapx":[NSString stringWithFormat:@"%lf",location.longitude],
                         @"mapy":[NSString stringWithFormat:@"%lf",location.latitude],
                         @"address":self.TF_Addrs.text,
                         @"newness":newOld,
                         @"name":self.TF_Title.text,
                         @"description":msh,
                         @"money":self.btn_Price.text,
                         @"linkman":self.TF_Contact.text,
                         @"linkphone":self.TF_PhoneNum.text,
                         @"flag":flag,
                         @"picids":picIDs};
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BMReplacePresenter changeUsedInfo:^(id  _Nullable data, ResultCode resultCode) {
        
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
//                        htVc.isFromeRelease = YES;
                        htVc.jmpCode=2;
                        htVc.title=@"跳蚤市场";
                        [self.navigationController pushViewController:htVc animated:YES];
                        
                    }
                    else//保存
                    {
                        //我发布的房源
//                        THMyPublishHouseListViewController *houseVC = [[THMyPublishHouseListViewController alloc]init];
//                        houseVC.isFromeRelease=YES;
//                        houseVC.publishType = 1;
//                        [self.navigationController pushViewController:houseVC animated:YES];
                    }
                    
                }
                
            }
            else
            {
                [self showToastMsg:@"提交失败了" Duration:5.0];
                
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


///获得物品类型
-(void)getTypeData
{
    [BMReplacePresenter getUsedType:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultCode==SucceedCode)
            {
                NSArray * array=(NSArray *)data;
                [arrayType removeAllObjects];
                [arrayType addObjectsFromArray:array];
                
                if(![XYString isBlankString:self.room.name])
                {
                    NSDictionary * dic;
                    for(int i=0;i<arrayType.count;i++)
                    {
                        dic=[array objectAtIndex:i];
                        if([[dic objectForKey:@"typename"] isEqualToString:self.room.name])
                        {
                            typeID=[dic objectForKey:@"id"];
                            break;
                        }
                    }
                }
                
            }
            else
            {
                [self showToastMsg:data Duration:5.0];
                
            }
        });
    }];
}


/**
 *  定位
 */
- (void)getLocation {
    
    @WeakObj(self);

    BDMapFWPresenter * bdmap=[BDMapFWPresenter new];
    [bdmap getLocationInfoForupDateViewsBlock:^(id  _Nullable data, ResultCode resultCode) {
        [bdmap stopLocation];
        
        if (resultCode==SucceedCode) {
            
            LocationInfo *locationInfo = (LocationInfo *)data;
            
            if(appDlt.userData.cityid.intValue == 0)
            {
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
