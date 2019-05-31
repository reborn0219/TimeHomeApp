//
//  ReleaseRentalParking.m
//  TimeHomeApp
//
//  Created by us on 16/3/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ReleaseRentalParking.h"

#import "AreaSelectListViewController.h"
#import "IsFixViewController.h"
#import "DescribeViewController.h"
#import "LifeIDNameModel.h"
#import "AppSystemSetPresenters.h"
#import "LifeSelectListVC.h"
#import "RegularUtils.h"
#import "RentalAndSalesTableVC.h"
/**
 *  地图
*/
#import "GetAddressMapVC.h"
/**
 *  定位
 */
#import "BDMapFWPresenter.h"
/**
 *  网络请求
 */
#import "BMSpacePresenter.h"
#import "BMCityPresenter.h"

@interface ReleaseRentalParking () <MapAdrrBackDelegate>
{
    AppDelegate *appDelegate;
    /**
     *  选择区域ID
     */
    NSString *areaID;
    /**
     *  选择区域
     */
    NSString *areaString;
    /**
     *  是否固定车位：0否1是
     */
    NSInteger fixed;
    /**
     *  是否地下车位：0否1 是
     */
    NSInteger underground;
    /**
     *  描述
     */
    NSString *describe;
    /**
     *  定位功能
     */
    BDMapFWPresenter * bdmap;
    /**
     *  定位数据
     */
//    LocationInfo * location;
    /**
     *  x坐标
     */
    NSString *mapx;
    /**
     *  y坐标
     */
    NSString *mapy;
    /**
     *  求租求购金额
     */
    NSString *money;
    
}
/**
 *  选择区域
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_District;
/**
 *  小区
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Biotope;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Addrs;

/**
 *  地下车位
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Underground;
/**
 *  固定车位
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Fixed;

/**
 *  选择价格
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Price;
/**
 *  输入价格
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Price;

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
 *  金额控件，求租时隐藏
 */
@property (weak, nonatomic) IBOutlet UIView *view_InputPriceView;

/**
 *  小区输入控件高度，求租时隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_BiotopeHeight;
/**
 *  地址输入控件高度，求租时隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_AddrsHeight;
/**
 *  地址输入控件距顶部高度，求租时隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_AddrTopHeight;
/**
 *  小区输入控件距顶部高度，求租时隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_BiotopeTopHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_AreaViewHeight;
/**
 *  金额右边label
 */
@property (weak, nonatomic) IBOutlet UILabel *priceDetail_Label;
/**
 *  地图图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *mapImage;
/**
 *  选择money按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *moneySelect_Button;

@end

@implementation ReleaseRentalParking

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUserInfo];
    
    [self getLocation];
    [self initView];
    [self setUpInfo];
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
                LocationInfo * location = (LocationInfo *)data;

                
                if(appDelegate.userData.cityid.intValue == 0)
                {
                    [AppSystemSetPresenters getCityIDName:location.cityName UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {

                        dispatch_async(dispatch_get_main_queue(), ^{

                            if(resultCode==SucceedCode)
                            {
                                appDelegate.userData.cityid = data;
                                [appDelegate saveContext];
                                
                            }
                            else
                            {
                                [selfWeak showToastMsg:data Duration:5.0];
                            }
                            
                        });
                        
                    }];
                }
                
            }
            
        }];
    
}
/**
 *  获得用户登录的信息
 */
- (void)getUserInfo {
    appDelegate = GetAppDelegates;
    areaString = appDelegate.userData.communityaddress;
    areaID = appDelegate.userData.communityid;
    fixed = 0;
    underground = 0;
}
#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    if (_jmpCode==0||_jmpCode==1) {//出租，出售
        
    }
    else //求购，求租
    {
        self.nsLay_AddrsHeight.constant=0;
        self.nsLay_AddrTopHeight.constant=0;
        self.nsLay_BiotopeHeight.constant=0;
        self.nsLay_BiotopeTopHeight.constant=0;
        self.view_InputPriceView.hidden=YES;
        self.nsLay_AreaViewHeight.constant-=90;
    }
    self.TF_Addrs.enabled=NO;
    self.TF_Addrs.text=appDelegate.userData.communityaddress;
    mapy=appDelegate.userData.lat;
    mapx=appDelegate.userData.lng;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",mapx.doubleValue] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",mapy.doubleValue] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",self.TF_Addrs.text] forKey:@"address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    LocationInfo * location = [[LocationInfo alloc] init];
//    location.latitude = mapy.doubleValue;
//    location.longitude = mapx.doubleValue;
//    location.addres = _TF_Addrs.text;
//    [UserDefaultsStorage saveData:location forKey:@"LocationInfo"];
    

    
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToMap)];
    [_mapImage addGestureRecognizer:singleRecognizer];
    
    /**
     *  处理最大字数限制
     */
    [_TF_Biotope addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [_TF_Title addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [_TF_Contact addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [_TF_PhoneNum addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];


}

- (void) textFieldDidChange:(UITextField *) TextField{
    
    if (TextField == _TF_Biotope) {
        UITextRange * selectedRange = TextField.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(TextField.text.length >= 10)
            {
                TextField.text=[TextField.text substringToIndex:10];
            }
        }
    }
    if (TextField == _TF_Title) {
        UITextRange * selectedRange = TextField.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(TextField.text.length >= 20)
            {
                TextField.text=[TextField.text substringToIndex:20];
            }
        }
    }
    if (TextField == _TF_Contact) {
        UITextRange * selectedRange = TextField.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(TextField.text.length >= 4)
            {
                TextField.text=[TextField.text substringToIndex:4];
            }
        }
    }
    if (TextField == _TF_PhoneNum) {
        UITextRange * selectedRange = TextField.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(TextField.text.length >= 11)
            {
                TextField.text=[TextField.text substringToIndex:11];
            }
        }
    }

}

/**
 *  处理刚进来时显示的信息及按钮点击事件
 */
- (void)setUpInfo {
    if (_jmpCode == 0) {
        _priceDetail_Label.text = @"元/月";
    }
    if (_jmpCode == 1) {
        _priceDetail_Label.text = @"万元";
    }
    
    
//    mapx = @"";
//    mapy = @"";
    describe = @"";
    money = @"";
    
        mapy = [NSString stringWithFormat:@"%@",self.userPublishCar.mapy];
        mapx = [NSString stringWithFormat:@"%@",self.userPublishCar.mapx];
        
        //区域
        if (![XYString isBlankString:_userPublishCar.countyid]) {
            areaID = _userPublishCar.countyid;
            [_btn_District setTitle:_userPublishCar.countyname forState:UIControlStateNormal];
        }else {
            if (![XYString isBlankString:appDelegate.userData.countyid]) {
                areaID = appDelegate.userData.countyid;
                [_btn_District setTitle:appDelegate.userData.countyname forState:UIControlStateNormal];
            }else {
                areaID = @"";
                [_btn_District setTitle:@"请选择区域" forState:UIControlStateNormal];
            }
            
        }
        [_btn_District addTarget:self action:@selector(selectDistrict) forControlEvents:UIControlEventTouchUpInside];
        
        //小区
        if (![XYString isBlankString:_userPublishCar.communityname]) {
            _TF_Biotope.text = _userPublishCar.communityname;
        }else {
            if (![XYString isBlankString:appDelegate.userData.communityname]) {
                _TF_Biotope.text = appDelegate.userData.communityname;
            }
        }
        
        //地址
        if (![XYString isBlankString:_userPublishCar.address]) {
            _TF_Addrs.text = _userPublishCar.address;
        }else {
            if (![XYString isBlankString:appDelegate.userData.communityaddress]) {
                _TF_Addrs.text = appDelegate.userData.communityaddress;
            }
        }
        if (![XYString isBlankString:_userPublishCar.mapx]) {
            mapx = _userPublishCar.mapx;
        }
        if (![XYString isBlankString:_userPublishCar.mapy]) {
            mapy = _userPublishCar.mapy;
        }
        
        
        //地下车位
        if (underground == 0) {
            [_btn_Underground setTitle:@"否" forState:UIControlStateNormal];
        }else {
            [_btn_Underground setTitle:@"是" forState:UIControlStateNormal];
        }
        if (![XYString isBlankString:_userPublishCar.underground]) {
            if (_userPublishCar.underground.intValue == 0) {
                underground = 0;
                [_btn_Underground setTitle:@"否" forState:UIControlStateNormal];
            }else {
                underground = 1;
                [_btn_Underground setTitle:@"是" forState:UIControlStateNormal];
            }
        }
        [_btn_Underground addTarget:self action:@selector(selectUnderground) forControlEvents:UIControlEventTouchUpInside];
        
        //固定车位
        if (fixed == 0) {
            [_btn_Fixed setTitle:@"否" forState:UIControlStateNormal];
        }else {
            [_btn_Fixed setTitle:@"是" forState:UIControlStateNormal];
        }
        if (![XYString isBlankString:_userPublishCar.fixed]) {
            if (_userPublishCar.fixed.intValue == 0) {
                fixed = 0;
                [_btn_Fixed setTitle:@"否" forState:UIControlStateNormal];
            }else {
                fixed = 1;
                [_btn_Fixed setTitle:@"是" forState:UIControlStateNormal];
            }
        }
        [_btn_Fixed addTarget:self action:@selector(selectFixed) forControlEvents:UIControlEventTouchUpInside];
        
        //金额
        if (_jmpCode == 0 || _jmpCode == 1) {
            if (![XYString isBlankString:_userPublishCar.money] && _userPublishCar.money.intValue != -1) {
                _TF_Price.text = _userPublishCar.money;
                money = _userPublishCar.money;
            }
        }
        if (_jmpCode == 2) {
            if (_userPublishCar.moneybegin.intValue == 0) {
                money = [NSString stringWithFormat:@"%.0f元以下/月",_userPublishCar.moneyend.floatValue];
            }else if (_userPublishCar.moneyend.intValue == 0) {
                money = [NSString stringWithFormat:@"%.0f元以上/月",_userPublishCar.moneybegin.floatValue];
            }else {
                money = [NSString stringWithFormat:@"%.0f-%.0f元/月",_userPublishCar.moneybegin.floatValue,_userPublishCar.moneyend.floatValue];
            }
            if (_userPublishCar.moneybegin.intValue == 0 && _userPublishCar.moneyend.intValue == 0) {
                money = @"";
            }
            [_moneySelect_Button setTitle:money forState:UIControlStateNormal];
        }
        if (_jmpCode == 3) {
            if (_userPublishCar.moneybegin.intValue == 0) {
                money = [NSString stringWithFormat:@"%.0f万元以下",_userPublishCar.moneyend.floatValue];
            }else if (_userPublishCar.moneyend.intValue == 0) {
                money = [NSString stringWithFormat:@"%.0f万元以上",_userPublishCar.moneybegin.floatValue];
            }else {
                money = [NSString stringWithFormat:@"%.0f-%.0f万元",_userPublishCar.moneybegin.floatValue,_userPublishCar.moneyend.floatValue];
            }
            if (_userPublishCar.moneybegin.intValue == 0 && _userPublishCar.moneyend.intValue == 0) {
                money = @"";
            }
            [_moneySelect_Button setTitle:money forState:UIControlStateNormal];
        }
        
        //标题
        if (![XYString isBlankString:_userPublishCar.title]) {
            _TF_Title.text = _userPublishCar.title;
        }
        //描述
        if (![XYString isBlankString:_userPublishCar.descriptionString]) {
            describe = _userPublishCar.descriptionString;
            [_btn_Describe setTitle:describe forState:UIControlStateNormal];
        }
        [_btn_Describe addTarget:self action:@selector(describeClick) forControlEvents:UIControlEventTouchUpInside];
        
        //联系人
        if (![XYString isBlankString:_userPublishCar.linkman]) {
            _TF_Contact.text = _userPublishCar.linkman;
        }
        //手机号
        if (![XYString isBlankString:_userPublishCar.linkphone]) {
            _TF_PhoneNum.text = _userPublishCar.linkphone;
        }else {
            if (![XYString isBlankString:appDelegate.userData.phone]) {
                _TF_PhoneNum.text = appDelegate.userData.phone;
            }
        }

        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",mapx.doubleValue] forKey:@"longitude"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",mapy.doubleValue] forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",self.TF_Addrs.text] forKey:@"address"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        LocationInfo * location = [[LocationInfo alloc] init];
//        location.latitude = mapy.doubleValue;
//        location.longitude = mapx.doubleValue;
//        location.addres = _TF_Addrs.text;
//        [UserDefaultsStorage saveData:location forKey:@"LocationInfo"];
    
}
#pragma mark ----------事件处理--------------
/**
 *  跳转到地图界面
 */
- (void)goToMap {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"BDMapViews" bundle:nil];
    GetAddressMapVC * showMap = [secondStoryBoard instantiateViewControllerWithIdentifier:@"GetAddressMapVC"];
    showMap.delegate = self;
    [self.navigationController pushViewController:showMap animated:YES];

}
-(void)goBackAddr:(NSString *)addr location:(CLLocationCoordinate2D) loc {
    
    _TF_Addrs.text = addr;
    mapx = [NSString stringWithFormat:@"%f",loc.longitude];
    mapy = [NSString stringWithFormat:@"%f",loc.latitude];

    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",mapx.doubleValue] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",mapy.doubleValue] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",self.TF_Addrs.text] forKey:@"address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  跳转描述界面
 */
- (void)describeClick {
    DescribeViewController *desVC = [[DescribeViewController alloc]init];
    desVC.describeString = [XYString IsNotNull:describe];
    desVC.describeCallBack = ^(NSString *string) {
        describe = string;
        [_btn_Describe setTitle:describe forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:desVC animated:YES];
}
/**
 *  选择固定车位
 */
- (void)selectFixed {
    @WeakObj(self);
    IsFixViewController *isFixVC = [[IsFixViewController alloc]init];
    isFixVC.indexSelect = fixed;
    isFixVC.title = @"固定车位";
    isFixVC.indexCallBack = ^(NSInteger index) {
        fixed = index;
        if (fixed == 0) {
            [selfWeak.btn_Fixed setTitle:@"否" forState:UIControlStateNormal];
        }else {
            [selfWeak.btn_Fixed setTitle:@"是" forState:UIControlStateNormal];
        }
    };
    [self.navigationController pushViewController:isFixVC animated:YES];
}
/**
 *  选择地下车位
 */
- (void)selectUnderground {
    @WeakObj(self);
    IsFixViewController *isFixVC = [[IsFixViewController alloc]init];
    isFixVC.indexSelect = underground;
    isFixVC.title = @"地下车位";
    isFixVC.indexCallBack = ^(NSInteger index) {
        underground = index;
        if (underground == 0) {
            [selfWeak.btn_Underground setTitle:@"否" forState:UIControlStateNormal];
        }else {
            [selfWeak.btn_Underground setTitle:@"是" forState:UIControlStateNormal];
        }
    };
    [self.navigationController pushViewController:isFixVC animated:YES];
}
/**
 *  选择区域
 */
- (void)selectDistrict {

    AreaSelectListViewController *areaVC = [[AreaSelectListViewController alloc]init];
    areaVC.areaID = areaID;
    
    areaVC.callBack = ^(NSString *string1,NSString *string2) {
        areaID = string1;
        areaString = string2;
        [_btn_District setTitle:areaString forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:areaVC animated:YES];

}

/**
 *  求租求购金额选择
 */
- (IBAction)selectMoneyButtonClick:(id)sender {

    NSMutableArray *moneyArray = [[NSMutableArray alloc]initWithObjects:@"100元以下/月",@"100-200元/月",@"200-300元/月",@"300-500元/月",@"500元以上/月", nil];
    NSMutableArray *moneyArray1 = [[NSMutableArray alloc]initWithObjects:@"5万元以下",@"5-10万元",@"10-15万元",@"15-20万元",@"20万元以上", nil];
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LifeTab" bundle:nil];
    LifeSelectListVC * listVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"LifeSelectListVC"];
    listVC.title = @"选择金额";
    if (self.jmpCode == 2) {
        listVC.listData = moneyArray;
    }else {
        listVC.listData = moneyArray1;
    }
    listVC.indexSelected=-1;
    for (int i = 0; i < moneyArray.count; i++) {
        if ([money isEqualToString:moneyArray[i]]) {
            listVC.indexSelected = i;
            break;
        }
    }
    if ([XYString isBlankString:money]) {
        listVC.indexSelected = 100;
    }
    listVC.cellViewBlock = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        UITableViewCell *cell = (UITableViewCell *)view;
        cell.textLabel.text = data;
        cell.textLabel.font = DEFAULT_FONT(16);
        cell.textLabel.textColor = TITLE_TEXT_COLOR;
    };
    listVC.cellEventBlock = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        money = data;
        [_moneySelect_Button setTitle:money forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:listVC animated:YES];
    
}

/**
 *  保存按钮点击
 */
- (IBAction)saveInfoButtonClick:(id)sender {
    //typeID 0保存 1修改
    if (self.typeID == 0) {
        [self httpRequestForFlag:1];
    }else {
        [self httpRequestForMotifyFlag:1];
    }
}
/**
 *  发布按钮点击
 */
- (IBAction)distributeInfoButtonClick:(id)sender {
    if ([self isBlank]) {
        return;
    }
    if (self.typeID == 0) {
        [self httpRequestForFlag:0];
    }else {
        [self httpRequestForMotifyFlag:0];
    }
}
/**
 *  修改草稿请求
 *
 *  @param flag 0发布 1保存
 */
- (void)httpRequestForMotifyFlag:(NSInteger)flag {
    
    @WeakObj(self);
//    if ([self isBlank]) {
//        return;
//    }
    NSDictionary *dictionary = [[NSDictionary alloc]init];
    
    if (self.jmpCode ==0 || self.jmpCode == 1) {
        if ([XYString isBlankString:mapx] || [XYString isBlankString:mapy]) {
            dictionary = @{
                           @"id":_userPublishCar.theID,
                           @"sertype":[NSString stringWithFormat:@"%d",_jmpCode],
                           @"countyid":areaID,
                           @"communityname":_TF_Biotope.text,
                           @"mapx":@"",
                           @"mapy":@"",
                           @"address":_TF_Addrs.text,
                           @"title":_TF_Title.text,
                           @"description":describe,
                           @"fixed":[NSString stringWithFormat:@"%ld",(long)fixed],
                           @"underground":[NSString stringWithFormat:@"%ld",(long)underground],
                           @"money":_TF_Price.text,
                           @"linkman":_TF_Contact.text,
                           @"linkphone":_TF_PhoneNum.text,
                           @"flag":[NSString stringWithFormat:@"%ld",(long)flag]
                           };
        }else {
            dictionary = @{
                           @"id":_userPublishCar.theID,
                           @"sertype":[NSString stringWithFormat:@"%d",_jmpCode],
                           @"countyid":areaID,
                           @"communityname":_TF_Biotope.text,
                           @"mapx":mapx,
                           @"mapy":mapy,
                           @"address":_TF_Addrs.text,
                           @"title":_TF_Title.text,
                           @"description":describe,
                           @"fixed":[NSString stringWithFormat:@"%ld",(long)fixed],
                           @"underground":[NSString stringWithFormat:@"%ld",(long)underground],
                           @"money":_TF_Price.text,
                           @"linkman":_TF_Contact.text,
                           @"linkphone":_TF_PhoneNum.text,
                           @"flag":[NSString stringWithFormat:@"%ld",(long)flag]
                           };
        }
        
        
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self.tabBarController];
        
        [BMSpacePresenter changeCarrental:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                
                if(resultCode==SucceedCode)
                {
                    [selfWeak showToastMsg:@"提交成功" Duration:2.0];
                    /// 0. 发布出租 1.发布出售 2.发布求租 3.发布求购
                    ///2.车位求租 3.车位求售  4.车位出租 5.车位出售
                    if(self.typeID==1)
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        if(flag==0)//发布
                        {
                            RentalAndSalesTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RentalAndSalesTableVC"];
                            if(_jmpCode==0)
                            {
                                htVc.jmpCode=4;
                                htVc.title=@"出租";
                            }
                            else if (_jmpCode==1)
                            {
                                htVc.jmpCode=5;
                                htVc.title=@"出售";
                            }
                            else if (_jmpCode==2)
                            {
                                htVc.jmpCode=2;
                                htVc.title=@"求租";
                            }
                            else if (_jmpCode==3)
                            {
                                htVc.jmpCode=3;
                                htVc.title=@"求购";
                            }
                            htVc.isFromeRelease=YES;
                            [self.navigationController pushViewController:htVc animated:YES];
                            
                        }
                        else//保存
                        {
                            //我发布的车位
//                            THMyPublishCarLocationViewController *carVC = [[THMyPublishCarLocationViewController alloc]init];
//                            carVC.isFromeRelease=YES;
//                            [self.navigationController pushViewController:carVC animated:YES];
                        }
                        
                    }
                }
                else
                {
                    [selfWeak showToastMsg:data Duration:2.0];
                }
                
            });
            
        } withInfo:dictionary];
        
    }else {
        
        NSString *moneybegin = @"";
        NSString *moneyend = @"";
        if (self.jmpCode == 2) {
            if ([money containsString:@"元以下/月"]) {
                moneybegin = @"0";
                moneyend = @"100";
            }else if ([money containsString:@"元以上/月"]) {
                moneybegin = @"500";
                moneyend = @"0";
            }else if ([money containsString:@"元/月"]) {
                money = [money stringByReplacingOccurrencesOfString:@"元/月" withString:@""];
                moneybegin = [money componentsSeparatedByString:@"-"][0];
                moneyend = [money componentsSeparatedByString:@"-"][1];
            }
        }else {
            if ([money containsString:@"万元以下"]) {
                moneybegin = @"0";
                moneyend = @"5";
            }else if ([money containsString:@"万元以上"]) {
                moneybegin = @"20";
                moneyend = @"0";
            }else if ([money containsString:@"万元"]) {
                money = [money stringByReplacingOccurrencesOfString:@"万元" withString:@""];
                moneybegin = [money componentsSeparatedByString:@"-"][0];
                moneyend = [money componentsSeparatedByString:@"-"][1];
            }
        }

        dictionary = @{
                       @"id":_userPublishCar.theID,
                       @"sertype":[NSString stringWithFormat:@"%d",_jmpCode],
                       @"countyid":areaID,
                       @"title":_TF_Title.text,
                       @"description":describe,
                       @"fixed":[NSString stringWithFormat:@"%ld",(long)fixed],
                       @"underground":[NSString stringWithFormat:@"%ld",(long)underground],
                       @"moneybegin":moneybegin,
                       @"moneyend":moneyend,
                       @"linkman":_TF_Contact.text,
                       @"linkphone":_TF_PhoneNum.text,
                       @"flag":[NSString stringWithFormat:@"%ld",(long)flag]
                       };
        
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self.tabBarController];
        [BMSpacePresenter changeCarrentalWant:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                
                if(resultCode==SucceedCode)
                {
                    [selfWeak showToastMsg:@"提交成功" Duration:2.0];
                    /// 0. 发布出租 1.发布出售 2.发布求租 3.发布求购
                    ///2.车位求租 3.车位求售  4.车位出租 5.车位出售
                    if(self.typeID==1)
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        if(flag==0)//发布
                        {
                            RentalAndSalesTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RentalAndSalesTableVC"];
                            if(_jmpCode==0)
                            {
                                htVc.jmpCode=4;
                                htVc.title=@"出租";
                            }
                            else if (_jmpCode==1)
                            {
                                htVc.jmpCode=5;
                                htVc.title=@"出售";
                            }
                            else if (_jmpCode==2)
                            {
                                htVc.jmpCode=2;
                                htVc.title=@"求租";
                            }
                            else if (_jmpCode==3)
                            {
                                htVc.jmpCode=3;
                                htVc.title=@"求购";
                            }
                            htVc.isFromeRelease=YES;
                            [self.navigationController pushViewController:htVc animated:YES];
                            
                        }
                        else//保存
                        {
                            //我发布的车位
//                            THMyPublishCarLocationViewController *carVC = [[THMyPublishCarLocationViewController alloc]init];
//                            carVC.isFromeRelease=YES;
//                            [self.navigationController pushViewController:carVC animated:YES];
                        }
                        
                    }
                }
                else
                {
                    [selfWeak showToastMsg:data Duration:2.0];
                }
                
            });
            
        } withInfo:dictionary];

    }
    
}

/**
 *  发布保存请求
 *
 *  @param flag 0发布 1保存
 */
- (void)httpRequestForFlag:(NSInteger)flag {
    
    @WeakObj(self);
//    if ([self isBlank]) {
//        return;
//    }
    NSDictionary *dictionary = [[NSDictionary alloc]init];
    
    if (self.jmpCode ==0 || self.jmpCode == 1) {
        
        if ([XYString isBlankString:mapx] || [XYString isBlankString:mapy]) {
            dictionary = @{
                           @"sertype":[NSString stringWithFormat:@"%d",_jmpCode],
                           @"countyid":areaID,
                           @"communityname":_TF_Biotope.text,
                           @"mapx":@"",
                           @"mapy":@"",
                           @"address":_TF_Addrs.text,
                           @"title":_TF_Title.text,
                           @"description":describe,
                           @"fixed":[NSString stringWithFormat:@"%ld",(long)fixed],
                           @"underground":[NSString stringWithFormat:@"%ld",(long)underground],
                           @"money":_TF_Price.text,
                           @"linkman":_TF_Contact.text,
                           @"linkphone":_TF_PhoneNum.text,
                           @"flag":[NSString stringWithFormat:@"%ld",(long)flag]
                           };
        }else {
            dictionary = @{
                           @"sertype":[NSString stringWithFormat:@"%d",_jmpCode],
                           @"countyid":areaID,
                           @"communityname":_TF_Biotope.text,
                           @"mapx":mapx,
                           @"mapy":mapy,
                           @"address":_TF_Addrs.text,
                           @"title":_TF_Title.text,
                           @"description":describe,
                           @"fixed":[NSString stringWithFormat:@"%ld",(long)fixed],
                           @"underground":[NSString stringWithFormat:@"%ld",(long)underground],
                           @"money":_TF_Price.text,
                           @"linkman":_TF_Contact.text,
                           @"linkphone":_TF_PhoneNum.text,
                           @"flag":[NSString stringWithFormat:@"%ld",(long)flag]
                           };
        }
        
        
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self.tabBarController];
        
        [BMSpacePresenter addCarrental:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                
                if(resultCode==SucceedCode)
                {
                    [self showToastMsg:@"提交成功" Duration:2.0];
                    /// 0. 发布出租 1.发布出售 2.发布求租 3.发布求购
                    ///2.车位求租 3.车位求售  4.车位出租 5.车位出售
                    if(self.typeID==1)
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        if(flag==0)//发布
                        {
                            RentalAndSalesTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RentalAndSalesTableVC"];
                            if(_jmpCode==0)
                            {
                                htVc.jmpCode=4;
                                htVc.title=@"出租";
                            }
                            else if (_jmpCode==1)
                            {
                                htVc.jmpCode=5;
                                htVc.title=@"出售";
                            }
                            else if (_jmpCode==2)
                            {
                                htVc.jmpCode=2;
                                htVc.title=@"求租";
                            }
                            else if (_jmpCode==3)
                            {
                                htVc.jmpCode=3;
                                htVc.title=@"求购";
                            }
                            htVc.isFromeRelease=YES;
                            [self.navigationController pushViewController:htVc animated:YES];
                            
                        }
                        else//保存
                        {
                            //我发布的车位
//                            THMyPublishCarLocationViewController *carVC = [[THMyPublishCarLocationViewController alloc]init];
//                            carVC.isFromeRelease=YES;
//                            [self.navigationController pushViewController:carVC animated:YES];
                        }
                        
                    }
                }
                else
                {
                    [selfWeak showToastMsg:data Duration:2.0];
                }
                
            });
            
            
        } withInfo:dictionary];
        
    }else {
        
        NSString *moneybegin = @"";
        NSString *moneyend = @"";
        if (self.jmpCode == 2) {
            if ([money containsString:@"元以下/月"]) {
                moneybegin = @"0";
                moneyend = @"100";
            }else if ([money containsString:@"元以上/月"]) {
                moneybegin = @"500";
                moneyend = @"0";
            }else if ([money containsString:@"元/月"]) {
                money = [money stringByReplacingOccurrencesOfString:@"元/月" withString:@""];
                moneybegin = [money componentsSeparatedByString:@"-"][0];
                moneyend = [money componentsSeparatedByString:@"-"][1];
            }
        }else {
            if ([money containsString:@"万元以下"]) {
                moneybegin = @"0";
                moneyend = @"5";
            }else if ([money containsString:@"万元以上"]) {
                moneybegin = @"20";
                moneyend = @"0";
            }else if ([money containsString:@"万元"]) {
                money = [money stringByReplacingOccurrencesOfString:@"万元" withString:@""];
                moneybegin = [money componentsSeparatedByString:@"-"][0];
                moneyend = [money componentsSeparatedByString:@"-"][1];
            }
        }
        
        dictionary = @{
                       @"sertype":[NSString stringWithFormat:@"%d",_jmpCode],
                       @"countyid":areaID,
                       @"title":_TF_Title.text,
                       @"description":describe,
                       @"fixed":[NSString stringWithFormat:@"%ld",(long)fixed],
                       @"underground":[NSString stringWithFormat:@"%ld",(long)underground],
                       @"moneybegin":moneybegin,
                       @"moneyend":moneyend,
                       @"linkman":_TF_Contact.text,
                       @"linkphone":_TF_PhoneNum.text,
                       @"flag":[NSString stringWithFormat:@"%ld",(long)flag]
                       };
        
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self.tabBarController];
        
        [BMSpacePresenter addCarrentalWant:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                
                if(resultCode==SucceedCode)
                {
                    [self showToastMsg:@"提交成功" Duration:2.0];
                    /// 0. 发布出租 1.发布出售 2.发布求租 3.发布求购
                    ///2.车位求租 3.车位求售  4.车位出租 5.车位出售
                    if(self.typeID==1)
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        if(flag==0)//发布
                        {
                            RentalAndSalesTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RentalAndSalesTableVC"];
                            if(_jmpCode==0)
                            {
                                htVc.jmpCode=4;
                                htVc.title=@"出租";
                            }
                            else if (_jmpCode==1)
                            {
                                htVc.jmpCode=5;
                                htVc.title=@"出售";
                            }
                            else if (_jmpCode==2)
                            {
                                htVc.jmpCode=2;
                                htVc.title=@"求租";
                            }
                            else if (_jmpCode==3)
                            {
                                htVc.jmpCode=3;
                                htVc.title=@"求购";
                            }
                            htVc.isFromeRelease=YES;
                            [self.navigationController pushViewController:htVc animated:YES];
                            
                        }
                        else//保存
                        {
                            //我发布的车位
//                            THMyPublishCarLocationViewController *carVC = [[THMyPublishCarLocationViewController alloc]init];
//                            carVC.isFromeRelease=YES;
//                            [self.navigationController pushViewController:carVC animated:YES];
                        }
                        
                    }
                    
                }
                else
                {
                    [selfWeak showToastMsg:data Duration:2.0];
                }
                
            });
            
        } withInfo:dictionary];
        
    }
}
/**
 *  判断所填信息是否为空
 */
- (BOOL)isBlank {
    if (_jmpCode == 0 || _jmpCode == 1) {
        if ([XYString isBlankString:areaID]) {
            [self showToastMsg:@"请选择区域" Duration:2.0];
            return YES;
        }else if ([XYString isBlankString:_TF_Biotope.text]) {
            [self showToastMsg:@"请填写小区" Duration:2.0];
            return YES;
        }else if (_TF_Biotope.text.length > 10) {
            [self showToastMsg:@"小区名字为1-10字" Duration:2.0];
            return YES;
        }else if ([XYString isBlankString:_TF_Addrs.text]) {
            [self showToastMsg:@"请填写地址" Duration:2.0];
            return YES;
        }else if ([XYString isBlankString:_TF_Price.text]) {
            [self showToastMsg:@"请填写金额" Duration:2.0];
            return YES;
        }else if (_TF_Price.text.doubleValue == 0.00) {
            [self showToastMsg:@"金额不能为0" Duration:2.0];
            return YES;
        }else if (_TF_Price.text.doubleValue < 0.00) {
            [self showToastMsg:@"请填写正确的金额" Duration:2.0];
            return YES;
        }else if ([XYString isBlankString:_TF_Title.text]) {
            [self showToastMsg:@"请填写标题" Duration:2.0];
            return YES;
        }else if (_TF_Title.text.length > 20 || _TF_Title.text.length < 4) {
            [self showToastMsg:@"标题应为4-20字" Duration:2.0];
            return YES;
        }else if ([XYString isBlankString:describe]) {
            [self showToastMsg:@"请填写描述信息" Duration:2.0];
            return YES;
        }else if (describe.length < 10) {
            [self showToastMsg:@"描述内容至少为10字" Duration:2.0];
            return YES;
        }else if ([XYString isBlankString:_TF_Contact.text]) {
            [self showToastMsg:@"请填写联系人姓名" Duration:2.0];
            return YES;
        }else if (_TF_Contact.text.length > 4 || _TF_Contact.text.length < 2) {
            [self showToastMsg:@"联系人姓名为2-4字" Duration:2.0];
            return YES;
        }else if ([XYString isBlankString:_TF_PhoneNum.text]) {
            [self showToastMsg:@"请填写手机号" Duration:2.0];
            return YES;
        }else if (![RegularUtils isPhoneNum:_TF_PhoneNum.text]) {
            [self showToastMsg:@"请填写正确的手机号" Duration:2.0];
            return YES;
        }else {
            return NO;
        }
    }else {
        if ([XYString isBlankString:areaID]) {
            [self showToastMsg:@"请选择区域" Duration:2.0];
            return YES;
        }else if ([XYString isBlankString:money]) {
            [self showToastMsg:@"请选择金额" Duration:2.0];
            return YES;
        }else if ([XYString isBlankString:_TF_Title.text]) {
            [self showToastMsg:@"请填写标题" Duration:2.0];
            return YES;
        }else if (_TF_Title.text.length > 20 || _TF_Title.text.length < 4) {
            [self showToastMsg:@"标题应为4-20字" Duration:2.0];
            return YES;
        }else if ([XYString isBlankString:describe]) {
            [self showToastMsg:@"请填写描述信息" Duration:2.0];
            return YES;
        }else if (describe.length < 10) {
            [self showToastMsg:@"描述内容至少为10字" Duration:2.0];
            return YES;
        }else if ([XYString isBlankString:_TF_Contact.text]) {
            [self showToastMsg:@"请填写联系人姓名" Duration:2.0];
            return YES;
        }else if (_TF_Contact.text.length > 4 || _TF_Contact.text.length < 2) {
            [self showToastMsg:@"联系人姓名为2-4字" Duration:2.0];
            return YES;
        }else if ([XYString isBlankString:_TF_PhoneNum.text]) {
            [self showToastMsg:@"请填写手机号" Duration:2.0];
            return YES;
        }else if (![RegularUtils isPhoneNum:_TF_PhoneNum.text]) {
            [self showToastMsg:@"请填写正确的手机号" Duration:2.0];
            return YES;
        }else {
            return NO;
        }
    }
}



@end
