//
//  LineBtnFooterView.h
//  TimeHomeApp
//
//  Created by us on 16/7/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineBtnFooterView : UICollectionReusableView

@property (nonatomic,strong)UpDateViewsBlock block;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)pushTOCircleList:(id)sender;

@end
