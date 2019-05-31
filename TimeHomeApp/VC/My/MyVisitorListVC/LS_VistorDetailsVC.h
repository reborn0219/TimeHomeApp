//
//  LS_VistorDetailsVC.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/8/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UpDownModel : NSObject
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * coutent;
@end


@interface LS_VistorDetailsVC : THBaseViewController

@property (nonatomic, copy) NSString   * vistorID;
@property (nonatomic, assign) NSString * ls_type;
@property (nonatomic, copy) NSString   * gotoUrl;

@end
