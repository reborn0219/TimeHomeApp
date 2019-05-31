//
//  PABaseResponseModel.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PABaseResponseModel : NSObject

@property (nonatomic,assign) NSInteger code;
@property (nonatomic,copy) NSString *msg;;
@property (nonatomic,strong) id data;//数组或者字典

@end
