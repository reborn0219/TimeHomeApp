//
//  PAParkingSpaceService.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PACarSpaceModel.h"
#import "PACarManagementModel.h"

@protocol PAServiceReqeustCompleteDelegate <NSObject>
@optional

-(void)requestDataCompleted;

@end

@interface PAParkingSpaceService : NSObject
@property (nonatomic, assign) int isLimited;
@property (nonatomic,strong) NSMutableArray<__kindof PACarManagementModel*> *carDataArray;//车量
@property(nonatomic,weak) id <PAServiceReqeustCompleteDelegate> delegagte;

-(void)loadNoInCarData;

@end
