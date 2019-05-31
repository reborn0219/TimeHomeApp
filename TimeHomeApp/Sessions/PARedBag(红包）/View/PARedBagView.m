//
//  PARedBagView.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PARedBagView.h"

@interface PARedBagView()

@property (nonatomic,copy) ViewsEventBlock tapBlock;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgCenterYConstraint;

@end

@implementation PARedBagView

+(void)showWithRedBag:(PARedBagModel*)redBag EventBlock:(ViewsEventBlock)tapBlock{
    
    PARedBagView *redbagView = [[[NSBundle mainBundle] loadNibNamed:@"PARedBagView" owner:self options:nil] objectAtIndex:0];
    
    [redbagView.bgImageView sd_setImageWithURL:[NSURL URLWithString:redBag.logo] placeholderImage:[UIImage imageNamed:@"hbtc_img_hbjzz_n.png"]];
    
    redbagView.redBag = redBag;
    redbagView.tapBlock = tapBlock;
    
    redbagView.frame = [[UIScreen mainScreen]bounds];
  
    [[UIApplication sharedApplication].keyWindow addSubview:redbagView];    
    
    [redbagView showAnimation];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveRedBag:)];
    
    [self.bgImageView addGestureRecognizer:tap];
}

-(void)showAnimation{
    
    self.bgCenterYConstraint.constant = 0;
    [UIView animateWithDuration:0.7 animations:^{
        [self layoutIfNeeded];
    }];
}

-(void)dissmiss{
    [UIView animateWithDuration:0.3f animations:^{
        self.bgImageView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
        self.bgImageView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Action

- (IBAction)receiveRedBag:(id)sender {
    if (self.tapBlock) {
        self.tapBlock(self.redBag, self, 0);
        [self dissmiss];
    }
}
- (IBAction)closeRedBag:(id)sender {
    if (self.tapBlock) {
        self.tapBlock(self.redBag, self, 1);
        [self dissmiss];
    }
}

@end
