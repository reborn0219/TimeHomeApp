//
//  GetAreaListModel.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/11/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetAreaListModel : NSObject

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSArray<GetAreaListModel *> *list;
@end
