//
//  VoicePopVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "VoicePopVC.h"
#import "BDVRSConfig.h"
#import "WebViewVC.h"
#import "IntelligentGarageVC.h"
#import "NotificationVC.h"
#import "RaiN_NewServiceTempVC.h"
#import "PANewHomeService.h"
#define VOICE_LEVEL_INTERVAL 0.1 // 音量监听频率为1秒中10次

@interface VoicePopVC ()
///语音动画显示
@property (weak, nonatomic) IBOutlet UIImageView *img_VoiceAnimation;
///提示语或识别文字
@property (weak, nonatomic) IBOutlet UILabel *lab_Content;

@property (nonatomic, strong)PANewHomeService * homeService;
@end

@implementation VoicePopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=RGBAFrom0X(0x000000, 0.4);
    [self initBDVoice];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self freeVoiceLevelMeterTimerTimer];
}
- (void)didReceiveMemoryWarning {
    [[BDVoiceRecognitionClient sharedInstance] stopVoiceRecognition];
    [self dismissAlert];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
#pragma mark -------初始化--------------
/**
 *  返回实例
 *
 *  @return return value description
 */
+(VoicePopVC *)getInstance
{
    VoicePopVC * alertVC= [[VoicePopVC alloc] initWithNibName:@"VoicePopVC" bundle:nil];
    return alertVC;
}
- (PANewHomeService *)homeService{
    if (!_homeService) {
        _homeService = [[PANewHomeService alloc]init];
    }
    return _homeService;
}
/**
 *  单例方法
 *
 *  @return return value  返回类实例
 */
+ (VoicePopVC *)sharedVoicePopVC {
    static VoicePopVC * sharedVoicePopVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedVoicePopVC = [[self alloc] initWithNibName:@"VoicePopVC" bundle:nil];
    });
    return sharedVoicePopVC;
}

-(void)initBDVoice
{
    // 设置开发者信息
    [[BDVoiceRecognitionClient sharedInstance] setApiKey:API_KEY withSecretKey:SECRET_KEY];
    
    NSNumber * recognitionProperty=[NSNumber numberWithInt:EVoiceRecognitionPropertySearch];
    // 设置语音识别模式，默认是输入模式
    [[BDVoiceRecognitionClient sharedInstance] setPropertyList:@[recognitionProperty]];
    
    // 设置城市ID，当识别属性包含EVoiceRecognitionPropertyMap时有效
    [[BDVoiceRecognitionClient sharedInstance] setCityID: 1];
    
    // 设置是否需要语义理解，只在搜索模式有效
    [[BDVoiceRecognitionClient sharedInstance] setConfig:@"nlu" withFlag:NO];
    
    // 开启联系人识别
    //    [[BDVoiceRecognitionClient sharedInstance] setConfig:@"enable_contacts" withFlag:YES];
    
    // 设置识别语言
    [[BDVoiceRecognitionClient sharedInstance] setLanguage:BDVoiceRecognitionLanguageChinese];
    
    [BDVRSConfig sharedInstance].voiceLevelMeter=YES;
    // 是否打开语音音量监听功能，可选
    if ([BDVRSConfig sharedInstance].voiceLevelMeter)
    {
        BOOL res = [[BDVoiceRecognitionClient sharedInstance] listenCurrentDBLevelMeter];
        
        if (res == NO)  // 如果监听失败，则恢复开关值
        {
            [BDVRSConfig sharedInstance].voiceLevelMeter = NO;
        }
    }
    else
    {
        [[BDVoiceRecognitionClient sharedInstance] cancelListenCurrentDBLevelMeter];
    }
    
    // 设置播放开始说话提示音开关，可选
    [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecStart isPlay:YES];
    // 设置播放结束说话提示音开关，可选
    [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecEnd isPlay:YES];
}
///开启语单
-(void)startRecodeVoice
{
    // 开始语音识别功能，之前必须实现MVoiceRecognitionClientDelegate协议中的VoiceRecognitionClientWorkStatus:obj方法
    int startStatus = -1;
    startStatus = [[BDVoiceRecognitionClient sharedInstance] startVoiceRecognition:self];
    if (startStatus != EVoiceRecognitionStartWorking) // 创建失败则报告错误
    {
        NSString *statusString = [NSString stringWithFormat:@"%d",startStatus];
        [self performSelector:@selector(firstStartError:) withObject:statusString afterDelay:0.3];
        return;
    }
    // 是否需要播放开始说话提示音，如果是，则提示用户不要说话，在播放完成后再开始说话, 也就是收到EVoiceRecognitionClientWorkStatusStartWorkIng通知后再开始说话。
    if ([BDVRSConfig sharedInstance].playStartMusicSwitch)
    {
        self.lab_Content.text=NSLocalizedString(@"StringVoiceRecognitonInit", nil);
    }
    else{
        self.lab_Content.text=NSLocalizedString(@"StringVoiceRecognitonPleaseSpeak", nil);
    }
    
}


#pragma mark----------------显示和隐藏------------------
/**
 *  显示
 *
 *  @param parent parent description
 */
-(void)ShowVoicePopVC:(UIViewController *)parent voiceCallBack:(ViewsEventBlock)voiceCallBack
{
    self.voiceCallBack=voiceCallBack;
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    [parent presentViewController:self animated:YES completion:^{
        self.view.backgroundColor=RGBAFrom0X(0x000000, 0.4);
        [self startRecodeVoice];
    }];
    
}

/**
 *  隐藏显示
 */
-(void)dismissAlert
{
    [[BDVoiceRecognitionClient sharedInstance] stopVoiceRecognition];
    [self dismissViewControllerAnimated:YES completion:^{
        
    } ];
}


#pragma mark ---------事件处理---------
///确定事件
- (IBAction)btn_OKEvent:(UIButton *)sender {
    [self dismissAlert];
    
//    [self dismissAlert];
//    if(self.eventCallBack)
//    {
//        self.eventCallBack(nil,sender,1);
//    }

}
///取消事件
- (IBAction)btn_CancelEvent:(UIButton *)sender {
    
    [[BDVoiceRecognitionClient sharedInstance] speakFinish];
//    if(self.eventCallBack)
//    {
//        self.eventCallBack(nil,sender,0);
//    }

}
///帮助事件
- (IBAction)btn_HelpEvent:(UIButton *)sender {
    
//    [self dismissAlert];
    if (self.voiceCallBack) {
        self.voiceCallBack(nil,sender,VoiceHelp);
    }
    
    
}



#pragma mark - VoiceLevelMeterTimer methods

- (void)startVoiceLevelMeterTimer
{
    [self freeVoiceLevelMeterTimerTimer];
    
    NSDate *tmpDate = [[NSDate alloc] initWithTimeIntervalSinceNow:VOICE_LEVEL_INTERVAL];
    NSTimer *tmpTimer = [[NSTimer alloc] initWithFireDate:tmpDate interval:VOICE_LEVEL_INTERVAL target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    self.voiceLevelMeterTimer = tmpTimer;
    
    [[NSRunLoop currentRunLoop] addTimer:_voiceLevelMeterTimer forMode:NSDefaultRunLoopMode];
}

- (void)freeVoiceLevelMeterTimerTimer
{
    if(_voiceLevelMeterTimer)
    {
        if([_voiceLevelMeterTimer isValid])
            [_voiceLevelMeterTimer invalidate];
        self.voiceLevelMeterTimer = nil;
    }
}
- (void)timerFired:(id)sender
{
    // 获取语音音量级别
    int voiceLevel = [[BDVoiceRecognitionClient sharedInstance] getCurrentDBLevelMeter];
    switch (voiceLevel%10) {
        case 0:
            self.img_VoiceAnimation.image =[UIImage imageNamed:@"000"];
            break;
        case 1:
            self.img_VoiceAnimation.image =[UIImage imageNamed:@"001"];
            break;
        case 2:
            self.img_VoiceAnimation.image =[UIImage imageNamed:@"002"];
            break;
        case 3:
            self.img_VoiceAnimation.image =[UIImage imageNamed:@"003"];
            break;
        case 4:
            self.img_VoiceAnimation.image =[UIImage imageNamed:@"004"];
            break;
        case 5:
            self.img_VoiceAnimation.image =[UIImage imageNamed:@"005"];
            break;
        case 6:
            self.img_VoiceAnimation.image =[UIImage imageNamed:@"006"];
            break;
        case 7:
            self.img_VoiceAnimation.image =[UIImage imageNamed:@"007"];
            break;
        case 8:
            self.img_VoiceAnimation.image =[UIImage imageNamed:@"008"];
            break;
        case 9:
            self.img_VoiceAnimation.image =[UIImage imageNamed:@"009"];
            break;
        case 10:
            self.img_VoiceAnimation.image =[UIImage imageNamed:@"010"];
            break;
            
        default:
            break;
    }
}
#pragma mark - voice search log

- (void)createRunLogWithStatus:(int)aStatus
{
    NSString *statusMsg = nil;
    switch (aStatus)
    {
        case EVoiceRecognitionClientWorkStatusNone: //空闲
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNone", nil);
            break;
        }
        case EVoiceRecognitionClientWorkPlayStartTone:  //播放开始提示音
        {
            statusMsg = NSLocalizedString(@"StringLogStatusPlayStartTone", nil);
            break;
        }
        case EVoiceRecognitionClientWorkPlayStartToneFinish: //播放开始提示音完成
        {
            statusMsg = NSLocalizedString(@"StringLogStatusPlayStartToneFinish", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusStartWorkIng: //识别工作开始，开始采集及处理数据
        {
            statusMsg = NSLocalizedString(@"StringLogStatusStartWorkIng", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusStart: //检测到用户开始说话
        {
            statusMsg = NSLocalizedString(@"StringLogStatusStart", nil);
            break;
        }
        case EVoiceRecognitionClientWorkPlayEndTone: //播放结束提示音
        {
            statusMsg = NSLocalizedString(@"StringLogStatusPlayEndTone", nil);
            break;
        }
        case EVoiceRecognitionClientWorkPlayEndToneFinish: //播放结束提示音完成
        {
            statusMsg = NSLocalizedString(@"StringLogStatusPlayEndToneFinish", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusReceiveData: //语音识别功能完成，服务器返回正确结果
        {
            statusMsg = NSLocalizedString(@"StringLogStatusSentenceFinish", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusFinish: //语音识别功能完成，服务器返回正确结果
        {
            statusMsg = NSLocalizedString(@"StringLogStatusFinish", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd: //本地声音采集结束结束，等待识别结果返回并结束录音
        {
            statusMsg = NSLocalizedString(@"StringLogStatusEnd", nil);
            break;
        }
        case EVoiceRecognitionClientNetWorkStatusStart: //网络开始工作
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusStart", nil);
            break;
        }
        case EVoiceRecognitionClientNetWorkStatusEnd:  //网络工作完成
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusEnd", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusCancel:  // 用户取消
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusCancel", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusError: // 出现错误
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusErorr", nil);
            break;
        }
        default:
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusDefaultErorr", nil);
            break;
        }
    }
    
    if (statusMsg)
    {
        //		NSString *logString = self.clientSampleViewController.logCatView.text;
        //		if (logString && [logString isEqualToString:@""] == NO)
        //		{
        //			self.clientSampleViewController.logCatView.text = [logString stringByAppendingFormat:@"\r\n%@", statusMsg];
        //		}
        //		else 
        //		{
        //			self.clientSampleViewController.logCatView.text = statusMsg;
        //		}
    }
}
#pragma mark - voice search error result

- (void)firstStartError:(NSString *)statusString
{
    
    [self createErrorViewWithErrorType:[statusString intValue]];
}

- (void)createErrorViewWithErrorType:(int)aStatus
{
    NSString *errorMsg = @"";
    switch (aStatus)
    {
        case EVoiceRecognitionClientErrorStatusIntrerruption:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonInterruptRecord", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusChangeNotAvailable:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonChangeNotAvailable", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusUnKnow:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonStatusError", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusNoSpeech://没有识别返回
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoSpeech", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusShort:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoShort", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusException:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonException", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusError:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNetWorkError", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusUnusable:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoNetWork", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusTimeOut:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNetWorkTimeOut", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusParseError:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonParseError", nil);
            break;
        }
        case EVoiceRecognitionStartWorkNoAPIKEY:
        {
            errorMsg = NSLocalizedString(@"StringAudioSearchNoAPIKEY", nil);
            break;
        }
        case EVoiceRecognitionStartWorkGetAccessTokenFailed:
        {
            errorMsg = NSLocalizedString(@"StringAudioSearchGetTokenFailed", nil);
            break;
        }
        case EVoiceRecognitionStartWorkDelegateInvaild:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoDelegateMethods", nil);
            break;
        }
        case EVoiceRecognitionStartWorkNetUnusable:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoNetWork", nil);
            break;
        }
        case EVoiceRecognitionStartWorkRecorderUnusable:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonCantRecord", nil);
            break;
        }
        case EVoiceRecognitionStartWorkNOMicrophonePermission:
        {
            errorMsg = NSLocalizedString(@"StringAudioSearchNOMicrophonePermission", nil);
            break;
        }
            //服务器返回错误
        case EVoiceRecognitionClientErrorNetWorkStatusServerNoFindResult:     //没有找到匹配结果
        case EVoiceRecognitionClientErrorNetWorkStatusServerSpeechQualityProblem:    //声音过小
            
        case EVoiceRecognitionClientErrorNetWorkStatusServerParamError:       //协议参数错误
        case EVoiceRecognitionClientErrorNetWorkStatusServerRecognError:      //识别过程出错
        case EVoiceRecognitionClientErrorNetWorkStatusServerAppNameUnknownError: //appName验证错误
        case EVoiceRecognitionClientErrorNetWorkStatusServerUnknownError:      //未知错误
        {
            errorMsg = [NSString stringWithFormat:@"%@-%d",NSLocalizedString(@"StringVoiceRecognitonServerError", nil),aStatus] ;
            break;
        }
        default:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonDefaultError", nil);
            break;
        }
    }
    NSLog(@"errorMsg====%@",errorMsg);
}
#pragma mark - MVoiceRecognitionClientDelegate

- (void)VoiceRecognitionClientErrorStatus:(int) aStatus subStatus:(int)aSubStatus
{
    // 为了更加具体的显示错误信息，此处没有使用aStatus参数
    [self createErrorViewWithErrorType:aSubStatus];
}

- (void)VoiceRecognitionClientWorkStatus:(int)aStatus obj:(id)aObj
{
    switch (aStatus)
    {
        case EVoiceRecognitionClientWorkStatusFlushData: // 连续上屏中间结果
        {
            NSString *text = [aObj objectAtIndex:0];
            
            if ([text length] > 0)
            {
                self.lab_Content.text=text;
                NSLog(@"语音===:%@",[NSString stringWithFormat:@"%@",text]);
            }
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusFinish: // 识别正常完成并获得结果
        {
            [self createRunLogWithStatus:aStatus];
            //  搜索模式下的结果为数组，示例为
            // ["公园", "公元"]
            NSMutableArray *audioResultData = (NSMutableArray *)aObj;
            NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
            
            for (int i=0; i < [audioResultData count]; i++)
            {
                [tmpString appendFormat:@"%@\r\n",[audioResultData objectAtIndex:i]];
            }
            ///语音字串
            [self disposeVoiceResultData:[audioResultData objectAtIndex:0]];
            NSLog(@"语音字串=========%@",tmpString);

            
            break;
        }
        case EVoiceRecognitionClientWorkStatusReceiveData:
        {
            // 此状态只有在输入模式下使用
            // 输入模式下的结果为带置信度的结果，示例如下：
            //  [
            //      [
            //         {
            //             "百度" = "0.6055192947387695";
            //         },
            //         {
            //             "摆渡" = "0.3625582158565521";
            //         },
            //      ]
            //      [
            //         {
            //             "一下" = "0.7665404081344604";
            //         }
            //      ],
            //   ]
            
            //            NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aObj];
            //            [clientSampleViewController logOutToContinusManualResut:tmpString];
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd: // 用户说话完成，等待服务器返回识别结果
        {
            [self createRunLogWithStatus:aStatus];
            if ([BDVRSConfig sharedInstance].voiceLevelMeter)
            {
                [self freeVoiceLevelMeterTimerTimer];
            }
            
//            [self createRecognitionView];
            self.lab_Content.text = NSLocalizedString(@"StringVoiceRecognitonIdentify", nil);
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusCancel:
        {
            if ([BDVRSConfig sharedInstance].voiceLevelMeter)
            {
                [self freeVoiceLevelMeterTimerTimer];
            }
            
            [self createRunLogWithStatus:aStatus];
            break;
        }
        case EVoiceRecognitionClientWorkStatusStartWorkIng: // 识别库开始识别工作，用户可以说话
        {
            if ([BDVRSConfig sharedInstance].playStartMusicSwitch) // 如果播放了提示音，此时再给用户提示可以说话
            {
                self.lab_Content.text = NSLocalizedString(@"StringVoiceRecognitonPleaseSpeak", nil);
            }
            
            if ([BDVRSConfig sharedInstance].voiceLevelMeter)  // 开启语音音量监听
            {
               [self startVoiceLevelMeterTimer];
            }
            
            [self createRunLogWithStatus:aStatus];
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusNone:
        case EVoiceRecognitionClientWorkPlayStartTone:
        case EVoiceRecognitionClientWorkPlayStartToneFinish:
        case EVoiceRecognitionClientWorkStatusStart:
        case EVoiceRecognitionClientWorkPlayEndToneFinish:
        case EVoiceRecognitionClientWorkPlayEndTone:
        {
            [self createRunLogWithStatus:aStatus];
            break;
        }
        case EVoiceRecognitionClientWorkStatusNewRecordData:
        {
//            [self createRunLogWithStatus:aStatus];
            break;
        }
        default:
        {
            [self createRunLogWithStatus:aStatus];
            if ([BDVRSConfig sharedInstance].voiceLevelMeter)
            {
                [self freeVoiceLevelMeterTimerTimer];
            }
            [self dismissAlert];
            break;
        }
    }
}

- (void)VoiceRecognitionClientNetWorkStatus:(int) aStatus
{
    switch (aStatus) 
    {
        case EVoiceRecognitionClientNetWorkStatusStart:
        {	
            [self createRunLogWithStatus:aStatus];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;   
        }
        case EVoiceRecognitionClientNetWorkStatusEnd:
        {
            [self createRunLogWithStatus:aStatus];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;   
        }          
    }
}

/**
 处理语音data

 @param data 语音数据
 */
- (void)disposeVoiceResultData:(NSString *)data{
    
    NSString *hanziText = (NSString *)data;
    if ([hanziText length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            NSLog(@"pinyin: %@", ms);
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            NSLog(@"pinyin12121: %@", ms);
            if([ms hasPrefix:@"suo che"]||[ms hasPrefix:@"jie suo"])
            {
                // 智能车库：锁车、解锁
                self.voiceCallBack(nil, nil, VoiceParking);
            }
            else if ([ms hasPrefix:@"gong gao"]) {//社区公告：语音发送“公告”，进入公告列表页
                self.voiceCallBack(nil, nil, VoiceNotice);

            }
            if ([ms containsString:@"bao xiu"]|| [ms containsString:@"wei xiu"] ) {//在线报修：语音发送“报修”“维修”，进入在线报修页
                self.voiceCallBack(nil, nil, VoiceMaintain);
                
            }
            // 社区新闻：语音发送“新闻”，进入社区新闻主页面
            else if ([ms containsString:@"xin wen"]||[ms containsString:@"zi xun"] ) {
                self.voiceCallBack(nil, nil, VoiceNews);
             
            } else if ([ms containsString:@"dang jian"]) {
                //党建服务：语音发送“党建”，进入党建服务主页面
                self.voiceCallBack(nil, nil, VoicePartyBuilding);
            }
            // 违章查询：语音发送“违章查询”，进入违章查询主页面
            else if ([ms containsString:@"wei zhang cha xun"] ) {
                self.voiceCallBack(nil, nil, VoiceBreakRules);
            }
        }
    }
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
