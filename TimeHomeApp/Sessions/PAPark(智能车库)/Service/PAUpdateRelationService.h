//
//  PAUpdateRelationService.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PACarManagementModel.h"
#import "PABaseRequestService.h"

@protocol PAUpdateCompleteDelegate <NSObject>
@optional

-(void)requestUpdateCompleted:(NSInteger)type;
-(void)requestUnRelationCompleted;
-(void)requestRelationCarCompleted:(NSInteger)type;
-(void)requestUpdateBatchCompleted;

@end

@interface PAUpdateRelationService :PABaseRequestService

@property(nonatomic,weak) id <PAUpdateCompleteDelegate> delegagte;
@property (nonatomic,strong) NSMutableArray<__kindof PACarManagementModel*> *carDataArray;//车量

///未关联的车辆列表
-(void)loadData:(NSString *)spaceID;
///修改车牌
-(void)changeCarNo:(NSString *)carNo
         ownerName:(NSString *)ownerName
           spaceID:(NSString *)spaceID
             carID:(NSString *)carID;
///关联车牌
-(void)relationCar:(NSArray*)carInfoArr spaceID:(NSString *)spaceID;
///批量修改
-(void)batchChangeRelationCarNO:(NSString *)carNo updateCarNo:(NSString *)updateCarNo communityID:(NSString *)communityId;

@end
