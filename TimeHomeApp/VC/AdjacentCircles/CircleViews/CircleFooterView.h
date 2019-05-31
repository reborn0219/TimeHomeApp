//
//  CircleFooterView.h
//  TimeHomeApp
//
//  Created by UIOS on 16/2/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleFooterView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *praiseCountLB;
@property (weak, nonatomic) IBOutlet UILabel *replayCountLB;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;

@property (nonatomic,copy)NSIndexPath * indexPath;
@property (nonatomic,copy)CellEventBlock block;
@property (nonatomic,copy)CellEventBlock praiseBlock;
@property (nonatomic,copy)CellEventBlock replayBlock;
- (IBAction)replayAction:(id)sender;
- (IBAction)praiseAction:(id)sender;

@end
