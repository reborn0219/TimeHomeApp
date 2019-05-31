//
//  CircleFooterView.m
//  TimeHomeApp
//
//  Created by UIOS on 16/2/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CircleFooterView.h"

@implementation CircleFooterView

- (IBAction)moreAction:(id)sender {
    
    self.block(nil,nil,self.indexPath);
    
}
- (void)awakeFromNib {
    [super awakeFromNib];


}

- (IBAction)replayAction:(id)sender {
    self.replayBlock(nil,nil,self.indexPath);

}
- (IBAction)praiseAction:(id)sender {
    self.praiseBlock(nil,nil,self.indexPath);

}
@end
