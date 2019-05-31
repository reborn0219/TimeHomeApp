//
//  PAH5UrlManager.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/16.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAH5Url.h"

@interface PAH5UrlManager : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(PAH5UrlManager)

-(PAH5Url*)h5urls;
-(void)saveUrls:(PAH5Url*)urlModel;
-(void)saveUrls:(PAH5Url*)urlModel isInMap:(BOOL)isInMap;

@end
