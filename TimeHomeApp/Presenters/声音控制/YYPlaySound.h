//
//  YYPlaySound.h
//  TimeHomeApp
//
//  Created by 世博 on 16/7/12.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
/**
 *  播放声音，播放震动
 */
@interface YYPlaySound : NSObject

@property (nonatomic, assign) SystemSoundID thesoundID;
/**
 *  播放声音
 *
 *  @param sourceName 音频文件名
 *  @param type       类型名
 */
+ (void)playSoundWithResourceName:(NSString *)sourceName ofType:(NSString *)type;
/**
 *  开启震动
 */
+ (void)playShake;

/**
 *  循环播放
 *
 *  @param sourceName 音频文件名
 *  @param type       类型名
 */
-(void)playSoundWithResourceName:(NSString *)sourceName ofType:(NSString *)type isRepeat:(BOOL)repeat;
/**
 *停止播放
 */
-(void)stopAudioWithSystemSoundID:(SystemSoundID)thesoundID;

@end
