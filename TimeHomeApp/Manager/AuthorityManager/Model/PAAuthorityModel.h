//
//  PAAuthorityModel.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAAuthorityModel : NSObject

@property (nonatomic,copy) NSString *sourceId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL enable;
@property (nonatomic,copy) NSString *nextSourceId;

@end
