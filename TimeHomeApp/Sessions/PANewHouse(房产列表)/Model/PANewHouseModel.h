//
//  PANewHouseModel.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PANewHouseModel : NSObject
@property (nonatomic, strong)NSString *communityName;
@property (nonatomic, strong)NSString *communityId;
@property (nonatomic, strong)NSString *houseAddress;
@property (nonatomic, strong)NSString *houseRoom;
@property (nonatomic, strong)NSString *contactMobile;
@property (nonatomic, assign)BOOL isNew;
@end
