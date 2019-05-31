//
//  PANewHomeMenuModel.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/2.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PANewHomeMenuListModel : NSObject
@property (nonatomic,copy) NSString *classname;
@property (nonatomic,copy) NSArray *list;

@end

@interface PANewHomeMenuModel : NSObject
@property (nonatomic,copy) NSString *keynum;
@property (nonatomic,assign) NSInteger topsort;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *gotourl;
@property (nonatomic,assign) NSInteger allsort;
@property (nonatomic,assign) NSInteger ownerpowertype;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,assign) NSInteger isredenvelope;

@end
