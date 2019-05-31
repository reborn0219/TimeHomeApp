//
//  PAUserRequest.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/7/6.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PABaseRequest.h"
@interface PAUserLogInRequest : PABaseRequest
-(instancetype)initWithLogInAccout:(NSString *)account passWord:(NSString *)passWord;
@end
