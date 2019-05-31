//
//  PAWaterDefinition.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterDefinition.h"

//-----------------App向饮水机蓝牙发送的指令
//APP连接指令
NSString * const PAWaterConnectToDevice = @"EFEF00006000FEFE";

NSString * const PAWaterCoinSuccess = @"EFEF00007200FEFE";

//-----------------饮水机蓝牙返回状态----------------------

NSString * const PAWaterConnectionSuccess = @"dfdf00006000fdfd";

NSString * const PAWaterConnectionException = @"dfdf00006003fdfd";

NSString * const PAWaterBeforeCoin = @"dfdf00007000fdfd";

NSString * const PAWaterAfterCoin = @"dfdf00007100fdfd";

NSString * const PAWaterFlowing = @"dfdf00007001fdfd";

NSString * const PAWaterIllegalAmount = @"dfdf00007002fdfd";

NSString * const PAWaterUnfinished = @"dfdf00007003fdfd";

NSString * const PAWaterIllegalInstructions = @"dfdf00007010fdfd";

NSString * const PAWaterIllegalConnect = @"dfdf00007011fdfd";

NSString * const PAWaterHeaderOrFooterError = @"dfdf00007012fdfd";

NSString * const PAWaterOtherError = @"dfdf00007013fdfd";

NSString * const PAWaterRepeatCoin = @"dfdf00007009fdfd";

