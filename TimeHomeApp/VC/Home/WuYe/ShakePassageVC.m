//
//  ShakePassageVC.m
//  TimeHomeApp
//
//  Created by us on 16/2/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ShakePassageVC.h"
#import "BluetoothPresenter.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MessageAlert.h"
#import "UserUnitKeyModel.h"
#import "CommunityManagerPresenters.h"

#import "PushMsgModel.h"
#import "WebViewVC.h"
#import "RaiN_VoucherDetailsVC.h"
#import "RaiN_RedPacketDetails.h"
#import "RedPacketPresenters.h"

//红包
#import "PARedBagView.h"
#import "PARedBagDetailViewController.h"
#import "PAVoucherTableViewController.h"
#import "PARedBagPresenter.h"


@interface ShakePassageVC ()
{
    SystemSoundID soundID;//声音
    CBCentralManagerState CBmanagerState;//蓝牙状态
    ///蓝牙处理
    BluetoothPresenter * blueToothPresenter;
    ///设备数据
    UserUnitKeyModel * userUnitKey;
    
    THIndicatorVC * indicator;
    
    NSDictionary *dict;
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
 *  开门或电梯
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_PassageType;
/**
 *  摇摇事件控件
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Shake;
@end

@implementation ShakePassageVC

#pragma mark - 使用说明

- (IBAction)howToUseClick:(UIButton *)sender {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.url = [NSString stringWithFormat:@"%@/20170906/shakeThrough.html",kH5_SEVER_URL];
    webVc.title=@"摇摇通行使用说明";
    [self.navigationController pushViewController:webVc animated:YES];
    
}


#pragma mark - blueTooth method

-(void)getBlueToothCompetence:(NSString *)areaID{
    
    @WeakObj(self);
    [CommunityManagerPresenters getLiftBlueToothWithAreaID:areaID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode==SucceedCode)
            {
                dict = (NSDictionary *)data;
                NSArray* dataArr = dict[@"cityListData"];
                NSLog(@"%@",dataArr);
                [blueToothPresenter startScanPeripherals:dataArr];

            }
            else if(resultCode==FailureCode)
            {
                [selfWeak showToastMsg:@"获取权限失败" Duration:3.0];
            }
            else if(resultCode==NONetWorkCode)//无网络处理
            {
                [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"链接失败，请检查网络!" eventCallBack:nil];

            }
        });
    }];
}

-(void)getBlueToothOK:(NSString *)pid{
    
    @WeakObj(self);
    [CommunityManagerPresenters getLiftBlueToothWithPid:pid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode==SucceedCode)
            {
                //[self showToastMsg:@"成功" Duration:3.0];
            }
            else if(resultCode==FailureCode)
            {
                [selfWeak showToastMsg:data Duration:3.0];
            }
            else if(resultCode==NONetWorkCode)//无网络处理
            {
                [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"链接失败，请检查网络!" eventCallBack:nil];

            }
        });
    }];
}

#pragma mark - life cycle method

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    if(self.isStart)
    {
        if (CBmanagerState == IOS10_OR_LATER?CBManagerStatePoweredOn:CBCentralManagerStatePoweredOn) {
            
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    [TalkingData trackPageBegin:@"yaoyaotongxing"];

    AppDelegate *appdelegate = GetAppDelegates;
    ///数据统计
    [appdelegate markStatistics:YaoYaoTongXing];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.isStart){
        
        if (CBmanagerState == IOS10_OR_LATER?CBManagerStatePoweredOn:CBCentralManagerStatePoweredOn){
            
            [blueToothPresenter startScanPeripherals];
            
        }else{
            
            MessageAlert * msgAlert=[MessageAlert shareMessageAlert];
            msgAlert.isHiddLeftBtn=YES;
            [msgAlert showInVC:self withTitle:@"蓝牙设备未打开,请先打开蓝牙!" andCancelBtnTitle:@"" andOtherBtnTitle:@"确认"];
            
        }
        
    }
    self.isStart = NO;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
//    [TalkingData trackPageEnd:@"yaoyaotongxing"];

    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":YaoYaoTongXing}];
    if (blueToothPresenter!=nil) {
        [blueToothPresenter discconnection];
    }
}


#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView {
    
    blueToothPresenter=[BluetoothPresenter new];
//    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    [self.btn_Shake.imageView setContentMode:UIViewContentModeScaleAspectFit];
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
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"sharke" ofType:@"wav"];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    
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
#pragma mark - 摇一摇相关方法
// 摇一摇开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");

    [YYPlaySound playSoundWithResourceName:@"sharke" ofType:@"wav"];

    if (CBmanagerState == IOS10_OR_LATER?CBManagerStatePoweredOn:CBCentralManagerStatePoweredOn) {
    
        [blueToothPresenter startScanPeripherals];
        
    }else{
        MessageAlert * msgAlert=[MessageAlert shareMessageAlert];
        msgAlert.isHiddLeftBtn=YES;
        [msgAlert showInVC:self withTitle:@"蓝牙设备未打开,请先打开蓝牙!" andCancelBtnTitle:@"" andOtherBtnTitle:@"确认"];
    }
    
    return;
}

// 摇一摇取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    return;
}

// 摇一摇摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
        
    }
    return;
}

#pragma mark ----------事件--------------
///摇一摇手动事件
- (IBAction)btnShakeEvent:(UIButton *)sender {
    
    
    if (CBmanagerState == CBCentralManagerStatePoweredOn) {
        
       [blueToothPresenter startScanPeripherals];
        
    }else{
        MessageAlert * msgAlert=[MessageAlert shareMessageAlert];
        msgAlert.isHiddLeftBtn = YES;
        [msgAlert showInVC:self withTitle:@"蓝牙设备未打开,请先打开蓝牙!" andCancelBtnTitle:@"" andOtherBtnTitle:@"确认"];

    }
}

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
                    [self.btn_BluetoothState setTitle:@"关闭" forState:UIControlStateNormal];
                }
                    break;
                case CBCentralManagerStatePoweredOn:
                {
//                    NSLog(@"开启%ld",CBCentralManagerStatePoweredOn);
                    CBmanagerState = CBCentralManagerStatePoweredOn;
                    [self.btn_BluetoothState setImage:[UIImage imageNamed:@"摇摇通行_蓝牙关闭"] forState:UIControlStateNormal];
                    [self.btn_BluetoothState setTitle:@"开启" forState:UIControlStateNormal];
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
        case advertisementOk://收到广播信号
        {
            NSString * areaID = (NSString *)data;
            [self.btn_PassageType setTitle:@"获取定位信息..." forState:UIControlStateNormal];
            [self showToastMsg:areaID Duration:2.0];
            [self getBlueToothCompetence:areaID];
        }
            break;
            case NoFindDev:///没有搜索到设备
        {
            [self.btn_PassageType setImage:[UIImage imageNamed:@"摇摇通行_搜索设备"] forState:UIControlStateNormal];
            [self.btn_PassageType setTitle:@"没有搜索到设备!" forState:UIControlStateNormal];
        }
            break;
        case DevInfo:///搜索到设备
        {
            NSDictionary * dic=(NSDictionary *)data;
            userUnitKey=[dic objectForKey:@"uukm"];
            self.btn_Addr.hidden=NO;
            [self.btn_Addr setTitle:userUnitKey.name forState:UIControlStateNormal];
            // type	蓝牙类型：1 社区大门 2 单元门 3 电梯
            [self.btn_PassageType setTitle:@"正在连接设备..." forState:UIControlStateNormal];
            if([userUnitKey.type intValue]==1)
            {
                [self.btn_PassageType setImage:[UIImage imageNamed:@"摇摇通行_门已打开_未搜索到"] forState:UIControlStateNormal];
                
            }
            else if ([userUnitKey.type intValue]==2)
            {
                [self.btn_PassageType setImage:[UIImage imageNamed:@"摇摇通行_门已打开_未搜索到"] forState:UIControlStateNormal];
            }
            else if ([userUnitKey.type intValue]==3)
            {
                [self.btn_PassageType setImage:[UIImage imageNamed:@"摇摇通行_请按楼层_未搜索到"] forState:UIControlStateNormal];
            }
            
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
        case ConntectBluetooth:
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
            
        case SendTest:
        {
            [self showToastMsg:data Duration:1];
        }
            break;
        case OpenOk:///发送成功
        {
            [UIView animateWithDuration:1.5 animations:^{
                if([userUnitKey.type intValue]==1)
                {
                    [self.btn_PassageType setImage:[UIImage imageNamed:@"摇摇通行_门已打开_已搜索到"] forState:UIControlStateNormal];
                    
                }
                else if ([userUnitKey.type intValue]==2)
                {
                    [self.btn_PassageType setImage:[UIImage imageNamed:@"摇摇通行_门已打开_已搜索到"] forState:UIControlStateNormal];
                }
                else if ([userUnitKey.type intValue]==3)
                {
                    [self.btn_PassageType setImage:[UIImage imageNamed:@"摇摇通行_请按楼层_已搜索到"] forState:UIControlStateNormal];
                    //[self getBlueToothOK:dict[@"pid"]];
                }
                [self.btn_PassageType setTitle:data forState:UIControlStateNormal];
                
                self.btn_Addr.alpha = 0.95;
                
            } completion:^(BOOL finished) {
                ////返回上一页逻辑取消（摇摇红包功能）
                if([userUnitKey.type intValue]==1)
                {
                   
                }
                else if ([userUnitKey.type intValue]==2)
                {
                   
                }
                else if ([userUnitKey.type intValue]==3)
                {
                  
                    //[self getBlueToothOK:dict[@"pid"]];
                }
            }];
            
            NSString *nameStr = userUnitKey.bluename;
            
            NSArray *tempArr = [UserDefaultsStorage getDataforKey:@"UserUnitKeyArray"];
            NSString *communityidStr = @"";
            for (int i = 0; i < tempArr.count; i++) {
                UserUnitKeyModel *model1 = tempArr[i];
                if ([model1.bluename isEqualToString:nameStr]) {
                    communityidStr = model1.communityid;
                    break;
                }
            }
            
            AppDelegate *appDelegate = GetAppDelegates;
            
            if(appDelegate.userData.isLogIn.boolValue){
                [self openDoorRedPacketNetWithCommunityid:communityidStr];//获取红包
            }            
            
        }
            break;
        case OpenError:///连接打开失败
        {
            [self.btn_PassageType setTitle:data forState:UIControlStateNormal];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setBadges
{
    AppDelegate *appDlgt = GetAppDelegates;
    PushMsgModel * pushMsg;
    ///个人通知
    pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.liftMsg];
    if (pushMsg==nil) {
        pushMsg=[PushMsgModel new];
        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
    }
    
    NSInteger tmp = pushMsg.countMsg.integerValue;
    
    NSData *jsonData = [pushMsg.content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *msgDict =  [DataController dictionaryWithJsonData:jsonData];
    
    pushMsg.countMsg=[[NSNumber alloc]initWithInteger:tmp];
    pushMsg.content=@"";
    [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.liftMsg];
    
    
    if (pushMsg!=nil) {
        if(tmp>0)
        {
            pushMsg.countMsg=[[NSNumber alloc]initWithInteger:tmp];
            [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.liftMsg];
            
            [self showToastMsg:msgDict[@"content"] Duration:5.0];
            [UIView animateWithDuration:5.0 animations:^{
                
                self.btn_Addr.alpha = 0.99;
            } completion:^(BOOL finished) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }else{
            
            pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            pushMsg.content=@"";
            [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
        }

    }
}
#pragma mark - 接收消息
-(void)subReceivePushMessages:(NSNotification *)aNotification
{
    [super subReceivePushMessages:aNotification];
    
    [self setBadges];
    
}



#pragma mark ------- 从社区获取红包

- (void)openDoorRedPacketNetWithCommunityid:(NSString *)communityidStr {
    
    @WeakObj(self);
    
    [PARedBagPresenter getRedEnvelopeWithType:AD_RECEIVE_TYPE_SHAKE
                               andCommunityid:communityidStr
                              updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                                  
                                  if (resultCode == SucceedCode) {
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          PARedBagModel *redBag = data;
                                          if(redBag){
                                              
                                              [selfWeak showRedBag:redBag];
                                              
                                          }
                                      });
                                  }
                              }];
}


@end
