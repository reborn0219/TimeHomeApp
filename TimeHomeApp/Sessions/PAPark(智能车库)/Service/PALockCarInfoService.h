//
//  PALockCarInfoService.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/13.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PALockCarModel.h"

@protocol PALockCompleteDelegate <NSObject>
@optional

-(void)requestDataCompleted;
-(void)requestSaveCompleted:(NSInteger)type;

@end
@interface PALockCarInfoService : NSObject

@property (nonatomic,strong)PALockCarModel *lockModel;//锁车详情
@property(nonatomic,weak) id <PALockCompleteDelegate> delegagte;
-(void)loadData:(NSString *)carID;
-(void)saveLockModel:(PALockCarModel *)lockModel;

@end
