//
//  PostHeaderView.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostHeaderView : UICollectionReusableView
@property (nonatomic,copy)NSIndexPath * indexPath;
@property (nonatomic,copy)CellEventBlock block;
@property (nonatomic,copy)CellEventBlock contentBlock;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;
- (IBAction)delAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@end
