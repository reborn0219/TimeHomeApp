//
//  PACarportRentHeaderView.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PACarSpaceRentHeaderView : UIView

@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * titleLabel;

@end


@interface PACarSpaceRentFooterView : UIView

@property (nonatomic, strong)UILabel * tipLabel;
@property (nonatomic, strong)UIButton * rentButton;

@property (nonatomic, copy)UpDateViewsBlock rentBlock;
@end
