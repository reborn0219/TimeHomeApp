//
//  AddCarController.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AddCarController.h"
#import "BindingCarVC.h"
#import "CarStewardFirstVC.h"
#import "PopListVC.h"
#import "QuartzCore/QuartzCore.h"

#import "CarBrandView.h"
#import "CarModelView.h"
#import "CarStyleView.h"
#import "GasolineTypeView.h"
#import "MessageAlert.h"

#import "ZSY_RightCarBrandVC.h"
#import "ZSY_GearbBoxesAlertVC.h"
#import "ZSY_CarModelCell.h"

#import "ZSY_transmissionVC.h"

#import "CarManagerPresenter.h"
#import "ZSY_FuelVC.h"
#import "LS_CarInfoModel.h"
#import "MessageAlert.h"
#import "UIButtonImageWithLable.h"
#import "RegularUtils.h"
#import "ModifyVehicleVC.h"
#import "QrCodeScanningVC.h"

#define  HHH self.view.frame.size.height
#define  WWW self.view.frame.size.width
#define W [UIScreen mainScreen].bounds.size.width*3/4

///限制输入框只能输入英文数字和.
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789."
///限制输入框只能输入英文和数字
#define CARFRAMNUMBER @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface AddCarController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,AVCaptureMetadataOutputObjectsDelegate,BackValueDelegate>
{
    ///省简称数组
    NSArray *provinceArray;
    ///字母数组
    NSMutableArray *charArray;

    ///变速箱数组
    NSMutableArray *gearboxesArr;
    NSString *gearboxesStr;
    NSString * first;
    NSString * second;
  
    NSString * Carnum;
    NSString * Remarks;
}

@property (nonatomic, assign)CGFloat temp;

@property(nonatomic,strong)CarBrandView *brand;
@property(nonatomic,strong)CarModelView *model;
@property(nonatomic,strong)CarStyleView *style;
@property(nonatomic,strong)GasolineTypeView *gasolineTypeView;
@property (nonatomic,assign)BOOL isYes;


@end

@implementation AddCarController

#pragma amrk  ----------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isYes = NO;
    self.navigationController.navigationBar.barTintColor = NABAR_COLOR;
    self.view.backgroundColor = BLACKGROUND_COLOR;
    _confirmButton.backgroundColor = PURPLE_COLOR;
    _carModel.backgroundColor = BLACKGROUND_COLOR;
    _carStyle.backgroundColor = BLACKGROUND_COLOR;
    _carNumber.delegate = self;
    
    [self createNotification];//通知中心
    [self createSrollView];   //ScrollView属性
    [self data];              //列表数据
    
    /**车牌地区选择按钮*/
    [self setButtonBorder];
    ///修改textfield边框色
    [self createTFLineColor];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":QiCheGuanJia}];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    self.navigationItem.title = @"添加汽车";
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:QiCheGuanJia];
//    ///判断从哪个界面跳转，做出处理
//    if (_from == add) {
//        NSLog(@"首页");
//        self.navigationItem.title = @"添加汽车";
//        
//        
//    }else if (_from == Modify) {
//        
//        NSLog(@"编辑");
//        self.navigationItem.title = @"编辑车辆";
//        @WeakObj(self);
//        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
//        [indicator startAnimating:self.tabBarController];
//        [CarManagerPresenter getCarInfoWithID:_carInfoModel.carID AndBlock:^(id  _Nullable data, ResultCode resultCode) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [indicator stopAnimating];
//                if(resultCode == SucceedCode)
//                {
//                    NSDictionary *dict = [data objectForKey:@"map"];
//                    
//                    //冀
//                    [selfWeak.regionButton setTitle:[[dict objectForKey:@"card"] substringWithRange:NSMakeRange(0, 1)] forState:UIControlStateNormal];
//                    //A
//                    [selfWeak.carFirstLetter setTitle:[[dict objectForKey:@"card"] substringWithRange:NSMakeRange(1, 1)] forState:UIControlStateNormal];
//                    
//                    //车牌号 12345
//                    selfWeak.carNumber.text = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"card"] substringWithRange:NSMakeRange(2, 5)]];
//                    //别名
//                    selfWeak.carOtherName.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"alias"]];
//                    
//                    if (_isYes == NO) {
//                        //车辆品牌
//                        selfWeak.carBrand.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"brandname"]];
//                        //车辆型号
//                        selfWeak.carModel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"seriesname"]];
//                        //车款
//                        selfWeak.carStyle.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"modelsname"]];
//                    }
//                    
//                    //排量
//                    selfWeak.carEmissions.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"displacement"]];
//                    //车架号
//                    selfWeak.carFrameNumber.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"chassisno"]];
//                    
//                    //变速箱
//                    NSString *carBox = [NSString stringWithFormat:@"%@",[dict objectForKey:@"gearbox"]];
//                    if ([carBox isEqualToString:@"AT"]) {
//                        
//                        selfWeak.carGearbox.text = [NSString stringWithFormat:@"%@(自动)",carBox];
//                    }else if ([carBox isEqualToString:@"MT"]) {
//            
//                        selfWeak.carGearbox.text = [NSString stringWithFormat:@"%@(手动)",carBox];
//                    }else if ([carBox isEqualToString:@"CVT"]) {
//                        
//                        selfWeak.carGearbox.text = [NSString stringWithFormat:@"%@(无极变速)",carBox];
//                    }else if ([carBox isEqualToString:@"DSG"]) {
//                        
//                        selfWeak.carGearbox.text = [NSString stringWithFormat:@"%@(双离合变速)",carBox];
//                    }else if ([carBox isEqualToString:@"AMT"]) {
//                        
//                        selfWeak.carGearbox.text = [NSString stringWithFormat:@"%@(序列变速箱)",carBox];
//                    }else {
//                        
//                        selfWeak.carGearbox.text = [NSString stringWithFormat:@"%@",carBox];
//                    }
//                    
//                    //燃油类型
//                    
//                    NSString *fuelType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fueltype"]];
//                    if ([fuelType isEqualToString:@"0"]) {
//                        selfWeak.gasolineType.text = @"柴油";
//                    }else {
//                        
//                        selfWeak.gasolineType.text = [NSString stringWithFormat:@"%@#",[dict objectForKey:@"fueltype"]];
//                        
//                    }
//
//                    if (_brandID != nil && _modelID != nil && _stytleID != nil ) {
//                        
//                    }else {
//                        _brandID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"brandid"]];
//                        _modelID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"modelsid"]];
//                        _stytleID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"seriesid"]];
//                        
//                        
//                    }
//                    _engineno = [NSString stringWithFormat:@"%@",[dict objectForKey:@"engineno"]];
//                    
//                    
//                }else {
//                    [selfWeak showToastMsg:@"网络连接错误" Duration:3.0];
//                }
//                
//            });
//            
//        }];
//    }
    

}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

/**
 *  结束编辑
 */
- (void)endEditingInTheView {
    
    [_carNumber resignFirstResponder];
//    [_carOtherName resignFirstResponder];
//    [_carEmissions resignFirstResponder];
//    [_carFrameNumber resignFirstResponder];
}



#pragma mark - 设置textfield边框颜色
-(void)createTFLineColor
{

    _carNumber.layer.borderColor = UIColorFromRGB(0xA7A7A7).CGColor;
    _carNumber.layer.borderWidth = 1.0f;
    
    _deviceBackV.layer.borderColor = UIColorFromRGB(0xA7A7A7).CGColor;
    _deviceBackV.layer.borderWidth = 1.0f;

    _carBrand.layer.borderColor = UIColorFromRGB(0xA7A7A7).CGColor;
    _carBrand.layer.borderWidth = 1.0f;

    _carModel.layer.borderColor = UIColorFromRGB(0xA7A7A7).CGColor;
    _carModel.layer.borderWidth = 1.0f;

    _carStyle.layer.borderColor = UIColorFromRGB(0xA7A7A7).CGColor;
    _carStyle.layer.borderWidth = 1.0f;
//
//    _carEmissions.layer.borderColor = UIColorFromRGB(0xA7A7A7).CGColor;
//    _carEmissions.layer.borderWidth = 1.0f;
//
//    _carGearbox.layer.borderColor = UIColorFromRGB(0xA7A7A7).CGColor;
//    _carGearbox.layer.borderWidth = 1.0f;
//
//    _gasolineType.layer.borderColor = UIColorFromRGB(0xA7A7A7).CGColor;
//    _gasolineType.layer.borderWidth = 1.0f;
//
//    _carFrameNumber.layer.borderColor = UIColorFromRGB(0xA7A7A7).CGColor;
//    _carFrameNumber.layer.borderWidth = 1.0f;
    
    //textfield禁止编辑
    _carModel.userInteractionEnabled = NO;
    _carStyle.userInteractionEnabled = NO;
    _carBrand.userInteractionEnabled = NO;
    

}

/** 按钮边框 */
- (void)setButtonBorder {
    
    _regionButton.layer.masksToBounds =YES;
    _regionButton.layer.borderColor = (UIColorFromRGB(0x949494)).CGColor;
    
    _regionButton.layer.borderWidth = 1.0f;
    _regionTriangleButton.layer.masksToBounds =YES;
    _regionTriangleButton.layer.borderColor = (UIColorFromRGB(0x949494)).CGColor;
    _regionTriangleButton.layer.borderWidth = 1.0f;
    
    
    _carFirstLetter.layer.masksToBounds =YES;
    _carFirstLetter.layer.borderColor = (UIColorFromRGB(0x949494)).CGColor;
    _carFirstLetter.layer.borderWidth = 1.0f;
    
    _carFirstTriangleButton.layer.masksToBounds =YES;
    _carFirstTriangleButton.layer.borderColor = (UIColorFromRGB(0x949494)).CGColor;
    _carFirstTriangleButton.layer.borderWidth = 1.0f;
    
}



#pragma mark --  create ScrollView
- (void)createSrollView {
    
    if (SCREEN_WIDTH <= 320) {
        _scrollView.sd_layout.topSpaceToView(self.view,8).leftSpaceToView(self.view,8).rightSpaceToView(self.view,8).bottomSpaceToView(self.view,8);
        _bgView.sd_layout.topEqualToView(_scrollView).leftEqualToView(_scrollView).rightEqualToView(_scrollView).heightIs(580);
    }

}


#pragma mark -- 注册观察者
- (void)createNotification {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(notifi:) name:nil object:nil];
    
}

///通知事件处理
- (void)notifi:(NSNotification *)sender {
    
    
//     noti.object, noti.userInfo, noti.name
    if ([sender.name isEqualToString:@"T1"]) {
        _isYes = YES;
        _carBrand.text = [sender.userInfo objectForKey:@"1"];
        NSLog(@"%@",sender.name);
    }else if([sender.name isEqualToString:@"T2"]) {
        
        _carModel.text = [sender.userInfo objectForKey:@"1"];
        NSLog(@"%@",sender.name);
    }else if([sender.name isEqualToString:@"T3"]) {
        
        _carStyle.text = [sender.userInfo objectForKey:@"1"];
    }else if([sender.name isEqualToString:@"T4"]) {
        
//        _gasolineType.text = [sender.userInfo objectForKey:@"1"];
//        [_gesturesView removeFromSuperview];
//        
//        if ([[sender.userInfo objectForKey:@"2"] isEqualToString:@"YES"]) {
//            
//        }
        
    }

}

#pragma amrk -- 按钮点击事件
//确认按钮点击事件
- (IBAction)buttonClick:(id)sender {

    NSString *carNumberStr = [NSString stringWithFormat:@"%@%@%@",_regionButton.titleLabel.text,_carFirstLetter.titleLabel.text,_carNumber.text];
    
    [self endEditingInTheView];
    
    if (_carNumber.text.length == 0 ) {
        
        [self showToastMsg:@"车牌号不能为空" Duration:3.0];
        
        return;
        
    }else if (_carNumber.text.length < 5) {
        
        [self showToastMsg:@"车牌号不能少于5位" Duration:3.0];
        return;

        
    }else if (![RegularUtils isCarNum:carNumberStr]) {
        [self showToastMsg:@"输入车牌格式不正确" Duration:3.0f];
        return;
    
    }else if (_carBrand.text.length == 0) {
        
        [self showToastMsg:@"车辆品牌不能为空" Duration:3.0];

        return;
        
    }else if (_carModel.text.length == 0) {
        
        [self showToastMsg:@"车辆型号不能为空" Duration:3.0];

        return;
        
        
    }else if (_carStyle.text.length == 0) {
        
        [self showToastMsg:@"车款不能为空" Duration:3.0];

        return;
        
    }else if(self.Car_No_TF.text.length == 0){
    
        [self showToastMsg:@"请填写设备编码！" Duration:3.0];
        
        return;
        
    }else {
        
        if (_brandID.length != 0 && _modelID.length != 0 && _stytleID.length != 0) {
            
            
            //车牌号处理
            NSString *str = _regionButton.titleLabel.text;
            NSString *str2 = _carFirstLetter.titleLabel.text;
            NSString *str3 = [NSString stringWithFormat:@"%@%@%@",str,str2,_carNumber.text];
            
            //_brandID  车牌ID
            //_modelID  车辆型号ID
            //_stytleID 车款ID
            //deviceno  设备编号
            //页面请求判断
            NSDictionary *dic = @{
                                  
                                  @"card":str3,
                                  @"brandid":_brandID,
                                  @"seriesid":_modelID,
                                  @"modelsid":_stytleID,
                                  @"deviceno":_Car_No_TF.text
                                  
                                  };
            
            @WeakObj(self);
            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
            [indicator startAnimating:self.tabBarController];
            
            [CarManagerPresenter addCarWithParameter:dic AndBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [indicator stopAnimating];
                        
                        if(resultCode == SucceedCode) {
                            NSDictionary *dict = (NSDictionary *)data;
                            NSLog(@"添加车辆成功");
                            BindingCarVC *bin = [[BindingCarVC alloc] initWithNibName:@"BindingCarVC" bundle:nil];
                            bin.carNameStr = str3;
                            bin.carOtherNameStr = @"车款";
                            bin.uCarID = [NSString stringWithFormat:@"%@",dict[@"id"]];
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }else {
                            if ([data isKindOfClass:[NSString class]]) {
                                if (![XYString isBlankString:data]) {
                                    [selfWeak showToastMsg:data Duration:3.0];
                                }else {
                                    [selfWeak showToastMsg:@"网络连接错误" Duration:3.0];
                                }
                            }
                        }
                        
                        
                    });
                    
            }];

                
        }
    
    }
}
#pragma mark -- 下拉列表
/** 列表数据 */
- (void)data {
    //变速箱数组
    gearboxesArr = [NSMutableArray new];
    for (int i = 0; i < 100; i++) {
        
        [gearboxesArr addObject:[NSString stringWithFormat:@"变速箱型号:%d",i]];
    }

    ///省简称
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
    provinceArray = [NSArray arrayWithContentsOfFile:path];
    ///26大写字母
    charArray=[NSMutableArray new];
    for (int i = 0; i < 26; i++) {
        NSString *cityKey = [NSString stringWithFormat:@"%c",i+65];
        [charArray addObject:cityKey];
    }
    first=[provinceArray objectAtIndex:0];
    second=[charArray objectAtIndex:0];
    AppDelegate * appDlt=GetAppDelegates;
    if(![XYString isBlankString:appDlt.userData.carprefix]&&appDlt.userData.carprefix.length>=2)
    {
        NSString * tmp1=[appDlt.userData.carprefix substringToIndex:1];
        NSRange range= NSMakeRange(1,1);
        NSString * tmp2=[appDlt.userData.carprefix substringWithRange:range];
        
        first=tmp1;
        second=tmp2;
        [_regionButton setTitle:tmp1 forState:UIControlStateNormal];
        [_carFirstLetter setTitle:tmp2 forState:UIControlStateNormal];
    }

}

/**车牌地区选择按钮 */
- (IBAction)carRegion:(id)sender {
    
    
    [self endEditingInTheView];
    NSInteger heigth= [provinceArray count]>10?(SCREEN_HEIGHT/2):(provinceArray.count*50.0);
    PopListVC * popList=[PopListVC getInstance];
    popList.nsLay_TableHeigth.constant=heigth;
    @WeakObj(popList);
    [popList showVC:self listData:provinceArray cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        NSString *pstr =( NSString *)data;
        [_regionButton setTitle:pstr forState:UIControlStateNormal];
        first=pstr;
        [popListWeak dismissVC];
        
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        UITableViewCell * cell=(UITableViewCell *)view;
        NSString *dic =( NSString *)data;
        cell.textLabel.text=dic;
        cell.textLabel.numberOfLines=0;
    }];

    
}

/**车牌首字母*/
- (IBAction)carFirstLetter:(id)sender {
    
    [self endEditingInTheView];
    
    NSInteger heigth= [charArray count]>10?(SCREEN_HEIGHT/2):(charArray.count*50.0);
    PopListVC * popList=[PopListVC getInstance];
    popList.nsLay_TableHeigth.constant=heigth;
    @WeakObj(popList);
    [popList showVC:self listData:charArray cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        NSString *pstr =( NSString *)data;
        [_carFirstLetter setTitle:pstr forState:UIControlStateNormal];
        second=pstr;
        [popListWeak dismissVC];
        
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        UITableViewCell * cell=(UITableViewCell *)view;
        NSString *dic =( NSString *)data;
        cell.textLabel.text=dic;
        cell.textLabel.numberOfLines=0;
    }];

    
}


#pragma mark -- 弹出右边view
/**弹出右视图*/
- (IBAction)pushButtonClcik:(UIButton *)sender {
    
    [self endEditingInTheView];

    //品牌
    if (sender.tag == 31) {
        ZSY_RightCarBrandVC *rightVC = [[ZSY_RightCarBrandVC alloc] init];
        [self.navigationController pushViewController:rightVC animated:YES];
    }
    
//    //变速箱
//    if (sender.tag == 35) {
//        
//        ZSY_transmissionVC *transmission = [ZSY_transmissionVC getInstance];
//        @WeakObj(transmission);
//        [transmission showInVC:self andBlcok:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
//            
//            
//            NSString *dic =( NSString *)data;
////            _carGearbox.text = dic;
//            [transmissionWeak dismiss];
//            
//        }];
//        
//        if (sender.tag == 111) {
//            NSLog(@"1");
//        }
//
//    }
    
}

#pragma mark -- 输入框的输入判断
/**
 * 输入框的输入判断
 **/
- (IBAction)textFieldClick:(UITextField *)sender {
    
    UITextRange * selectedRange = sender.markedTextRange;
    if (sender.tag == 1) {
        
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length > 5)
            {
                
                [self showToastMsg:@"不能超过5个字符" Duration:3.0];
                sender.text=[sender.text substringToIndex:5];
                
                
            }
        }
    } else if (sender.tag == 2) {
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length > 10)
            {
                [self showToastMsg:@"不能超过10个字符" Duration:3.0];
                sender.text=[sender.text substringToIndex:10];
                
            }
        }
        
    }else if (sender.tag == 9) {
        
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length > 6)
            {
                [self showToastMsg:@"不能超过6个字符" Duration:3.0];
                sender.text=[sender.text substringToIndex:6];
                
            }
        }
        
        
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:CARFRAMNUMBER]invertedSet];
        
        NSString *filtered = [[sender.text componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        if ([sender.text isEqualToString:filtered]) {
            
            NSLog(@"正确");
            
        }else {
            [self showToastMsg:@"只能输入英文和数字" Duration:3.0];
            sender.text = @"";
        }

        

    }else if (sender.tag == 6) {
        
        
        if(sender.text.length > 5)
        {
            
            [self showToastMsg:@"不能超过5个字符" Duration:3.0];
            sender.text=[sender.text substringToIndex:5];
            
            
        }

        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum]invertedSet];
        NSString *filtered = [[sender.text componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        if ([sender.text isEqualToString:filtered]) {
            NSLog(@"输入正确");
        }else {
            [self showToastMsg:@"只能输入英文、数字和.(例如2.0T)" Duration:3.0];
            sender.text = @"";
        }
        
    }else if (sender.tag == 9) {
        
    }
}

- (IBAction)scanningAction:(id)sender {
    
    if (![self canOpenCamera]) {
        return;
    }
    
    QrCodeScanningVC * QrCodeVc=[[QrCodeScanningVC alloc]init];
    QrCodeVc.delegate=self;
    [self.navigationController pushViewController:QrCodeVc animated:YES];
    
    NSLog(@"扫描");

    
}
#pragma mark - 扫描回调

-(void)backValue:(NSString *)value
{
    self.Car_No_TF.text=value;
}

@end
