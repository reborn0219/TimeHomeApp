//
//  UserStatistics.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/7/10.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserStatistics : NSManagedObject

@property (nonatomic, strong) NSString *begintime;
@property (nonatomic, strong) NSString *communityid;
@property (nonatomic, strong) NSString *endtime;
@property (nonatomic, strong) NSString *expandata;
@property (nonatomic, strong) NSString *postid;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *viewkey;
@property (nonatomic, copy) NSString *name;

@end
