//
//  CommentsPraiseFooterView.m
//  TimeHomeApp
//
//  Created by UIOS on 16/4/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CommentsPraiseFooterView.h"

@implementation CommentsPraiseFooterView

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code

    self.jiantouV.transform = CGAffineTransformMakeRotation(M_PI_2/2);
    
}

- (IBAction)pinlunAction:(id)sender {
    self.block(nil,nil,_indexPath);
    
}

- (IBAction)commentsAction:(id)sender {
    self.commentsBlock(nil,nil,_indexPath);
}

- (IBAction)praiseAction:(id)sender {
    self.praiseBlock(nil,nil,_indexPath);

}
- (IBAction)showAllAction:(id)sender {
    self.showAllBlock(nil,nil,_indexPath);

}
@end
