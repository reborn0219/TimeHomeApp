//
//  PAParkingRentDetailView.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/20.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PACarSpaceModel;

@interface PACarSpaceRentDetailView : UIView
@property (nonatomic, strong) PACarSpaceModel * spaceModel;


/**
 data = 1 撤销车位  data = 2 续租车位
 */
@property (nonatomic, copy) UpDateViewsBlock eventBlock;
@end
