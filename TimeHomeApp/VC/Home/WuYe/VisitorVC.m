//
//  VisitorVC.m
//  TimeHomeApp
//
//  Created by us on 16/2/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "VisitorVC.h"
#import "VisitorCompleteVC.h"
#import "CommunityManagerPresenters.h"
#import "PopListVC.h"
#import "UserTrafficPresenter.h"
#import "RegularUtils.h"
#import "MMDateView.h"
#import "PopListVC.h"
#import "PACarSpaceService.h"
#import "LS_VistorListVC.h"//访客通行列表
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ParkingManagePresenter.h"
#import "PATrafficService.h"
#import "LS_VistorDetailsVC.h"

#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

#import "WebViewVC.h"

@interface VisitorVC ()<ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate,UITextViewDelegate,PABaseServiceDelegate>
{
    ///地址数据
    NSArray * homeAddresArray;
    ///选择的地址id
    NSString * hAddresID;
    ///车牌
    NSString * carNum;
    ///权限 0 进小区 1 单元门  2 电梯
    NSString * power;
    ///选中的到访日期
    NSString * selectDate;
    ///省简称数组
    NSArray *provinceArray;
    ///字母数组
    NSMutableArray *charArray;
    ///通讯录
//    ABPeoplePickerNavigationController* abPeoplePicerNav;

    ///是否有房产
    BOOL isHaveHouse;
    ///是否有车位
    BOOL isHaveParking;
    //通讯录权限
    BOOL accessGranted;
    BOOL isNewParking;
}

/**
 *  到访日期
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Date;
/**
 *  车牌第一位
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_CarNumFirst;
/**
 *  车牌第二位
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_CarNumSecond;
/**
 *  车牌后五位
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_CarNumLast;
/**
 *  选择地址
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Addrs;
/**
 *  进小区权限
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_IntoVillage;
/**
 *  进单元门
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_IntoUnitGate;
/**
 *  进电梯
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_IntoElevator;
/**
 *  来访都手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Phone;
/**
 *  通讯录
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_AddressBook;

///车牌输入父视图，用于没有车位时隐藏
@property (weak, nonatomic) IBOutlet UIView *view_BgCarNum;
///车牌输入父视图高度，用于没有车位时隐藏
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_CarNumBgHeigth;

///车牌输入父视图，用于没有车位时隐藏
@property (weak, nonatomic) IBOutlet UIView *view_BgAddress;
///车牌输入父视图高度，用于没有车位时隐藏
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_AddressBgHeigth;
////权限访客信息父视图，用于没有车位时隐藏
@property (weak, nonatomic) IBOutlet UIView *view_QXBg;
////权限访客信息父视图高度，用于没有车位时隐藏
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_QXBgHeight;
///授权视图
@property (weak, nonatomic) IBOutlet UIView *v_Authorized;
///授权视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_AuthorzedHeight;
///手机号视图
@property (weak, nonatomic) IBOutlet UIView *v_Phone;
///手机号视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_phoneHeight;

/**
 *  来访者姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Name;
/**
 *  捎句话留言内容
 */
@property (weak, nonatomic) IBOutlet UITextView *ZG_SetMessage;
/**
 *  捎句话与手机号之间的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ZG_msgLayout;
/**
 *  捎句话默认
 */
@property (weak, nonatomic) IBOutlet UITextView *ZG_PlaceHold;

/**
 *  车位提示语
 */
@property (weak, nonatomic) IBOutlet UILabel *carLal;
/**
 *  车位提示语顶部距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carLalTopHeight;
/**
 *  车位提示语高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carLalHeight;

/**
 *  住址提示语
 */
@property (weak, nonatomic) IBOutlet UILabel *addressLal;
/**
 *  住址提示语顶部距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addLalTopHeight;
/**
 *  住址提示语高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addLalHeight;

@property (nonatomic, strong) PACarSpaceService * service;
@property (nonatomic, strong) PATrafficService  * trafficService;
@end

@implementation VisitorVC

#pragma mark - 使用说明

- (IBAction)howToUseClick:(UIButton *)sender {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.url = [NSString stringWithFormat:@"%@/20170906/visitorPass.html",kH5_SEVER_URL];
    webVc.title = @"访客通行使用说明";
    [self.navigationController pushViewController:webVc animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    carNum = @"";
    isNewParking = NO;
    [self initView];
    
    //通讯录权限
    [self accessTheAddress];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [TalkingData trackPageBegin:@"fangketongxing"];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate markStatistics:FangKeTongXing];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [TalkingData trackPageEnd:@"fangketongxing"];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":FangKeTongXing}];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(PATrafficService *)trafficService{
    
    if (!_trafficService) {
        _trafficService = [[PATrafficService alloc]init];
        _trafficService.delegate = self;
    }
    return _trafficService;
}
-(PACarSpaceService *)service{
    if (!_service) {
        _service = [[PACarSpaceService alloc]init];
        _service.delegate = self;
    }
    return _service;
}
#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    selectDate = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
    [self.btn_Date setTitle:selectDate forState:UIControlStateNormal];
    ///通讯录
    //    abPeoplePicerNav=[[ABPeoplePickerNavigationController alloc]init];
    //    abPeoplePicerNav.peoplePickerDelegate=self;
    ///省简称
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
    provinceArray = [NSArray arrayWithContentsOfFile:path];
    ///26大写字母
    charArray=[NSMutableArray new];
    for (int i = 0; i < 26; i++) {
        NSString *cityKey = [NSString stringWithFormat:@"%c",i+65];
        [charArray addObject:cityKey];
    }
    
    self.v_Phone.hidden =YES;
    self.nsLay_phoneHeight.constant = 0;
    
    self.view_QXBg.hidden=NO;
    self.nsLay_QXBgHeight.constant=90;//135
    
    self.carLal.hidden = YES;
    self.carLalTopHeight.constant = 0;//15
    self.carLalHeight.constant = 0;//15
    
    self.addressLal.hidden = YES;
    self.addLalTopHeight.constant = 0;//15
    self.addLalHeight.constant = 0;//15
    
    _view_BgCarNum.hidden=YES;
    _nsLay_CarNumBgHeigth.constant=0;//80
//
    _view_BgAddress.hidden=YES;
    _nsLay_AddressBgHeigth.constant=0;//80
    
    _v_Authorized.hidden=YES;
    _nsLay_AuthorzedHeight.constant=0;//55
    
    [self.btn_IntoVillage setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    [self.btn_IntoVillage setTitleColor:NEW_RED_COLOR forState:UIControlStateSelected];
    //边框宽度及颜色设置
    [self.btn_IntoVillage.layer setBorderWidth:1];
    [self.btn_IntoVillage.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
    
    [self.btn_IntoUnitGate setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    [self.btn_IntoUnitGate setTitleColor:NEW_RED_COLOR forState:UIControlStateSelected];
    [self.btn_IntoUnitGate.layer setBorderWidth:1];
    [self.btn_IntoUnitGate.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
    
    [self.btn_IntoElevator setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    [self.btn_IntoElevator setTitleColor:NEW_RED_COLOR forState:UIControlStateSelected];
    [self.btn_IntoElevator.layer setBorderWidth:1];
    [self.btn_IntoElevator.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
    
    
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.TF_CarNumLast.leftViewMode = UITextFieldViewModeAlways;
    self.TF_CarNumLast.leftView = leftview;
    
    UIView *leftview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.TF_Phone.leftViewMode = UITextFieldViewModeAlways;
    self.TF_Phone.leftView = leftview1;
    
    UIView *leftview2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.TF_Name.leftViewMode = UITextFieldViewModeAlways;
    self.TF_Name.leftView = leftview2;
    
    
    self.ZG_SetMessage.delegate = self;
    
    AppDelegate * appDlt=GetAppDelegates;
    if(![XYString isBlankString:appDlt.userData.carprefix]&&appDlt.userData.carprefix.length>=2)
    {
        NSString * tmp1=[appDlt.userData.carprefix substringToIndex:1];
        NSRange range= NSMakeRange(1,1);
        NSString * tmp2=[appDlt.userData.carprefix substringWithRange:range];
        
        [self.btn_CarNumFirst setTitle:tmp1 forState:UIControlStateNormal];
        [self.btn_CarNumSecond setTitle:tmp2 forState:UIControlStateNormal];
    }
    isHaveHouse=NO;
    isHaveParking=NO;
    hAddresID=@"";
    power=@"";
    [self getHomeAddress];
    [self getParkingData];
}


#pragma mark ----------事件处理--------------
/**
 *  提交申请事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_SendInfo:(UIButton *)sender {
    
    [self sumbitData];
}

#pragma mark - 留言编辑时，改变事件

/**
 *  留言编辑时，改变事件
 *
 *  @param sender <#sender description#>
 */
#pragma mark ---- textView相关
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView.text.length <= 0) {
        self.ZG_PlaceHold.hidden = NO;
        self.ZG_SetMessage.backgroundColor = [UIColor clearColor];
    }else {
        self.ZG_PlaceHold.hidden = YES;
        self.ZG_SetMessage.backgroundColor = [UIColor whiteColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.ZG_PlaceHold.hidden = YES;
    self.ZG_PlaceHold.text = @"";
    self.ZG_SetMessage.backgroundColor = [UIColor whiteColor];
            
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > 50){
        //截取到最大位置的字符
        [self showToastMsg:@"最多可输入50个字" Duration:3.0f];
        NSString *s = [nsTextContent substringToIndex:50];
        [textView setText:s];
    }
            
}

#pragma mark - 来访姓名编辑时，改变事件

/**
 *  来访姓名编辑时，改变事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)TF_NameChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>8)
        {
            sender.text=[sender.text substringToIndex:8];
        }
    }

}
#pragma mark - 来访手机号编辑时，改变事件
/**
 *  来访手机号编辑时，改变事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)TF_PhoneChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(self.TF_Phone.text.length>11)
        {
            self.TF_Phone.text=[self.TF_Phone.text substringToIndex:11];
        }
    }

}

#pragma mark - 打开通讯录，获取联系人

/**
 *  打开通讯录，获取联系人
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_AddresBook:(UIButton *)sender {
    
    if (accessGranted) {
        if (IOS9_OR_LATER) {
            
            CNContactPickerViewController *contactVC = [[CNContactPickerViewController alloc] init];
            
            contactVC.delegate = self;
            
            [self presentViewController:contactVC animated:YES completion:nil];
            
        }else {
            
            ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
            nav.peoplePickerDelegate = self;
            if(IOS8_OR_LATER){
                nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
            }
            nav.navigationBar.tintColor = [UIColor whiteColor];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }else {
        [self showToastMsg:@"您的通讯录没有开启授权" Duration:3.0];
    }
    
}

//通讯录授权
- (BOOL)accessTheAddress
{
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    accessGranted = NO;
    
    if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusNotDetermined){
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
            accessGranted = granted;
            
            if (error){
                
                NSLog(@"Error: %@", (__bridge NSError *)error);
            }
            else if (!granted)
            {
                
            }
            else
            {
                accessGranted = YES;
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusAuthorized){
        accessGranted=YES;
    }
    else
    {
        NSLog(@"用户未授权提示");
        [self showToastMsg:@"您的通讯录没有开启授权" Duration:3.0];
    }
    return accessGranted;
}

#pragma mark - 右上角去往访客列表

/**
 *  去往访客列表
 *
 *  @param sender <#sender description#>
 */
- (IBAction)rightBarButtonClick:(id)sender {
    
    LS_VistorListVC * lsVC = [[LS_VistorListVC alloc]init];
    [self.navigationController pushViewController:lsVC animated:YES];
}

#pragma mark - 选择进小区权限

/**
 *  选择进小区权限
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_IntoVillageEvent:(UIButton *)sender {
    self.btn_IntoVillage.selected=!self.btn_IntoVillage.selected;
    if(self.btn_IntoVillage.selected)
    {
        ///社区_访客通行_权限进程_已选中 社区_访客通行_权限进程_未选中
        //[self.btn_IntoVillage setImage:[UIImage imageNamed:@"社区_访客通行_权限进程_已选中"] forState:UIControlStateNormal];
        [self.btn_IntoVillage.layer setBorderWidth:1];
        [self.btn_IntoVillage.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
        power=@"0";
    }
    else
    {
        //[self.btn_IntoVillage setImage:[UIImage imageNamed:@"社区_访客通行_权限进程_未选中"] forState:UIControlStateNormal];
        [self.btn_IntoVillage.layer setBorderWidth:1];
        [self.btn_IntoVillage.layer setBorderColor:CGColorRetain(TITLE_TEXT_COLOR.CGColor)];
        
        
        power=@"";
        self.btn_IntoElevator.selected=NO;
        self.btn_IntoUnitGate.selected=NO;
    }
    
    [self.btn_IntoElevator.layer setBorderWidth:1];
    [self.btn_IntoElevator.layer setBorderColor:CGColorRetain(TITLE_TEXT_COLOR.CGColor)];
    
    [self.btn_IntoUnitGate.layer setBorderWidth:1];
    [self.btn_IntoUnitGate.layer setBorderColor:CGColorRetain(TITLE_TEXT_COLOR.CGColor)];
//    [self.btn_IntoUnitGate setImage:[UIImage imageNamed:@"社区_访客通行_权限进程_未选中"] forState:UIControlStateNormal];
//    [self.btn_IntoElevator setImage:[UIImage imageNamed:@"社区_访客通行_权限进程_未选中"] forState:UIControlStateNormal];
}

#pragma mark - 选择进单元门权限，同时默认选中进小区权限

/**
 *  选择进单元门权限，同时默认选中进小区权限
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_IntoUnitGateEvent:(UIButton *)sender {
    self.btn_IntoUnitGate.selected=!self.btn_IntoUnitGate.selected;
    if(self.btn_IntoUnitGate.selected)
    {
        self.btn_IntoVillage.selected=YES;
//        [self.btn_IntoVillage setImage:[UIImage imageNamed:@"社区_访客通行_权限进程_已选中"] forState:UIControlStateNormal];
//        [self.btn_IntoUnitGate setImage:[UIImage imageNamed:@"社区_访客通行_权限进程_已选中"] forState:UIControlStateNormal];
        [self.btn_IntoVillage.layer setBorderWidth:1];
        [self.btn_IntoVillage.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
        
        [self.btn_IntoUnitGate.layer setBorderWidth:1];
        [self.btn_IntoUnitGate.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
        power=@"1";
    }
    else
    {
        
        self.btn_IntoElevator.selected=NO;
//        [self.btn_IntoUnitGate setImage:[UIImage imageNamed:@"社区_访客通行_权限进程_未选中"] forState:UIControlStateNormal];
        [self.self.btn_IntoUnitGate.layer setBorderWidth:1];
        [self.self.btn_IntoUnitGate.layer setBorderColor:CGColorRetain(TITLE_TEXT_COLOR.CGColor)];
        
        power=@"0";
    }

//    [self.btn_IntoElevator setImage:[UIImage imageNamed:@"社区_访客通行_权限进程_未选中"] forState:UIControlStateNormal];
    [self.self.self.btn_IntoElevator.layer setBorderWidth:1];
    [self.self.self.btn_IntoElevator.layer setBorderColor:CGColorRetain(TITLE_TEXT_COLOR.CGColor)];
    
}

#pragma mark - 选择进电梯权限 同时默认选择进单元门权限和进小区权限

/**
 *  选择进电梯权限 同时默认选择进单元门权限和进小区权限
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_IntoElevatorEvent:(UIButton *)sender {
    
    self.btn_IntoElevator.selected=!self.btn_IntoElevator.selected;
    if(self.btn_IntoElevator.selected)
    {
        self.btn_IntoVillage.selected=YES;
        self.btn_IntoUnitGate.selected=YES;
//        [self.btn_IntoVillage setImage:[UIImage imageNamed:@"社区_访客通行_权限进程_已选中"] forState:UIControlStateNormal];
//        [self.btn_IntoUnitGate setImage:[UIImage imageNamed:@"社区_访客通行_权限进程_已选中"] forState:UIControlStateNormal];
//        [self.btn_IntoElevator setImage:[UIImage imageNamed:@"社区_访客通行_权限进程_已选中"] forState:UIControlStateNormal];
        [self.btn_IntoVillage.layer setBorderWidth:1];
        [self.btn_IntoVillage.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
        
        [self.btn_IntoUnitGate.layer setBorderWidth:1];
        [self.btn_IntoUnitGate.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
        
        [self.self.btn_IntoElevator.layer setBorderWidth:1];
        [self.self.btn_IntoElevator.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
        power=@"2";
    }
    else
    {
//        [self.btn_IntoElevator setImage:[UIImage imageNamed:@"社区_访客通行_权限进程_未选中"] forState:UIControlStateNormal];
        [self.btn_IntoElevator.layer setBorderColor:CGColorRetain(TITLE_TEXT_COLOR.CGColor)];
        power=@"1";
    }
    
}

#pragma mark - 选择到访地址

/**
 *  选择到访地址
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_AddrsEvent:(UIButton *)sender {
    if(homeAddresArray==nil||homeAddresArray.count==0)
    {
        [self showToastMsg:@"没有找您的房产信息,请联系物业人员!" Duration:5.0];
        return;
    }
    NSInteger heigth= homeAddresArray.count>10?(SCREEN_HEIGHT/2):(homeAddresArray.count*50.0);
    PopListVC * popList=[PopListVC getInstance];
    popList.nsLay_TableHeigth.constant=heigth;
    @WeakObj(popList);
    [popList showVC:self listData:homeAddresArray cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        NSDictionary *devAddr;
        
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
        
        ///edit by ls 2017.7.7 添加物业费到期以后不允许业主 添加访客通行
        NSString * todateshow   = [NSString stringWithFormat:@"%@",[devAddr objectForKey:@"todateshow"]];
        
        NSString * istodateshow = [NSString stringWithFormat:@"%@",[devAddr objectForKey:@"istodateshow"]];
        
        if(hAddresID!=nil&&hAddresID.length>0&&!istodateshow.boolValue)
        {
            self.v_Authorized.hidden=NO;
            self.nsLay_AuthorzedHeight.constant=55;
            self.view_QXBg.hidden=NO;
            self.nsLay_QXBgHeight.constant=135;
            self.ZG_msgLayout.constant = 10;
            self.v_Phone.hidden=NO;
            self.nsLay_phoneHeight.constant=55;
            
            power = @"2";
        }else
        {
            ///edit by ls 2017.7.7 添加物业费到期以后不允许业主 添加访客通行
            ///物业费到期后弹框
            [self showToastMsg:todateshow Duration:5.0f];
            
            self.v_Authorized.hidden=YES;
            self.nsLay_AuthorzedHeight.constant= 0;

            self.view_QXBg.hidden=NO;
            self.nsLay_QXBgHeight.constant= 80;

            self.v_Phone.hidden=YES;
            self.nsLay_phoneHeight.constant=0;
            
            power = @"";
        }
        
        [popListWeak dismissVC];
        
        
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        UITableViewCell * cell=(UITableViewCell *)view;
        NSDictionary *devAddr=(NSDictionary *)data;;
        
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
        cell.textLabel.numberOfLines=0;
        
    }];
    
}
/**
 *  来访车牌后五位编辑时，改变事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)TF_CarNumLastChange:(UITextField *)sender {
    
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        
        if(sender.text.length>6)
        {
            sender.text=[sender.text substringToIndex:6];
        }else{
            
            NSString *infoText = sender.text;
            if (infoText.length > 0) {
                infoText = [infoText substringFromIndex:infoText.length - 1];
            }
            
            if ([infoText isEqualToString:@"o"] || [infoText isEqualToString:@"i"] || [infoText isEqualToString:@"O"] || [infoText isEqualToString:@"I"]) {
                
                sender.text = [sender.text substringToIndex:sender.text.length - 1];
                
                [self showToastMsg:@"根据国家法律法规，车牌号不允许添加O 或者 I" Duration:3.0];
            }
        }
    }
}
/**
 *  选择车牌第二位
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_CarNumSecondEvent:(UIButton *)sender {
    
    NSInteger heigth= [charArray count]>10?(SCREEN_HEIGHT/2):(charArray.count*50.0);
    PopListVC * popList=[PopListVC getInstance];
    popList.nsLay_TableHeigth.constant=heigth;
    @WeakObj(popList);
    [popList showVC:self listData:charArray cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        
        NSString *pstr =( NSString *)data;
        [sender setTitle:pstr forState:UIControlStateNormal];
        [popListWeak dismissVC];
        
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        UITableViewCell * cell=(UITableViewCell *)view;
        NSString *dic =( NSString *)data;
        cell.textLabel.text=dic;
        cell.textLabel.numberOfLines=0;
    }];

}
/**
 *  选择车牌第一位
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_CarNumFirstEvent:(UIButton *)sender {
    NSInteger heigth= [provinceArray count]>10?(SCREEN_HEIGHT/2):(provinceArray.count*50.0);
    PopListVC * popList=[PopListVC getInstance];
    popList.nsLay_TableHeigth.constant=heigth;
    @WeakObj(popList);
    [popList showVC:self listData:provinceArray cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        NSString *pstr =( NSString *)data;
        [sender setTitle:pstr forState:UIControlStateNormal];
        [popListWeak dismissVC];
        
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        UITableViewCell * cell=(UITableViewCell *)view;
        NSString *dic =( NSString *)data;
        cell.textLabel.text=dic;
        cell.textLabel.numberOfLines=0;
    }];

}
/**
 *  选择到访时间事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_DateEvent:(UIButton *)sender {
    
    MMDateView *dateView = [[MMDateView alloc]init];
    dateView.titleLabel.text=@"到访日期";
    dateView.datePicker.minimumDate = [NSDate date];
    [dateView show];
    dateView.confirm = ^(NSString *dataString) {
        NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",dataString] withFormat:@"yyyy/MM/dd"];
        selectDate = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
        [sender setTitle:selectDate forState:UIControlStateNormal];
  
    };

}

#pragma mark - 选中一个联系人属性
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    
    NSLog(@"contactProperty:%@",contactProperty);
    
    
    CNContact *contact = contactProperty.contact;
    CNPhoneNumber *phoneNumber = contactProperty.value;
    NSString *phoneNO = [NSString stringWithFormat:@"%@",phoneNumber.stringValue];
    
    for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
        
        CNPhoneNumber *phoneNumber = labeledValue.value;
        
        NSLog(@"phoneNumber==%@",phoneNumber.stringValue);
        
    }
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([RegularUtils isPhoneNum:phoneNO]) {
        self.TF_Name.text = @"";
        self.TF_Phone.text = @"";
        NSString *phoneNum = @"";
        NSString *peopleName = @"";
        
        phoneNum = [phoneNum stringByAppendingFormat:@"%@",phoneNO];
        if (![XYString isBlankString:contact.familyName]) {
            peopleName = [peopleName stringByAppendingFormat:@"%@",contact.familyName];
        }
        if (![XYString isBlankString:contact.givenName]) {
            peopleName = [peopleName stringByAppendingFormat:@"%@",contact.givenName];
        }
        
        if (peopleName.length > 4) {
            peopleName = [peopleName substringToIndex:4];
        }
        
        self.TF_Name.text = peopleName;
        self.TF_Phone.text = phoneNum;
                
    }else {
        [self showToastMsg:@"请选择手机号" Duration:2.0];
    }
    
}



#pragma mark -- ABPeoplePickerNavigationControllerDelegate-----
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    NSString * name = (NSString*)CFBridgingRelease(ABRecordCopyCompositeName(person));
    
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    //电话号码
    CFStringRef telValue = ABMultiValueCopyValueAtIndex(valuesRef,index);
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSString * phone=(__bridge NSString *)telValue;
        
        if ([phone hasPrefix:@"+86"]) {
            phone=[phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        }
        else if ([phone hasPrefix:@"86"]) {
            phone=[phone substringFromIndex:2];
        }
        else if ([phone containsString:@"-"]) {
            phone=[phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        self.TF_Name.text = name;
        self.TF_Phone.text = phone;
    }];
    
}



#pragma mark --------------网络事件------------------
///个人地址
-(void)getHomeAddress
{
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
//    @WeakObj(self);
    [CommunityManagerPresenters getUserResidenceUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
//                homeAddresArray=(NSArray *)data;
                
                NSDictionary * emptyDic = @{@"propertyname":@"",@"communityname":@"无",@"name":@"",@"builtuparea":@"",@"isinstall":@"",@"usearea":@"",@"expiretime":@"",@"id":@""};
                NSMutableArray * arr = [NSMutableArray arrayWithArray:data];
                [arr insertObject:emptyDic atIndex:0];
                homeAddresArray = arr;
                
                if(homeAddresArray!=nil||homeAddresArray.count>0)//显示房产选择
                {
                    _view_BgAddress.hidden=NO;
                    _nsLay_AddressBgHeigth.constant=55;
                    
                    self.addressLal.hidden = NO;
                    self.addLalTopHeight.constant = 15;
                    self.addLalHeight.constant = 15;
                    
                    isHaveHouse=YES;
                }
            }
            else
            {
                isHaveHouse=NO;
//                [selfWeak showToastMsg:@"获小区房产地址失败!" Duration:5.0];
            }
            
        });
        
    }];
}
///获取我的车位信息
-(void)getParkingData
{
    
    [self.service loadData];
    ParkingManagePresenter * parkingPresenter=[ParkingManagePresenter new];
    @WeakObj(self);
    [parkingPresenter getUserParkingareaForupDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultCode==SucceedCode)
            {
                NSDictionary * parking=(NSDictionary *)data;
                NSArray * citylist=[parking objectForKey:@"list"];
                NSArray * listdata=[ParkingModel mj_objectArrayWithKeyValuesArray:citylist];
                if(listdata!=nil&&listdata.count>0)//显示车牌输入
                {
                    _view_BgCarNum.hidden=NO;
                    _nsLay_CarNumBgHeigth.constant=55;
        
                    selfWeak.view_QXBg.hidden=NO;
                    selfWeak.nsLay_QXBgHeight.constant=90;
                    selfWeak.v_Phone.hidden=YES;
                    selfWeak.nsLay_phoneHeight.constant=0;
                    isHaveParking=YES;
                    self.carLal.hidden = NO;
                    self.carLalTopHeight.constant = 15;
                    self.carLalHeight.constant = 15;
                }
                
            }
            
        });
        
    }];
    
}

#pragma mark - 新车库获取车位接口
-(void)loadDataSuccess{
    
    if (self.service.personalCarportArray.count>0&&self.service.personalCarportArray!=nil) {
        isNewParking = YES;
        _view_BgCarNum.hidden=NO;
        _nsLay_CarNumBgHeigth.constant=55;
        self.view_QXBg.hidden=NO;
        self.nsLay_QXBgHeight.constant=90;
        self.v_Phone.hidden=YES;
        self.nsLay_phoneHeight.constant=0;
        isHaveParking=YES;
        self.carLal.hidden = NO;
        self.carLalTopHeight.constant = 15;
        self.carLalHeight.constant = 15;
    }
    
}
#pragma mark - 提交访客通行申请
///提交访客通行申请
-(void)sumbitData {
    
    if(!isHaveParking&&!isHaveHouse)
    {
        [self showToastMsg:@"您所在小区没有房产和可使用的车位，没有权限邀请访客哦~" Duration:5];
        return;
    }
    
   
    if(isHaveHouse&&isHaveParking)
    {
        
        carNum=[NSString stringWithFormat:@"%@%@%@",self.btn_CarNumFirst.titleLabel.text,self.btn_CarNumSecond.titleLabel.text,self.TF_CarNumLast.text];
        NSLog(@"carNum===%@",carNum);
        if(hAddresID.length==0&&![RegularUtils isCarNum:carNum])//验证手机号正确
        {
            [self showToastMsg:@"请先填写车牌或选择访问地址" Duration:5.0];
            return;
        }
    }
    
    if(isHaveParking)///车位
    {
        carNum=[NSString stringWithFormat:@"%@%@%@",self.btn_CarNumFirst.titleLabel.text,self.btn_CarNumSecond.titleLabel.text,self.TF_CarNumLast.text];
        NSLog(@"carNum===%@",carNum);
        
        if(hAddresID.length==0&&![RegularUtils isCarNum:carNum])//验证手机号正确
        {
            [self showToastMsg:@"车牌号格式不正确,请重新输入" Duration:5.0];
            return;
        }
        
        if(hAddresID==nil||hAddresID.length==0)
        {
            hAddresID=@"";
        }
        if(power==nil||power.length==0)
        {
            power=@"";
   
        }
    }
    if(isHaveHouse)///房产
    {
        if(![RegularUtils isCarNum:carNum])///没有添车牌
        {
            if(hAddresID.length==0)
            {
                [self showToastMsg:@"请选访问地址" Duration:5.0];
                return;
            }
        }
        ///选地址了
        if(hAddresID.length>0)
        {
            if(power.length==0)
            {
                [self showToastMsg:@"您还没有给访客门禁权限" Duration:5.0];
                return;
            }
            if(self.TF_Phone.text.length==0)
            {
                [self showToastMsg:@"您还没有填写访客手机号" Duration:5.0];
                return;
            }
            if(![RegularUtils isPhoneNum:self.TF_Phone.text])//验证手机号正确
            {
                [self showToastMsg:@"您输入的访客手机号不正确" Duration:5.0];
                return;
            }
            AppDelegate * appDlg=GetAppDelegates;
            if([self.TF_Phone.text isEqualToString:appDlg.userData.accPhone])
            {
                [self showToastMsg:@"不能给自己添加访客记录的权限" Duration:5.0];
                return;
            }
        }
    }

    if (![XYString isBlankString:self.TF_CarNumLast.text]) {
        
   
        if (![RegularUtils isCarNum:carNum]) {
            
            [self showToastMsg:@"车牌号格式不正确,请重新输入" Duration:5.0];
            return;
        }
    }
    
    
    if(carNum==nil||carNum.length<7)
    {
        carNum=@"";
    }
    NSString *leavemsg;
    if (![XYString isBlankString:self.ZG_SetMessage.text]) {
        
        
        NSString *str = self.ZG_SetMessage.text;
        NSMutableString *mutStr = [NSMutableString stringWithString:str];
        NSRange range = {0,str.length};
        [mutStr replaceOccurrencesOfString:@" " withString:@""options:NSLiteralSearch range:range];
        NSRange range2 = {0,mutStr.length};
        [mutStr replaceOccurrencesOfString:@"\n" withString:@""options:NSLiteralSearch range:range2];
        NSLog(@"%@",mutStr);
        leavemsg = mutStr;
        
    }else{
        leavemsg = @"";
    }
    
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    [UserTrafficPresenter addTrafficForResidenceid:hAddresID visitdate:selectDate card:carNum power:power visitname:self.TF_Name.text visitphone:self.TF_Phone.text leavemsg:leavemsg upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                if(resultCode==SucceedCode)
                {
                    NSDictionary * dic=(NSDictionary *)data;
                    //                VisitorCompleteVC *pmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"VisitorCompleteVC"];
                    //                pmvc.ID=[dic objectForKey:@"id"];
                    
                    LS_VistorDetailsVC * lsVC = [[LS_VistorDetailsVC alloc]init];
                    lsVC.vistorID =[dic objectForKey:@"id"];
                    
                    if([XYString isBlankString:lsVC.vistorID])
                    {
                        [self showToastMsg:@"返回数据不正确,请联系物业!" Duration:4];
                        return ;
                    }
                    lsVC.ls_type = @"0";
                    lsVC.gotoUrl = [dic objectForKey:@"gotourl"];
                    [self.navigationController pushViewController:lsVC animated:YES];
                    
                    
                }
                else
                {
                    [self showToastMsg:data Duration:5.0];
                }
                
            });
        
        }];


//    if(isNewParking) {
//        AppDelegate * appdel = GetAppDelegates;
//        NSDictionary * trafficInfo = @{
//                                       @"communityId":appdel.userData.communityid,
//                                       @"contacts":self.TF_Name.text?:@"",
//                                       @"sentence":leavemsg,
//                                       @"residenceid":hAddresID,
//                                       @"visitTime":selectDate,
//                                       @"carNo":carNum,
//                                       };
//        
//        [self.trafficService saveData:trafficInfo success:^(id responseObject) {
//            
//          
//        }failure:^(NSError *error) {
//         
//        
//        }];
//    }
    
    
}

@end
