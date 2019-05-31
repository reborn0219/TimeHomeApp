//
//  YYPlaySound.m
//  TimeHomeApp
//
//  Created by 世博 on 16/7/12.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "YYPlaySound.h"




@implementation YYPlaySound


#pragma mark -  播放完成后回调函数
void soundCompleteCallback(SystemSoundID sound,void * clientData){
    
    NSLog(@"播放完成...");
    AudioServicesPlaySystemSound(sound);
    
}
/**
 *  开启震动
 */
+ (void)playShake {
    
    BOOL isClose = [[[NSUserDefaults standardUserDefaults]objectForKey:kCloseShakeOrNot] boolValue];
    if (isClose == NO) {
    
//        SystemSoundID thesoundID;//声音
//        thesoundID = kSystemSoundID_Vibrate;
//        AudioServicesPlaySystemSound (thesoundID);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }

}

+ (void)playSoundWithResourceName:(NSString *)sourceName ofType:(NSString *)type {
    
    BOOL isClose = [[[NSUserDefaults standardUserDefaults]objectForKey:kCloseSoundOrNot] boolValue];
    if (isClose == NO) {

        SystemSoundID thesoundID;//声音
        NSString *path = [[NSBundle mainBundle] pathForResource:sourceName ofType:type];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &thesoundID);
        AudioServicesPlaySystemSound (thesoundID);
    }
    
}

-(void)playSoundWithResourceName:(NSString *)sourceName ofType:(NSString *)type isRepeat:(BOOL)repeat {
    
    BOOL isClose = [[[NSUserDefaults standardUserDefaults]objectForKey:kAlertSoundOrNot] boolValue];
    if (isClose == NO) {
    
        NSString *path = [[NSBundle mainBundle] pathForResource:sourceName ofType:type];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &_thesoundID);
        if (repeat) {
            
            AudioServicesAddSystemSoundCompletion(_thesoundID, NULL, NULL,soundCompleteCallback, NULL);

        }
        AudioServicesPlaySystemSound(_thesoundID);
        
    }
    
}

-(void)stopAudioWithSystemSoundID:(SystemSoundID)thesoundID
{
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(_thesoundID);
    AudioServicesRemoveSystemSoundCompletion(_thesoundID);
    
}

@end
