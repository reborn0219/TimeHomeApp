//
//  DescribeViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/9.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

typedef void (^DescribeCallBack) (NSString *string);
@interface DescribeViewController : THBaseViewController
/**
 *  详细描述信息
 */
@property (nonatomic, strong) NSString *describeString;

@property (nonatomic, copy) DescribeCallBack describeCallBack;

@end
