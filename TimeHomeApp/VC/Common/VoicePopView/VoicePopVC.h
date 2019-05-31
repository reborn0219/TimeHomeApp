//
//  VoicePopVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "BDVoiceRecognitionClient.h"
#import "BDRecognizerViewParamsObject.h"

typedef NS_ENUM(NSUInteger, VoiceDisposeType) {
    VoiceMaintain,//在线报修
    VoiceNotice,//公告
    VoiceParking,//解锁车
    VoiceNews,//新闻
    VoicePartyBuilding,//党建
    VoiceBreakRules,//违章查询
    VoiceHelp//帮助
};

@interface VoicePopVC : BaseViewController<MVoiceRecognitionClientDelegate>

/// 获取语音音量界别定时器
@property (nonatomic, retain) NSTimer *voiceLevelMeterTimer;
/**
 *  事件处理回调
 */
@property(copy,nonatomic) ViewsEventBlock voiceCallBack;

/**
 *  隐藏显示
 */
-(void)dismissAlert;
/**
 *  显示
 *
 *  @param parent <#parent description#>
 */
-(void)ShowVoicePopVC:(UIViewController *)parent voiceCallBack:(ViewsEventBlock)voiceCallBack;

/**
 *  获取实例
 *
 *  @return return value description
 */
+(VoicePopVC *)getInstance;
/**
 *  单例方法
 */
SYNTHESIZE_SINGLETON_FOR_HEADER(VoicePopVC);




@end
