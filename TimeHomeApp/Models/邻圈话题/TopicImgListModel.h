//
//  TopicImgList.h
//  TimeHomeApp
//
//  Created by UIOS on 16/4/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicImgListModel : NSObject
@property(nonatomic , copy)NSString * picID;
@property(nonatomic , copy)NSString * fileurl;
@property(nonatomic , copy)NSString * systime;
@property(nonatomic , retain)UIImage * image;
@end
