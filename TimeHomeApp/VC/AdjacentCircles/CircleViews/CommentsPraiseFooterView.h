//
//  CommentsPraiseFooterView.h
//  TimeHomeApp
//
//  Created by UIOS on 16/4/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsPraiseFooterView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *jiantouV;
- (IBAction)pinlunAction:(id)sender;
- (IBAction)commentsAction:(id)sender;
- (IBAction)praiseAction:(id)sender;
@property (nonatomic , copy)NSIndexPath * indexPath;

@property (weak, nonatomic) IBOutlet UIButton * praiseBtn;
@property (weak, nonatomic) IBOutlet UILabel  * commentsLb;
@property (weak, nonatomic) IBOutlet UILabel  * praiseLb;
@property (nonatomic ,copy) CellEventBlock block;
@property (nonatomic ,copy) CellEventBlock praiseBlock;
@property (nonatomic ,copy) CellEventBlock commentsBlock;
@property (nonatomic ,copy) CellEventBlock showAllBlock;

- (IBAction)showAllAction:(id)sender;

@end
