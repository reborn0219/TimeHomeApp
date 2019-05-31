//
//  BluetoothRacklViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 16/9/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BluetoothRacklViewController.h"
#import "LiftUpRodBluetoothPresenter.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MessageAlert.h"
#import "UserUnitKeyModel.h"
#import "VehicleAlertVC.h"

@interface BluetoothRacklViewController ()<UIAlertViewDelegate>{
    
    CBCentralManagerState CBmanagerState;//蓝牙状态
    ///蓝牙处理
    LiftUpRodBluetoothPresenter * blueToothPresenter;
}

/**
 *  蓝牙状态
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_BluetoothState;
/**
 *  请求打开地址
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Addr;
/**
 *  抬杆设备
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_PassageType;
/**
 *  摇摇事件控件
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Shake;

@end

@implementation BluetoothRacklViewController

#pragma mark - extend method

-(void)configUI{
    
    blueToothPresenter=[LiftUpRodBluetoothPresenter new];
    blueToothPresenter.dataDict = self.dataDict;
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    [self.btn_Shake.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.btn_Shake.userInteractionEnabled = NO;
    self.btn_Addr.titleLabel.numberOfLines=3;
    [self.btn_PassageType.imageView setContentMode:UIViewContentModeScaleAspectFit];
    @WeakObj(self);
    ///蓝牙事件
    blueToothPresenter.blueToothBlock=^(id  _Nullable data,BluetoothCode bluetoothCode)
    {
        [selfWeak bluetoothEvent:data eventCode:bluetoothCode];
    };
    [self.btn_PassageType setImage:[UIImage imageNamed:@"摇摇通行_搜索设备"] forState:UIControlStateNormal];
    self.btn_Addr.hidden=YES;
}

#pragma mark - life cycle method

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (CBmanagerState == CBCentralManagerStatePoweredOn) {
        [blueToothPresenter startScanPeripherals];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (blueToothPresenter!=nil) {
        [blueToothPresenter discconnection];
    }
}

//摇一摇初始化
-(void) yaoYiYaoInit
{
    // 设置允许摇一摇功能
    //    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"sharke" ofType:@"wav"];
    //    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
}
//#pragma mark - 摇一摇相关方法
//// 摇一摇开始摇动
//- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    NSLog(@"开始摇动");
//    //    AudioServicesPlaySystemSound (soundID);
//    
//    [YYPlaySound playSoundWithResourceName:@"sharke" ofType:@"wav"];
//    
//    if (CBmanagerState == CBCentralManagerStatePoweredOn) {
//        [blueToothPresenter startScanPeripherals];
//        
//    }else{
//        MessageAlert * msgAlert=[MessageAlert shareMessageAlert];
//        msgAlert.isHiddLeftBtn=YES;
//        [msgAlert showInVC:self withTitle:@"蓝牙设备未打开,请先打开蓝牙!" andCancelBtnTitle:@"" andOtherBtnTitle:@"确认"];
//    }
//    
//    return;
//}
//
//// 摇一摇取消摇动
//- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    NSLog(@"取消摇动");
//    return;
//}
//
//// 摇一摇摇动结束
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
//        NSLog(@"摇动结束");
//        
//    }
//    return;
//}
//#pragma mark ----------事件--------------
/////摇一摇手动事件
//- (IBAction)btnShakeEvent:(UIButton *)sender {
//    
//    if (CBmanagerState == CBCentralManagerStatePoweredOn) {
//        [blueToothPresenter startScanPeripherals];
//        
//    }else{
//        MessageAlert * msgAlert=[MessageAlert shareMessageAlert];
//        msgAlert.isHiddLeftBtn = YES;
//        [msgAlert showInVC:self withTitle:@"蓝牙设备未打开,请先打开蓝牙!" andCancelBtnTitle:@"" andOtherBtnTitle:@"确认"];
//        
//    }
//}

#pragma mark ------------蓝牙事件处理-----------
- (void)bluetoothEvent:(id  _Nullable) data eventCode:(BluetoothCode) bluetoothCode
{
    switch (bluetoothCode) {
        case BluetoothState:///蓝牙状态
        {
            CBCentralManager *central=(CBCentralManager *)data;
            switch (central.state) {
                case CBCentralManagerStatePoweredOff:
                {
                    NSLog(@"关闭");
                    CBmanagerState = CBCentralManagerStatePoweredOff;
                    [self.btn_BluetoothState setImage:[UIImage imageNamed:@"摇摇通行_蓝牙开启"] forState:UIControlStateNormal];
                    [self.btn_BluetoothState setTitle:@"请开启您的蓝牙" forState:UIControlStateNormal];
                }
                    break;
                case CBCentralManagerStatePoweredOn:
                {
                    //                    NSLog(@"开启%ld",CBCentralManagerStatePoweredOn);
                    CBmanagerState = CBCentralManagerStatePoweredOn;
                    [self.btn_BluetoothState setImage:[UIImage imageNamed:@"摇摇通行_蓝牙关闭"] forState:UIControlStateNormal];
                    [self.btn_BluetoothState setTitle:@"开启" forState:UIControlStateNormal];
                    [blueToothPresenter startScanPeripherals];
                }
                case CBCentralManagerStateResetting:
                {
                    NSLog(@"重置");
                    
                }
                    break;
                case CBCentralManagerStateUnauthorized:
                {
                    NSLog(@"未经授权");
                }
                    break;
                case CBCentralManagerStateUnknown:
                {
                    NSLog(@"未知的");
                }
                    break;
                case CBCentralManagerStateUnsupported:
                {
                    NSLog(@"不支持的");
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        case NOAuthorize:///没有授权
        {
            [self.btn_PassageType setImage:[UIImage imageNamed:@"摇摇通行_搜索设备"] forState:UIControlStateNormal];
            [self.btn_PassageType setTitle:@"您没有操作设备的权限!" forState:UIControlStateNormal];
        }
            break;
        case SearchBluetooth:///开始搜索
        {
            [self.btn_PassageType setImage:[UIImage imageNamed:@"摇摇通行_搜索设备"] forState:UIControlStateNormal];
            [self.btn_PassageType setTitle:@"正在搜索设备..." forState:UIControlStateNormal];
        }
            break;
        case NoFindDev:///没有搜索到设备
        {
            @WeakObj(self);
            [self.btn_PassageType setImage:[UIImage imageNamed:@"摇摇通行_搜索设备"] forState:UIControlStateNormal];
            [self.btn_PassageType setTitle:@"没有搜索到设备!" forState:UIControlStateNormal];
            [selfWeak showToastMsg:@"没有搜索到设备!" Duration:3.0];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case DevInfo:///搜索到设备
        {
            NSDictionary * dic=(NSDictionary *)data;
            UserUnitKeyModel *UnitKey=[dic objectForKey:@"uukm"];
            self.btn_Addr.hidden=NO;
            [self.btn_Addr setTitle:UnitKey.name forState:UIControlStateNormal];
            [self.btn_PassageType setTitle:@"正在连接设备..." forState:UIControlStateNormal];

            [self.btn_PassageType setImage:[UIImage imageNamed:@"摇摇通行_搜索设备"] forState:UIControlStateNormal];//摇摇通行_门已打开_未搜索到
            
        }
            break;
        case DevNew:///回馈蓝牙的认证请求
        {
            //15701226635
            
            NSString *infoStr = [NSString stringWithFormat:@"FE01000E4E2100010A0208001200"];
            
            NSData *data1 = [self hexToBytes:infoStr];
            NSMutableData *blueData = [[NSMutableData alloc]init];
            [blueData appendData:data1];
            
            blueToothPresenter.wirteData = blueData;
            
            
        }
            break;
        case ConntectBluetooth:///连接蓝牙
        {
            [self.btn_PassageType setTitle:@"正在连接设备..." forState:UIControlStateNormal];
        }
            break;
        case autoOk:///回馈蓝牙的创建请求
        {
            [self.btn_PassageType setTitle:@"设备已连接" forState:UIControlStateNormal];
            
            NSString *infoStr = [NSString stringWithFormat:@"FE0100194E2300020A02080010B42418F8AC0120D1BBCABF07"];
            NSData *data1 = [self hexToBytes:infoStr];
            NSMutableData *blueData = [[NSMutableData alloc]init];
            [blueData appendData:data1];
            blueToothPresenter.wirteData = blueData;
            
        }
            break;
        case initOk://发送开门指令
        {
            [self.btn_PassageType setTitle:@"正在发送指令.." forState:UIControlStateNormal];
            NSString *infoStr = [NSString stringWithFormat:@"fe010029aabb00000a001219fecf0001001920010000000048656c6c6f2c5765436861742118914eaa"];
            NSData *data1 = [self hexToBytes:infoStr];
            
            NSMutableData *blueData = [[NSMutableData alloc]init];
            [blueData appendData:data1];
            blueToothPresenter.wirteData = blueData;
            
            [blueToothPresenter writeChar:blueData];
            //[self httpRequest];
        }
            break;
        case SendCommd:///发送指令
        {
            [self.btn_PassageType setTitle:@"正在发送指令..." forState:UIControlStateNormal];
        }
            break;
        case OpenOk:///发送成功
        {

            [self.btn_PassageType setImage:[UIImage imageNamed:@"摇摇通行_搜索设备"] forState:UIControlStateNormal];//摇摇通行_门已打开_已搜索到
            
            [self.btn_Shake setImage:[UIImage imageNamed:@"车库开闸-开闸图标"] forState:UIControlStateNormal];
            
            [self.btn_PassageType setTitle:data forState:UIControlStateNormal];
            

        }
            break;
        case OpenError:///连接打开失败
        {
            [self.btn_PassageType setTitle:data forState:UIControlStateNormal];
            VehicleAlertVC *alert = [[VehicleAlertVC alloc]init];
            [alert showithTitle:@"开闸失败请联系物业" viewcontroller:self ShowCancelBtn:NO isFault:YES];
            
            alert.block=^(NSInteger type){
                if (type == 1) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
        }
            break;
            
        default:
            break;
    }
}

-(NSData*) hexToBytes:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

@end
