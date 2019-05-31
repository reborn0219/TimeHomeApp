//
//  PAVoucherTableViewCell.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAVoucherTableViewCell.h"

@interface PAVoucherTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;//商家logo
@property (weak, nonatomic) IBOutlet UILabel *couponsNameLabel;//优惠券名称
@property (weak, nonatomic) IBOutlet UILabel *disexplanationLabel;//优惠券说明
@property (weak, nonatomic) IBOutlet UILabel *validateLabel;//有效期
@property (weak, nonatomic) IBOutlet UILabel *cheapamountLabel;//优惠券金额
@property (weak, nonatomic) IBOutlet UILabel *couponsNMLabel;//优惠券附名称
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//卡券状态
@property (weak, nonatomic) IBOutlet UIImageView *voucherBGimageView;//背景图
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;//查看详情
@property (weak, nonatomic) IBOutlet UILabel *sperateLine;//分割线
@property (weak, nonatomic) IBOutlet UIButton *receiveRedBagBtn;


@end

@implementation PAVoucherTableViewCell

-(void)hidenDetailLabel:(BOOL)isHidden{
    self.detailLabel.hidden = isHidden;
}


-(void)setVoucher:(PARedBagDetailModel *)voucher{
    if (voucher) {
        _voucher = voucher;
    }
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:voucher.logourl] placeholderImage:[UIImage imageNamed:@""]];
    
    
    //隐藏所有控件
    self.statusLabel.hidden = YES;//优惠券状态
    self.cheapamountLabel.hidden = YES;//金额
    self.detailLabel.hidden = YES;//详情标签
    self.sperateLine.hidden = YES;//分割线
    self.receiveRedBagBtn.hidden = YES;//领取按钮
    
    if (_voucher.type == 1 && voucher.state == 0) { /*未领取的优惠券,显示跟红包一致*/
        
        self.voucherBGimageView.image = [UIImage imageNamed:@"wdhb_bg_hb_n"];//红包背景图
        
        self.couponsNameLabel.text = _voucher.redmessage;//红包祝福语
        self.disexplanationLabel.text = _voucher.redname;//谁发的红包
        self.validateLabel.text = _voucher.systime;//红包领取时间
        
        self.couponsNameLabel.textColor = [UIColor whiteColor];
        self.disexplanationLabel.textColor = [UIColor whiteColor];
        self.validateLabel.textColor = [UIColor whiteColor];
        self.cheapamountLabel.textColor = [UIColor whiteColor];
        
        self.receiveRedBagBtn.hidden = NO;
        
    }else if(_voucher.type == 0){/*红包*/
        
        self.voucherBGimageView.image = [UIImage imageNamed:@"wdhb_bg_hb_n"];//红包背景图
        
        self.couponsNameLabel.text = _voucher.redmessage;//红包祝福语
        self.disexplanationLabel.text = _voucher.redname;//谁发的红包
        self.validateLabel.text = _voucher.systime;//红包领取时间
        
        NSString *cheapamout = [NSString stringWithFormat:@"￥%.2f",_voucher.amount];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:cheapamout];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 1)];
        
        self.cheapamountLabel.attributedText = attrStr;
        
        self.couponsNameLabel.textColor = [UIColor whiteColor];
        self.disexplanationLabel.textColor = [UIColor whiteColor];
        self.validateLabel.textColor = [UIColor whiteColor];
        self.cheapamountLabel.textColor = [UIColor whiteColor];
        
        if (_voucher.state != 0) {//已领取红包
            self.cheapamountLabel.hidden = NO;
            self.detailLabel.hidden = NO;
        }else{
            self.receiveRedBagBtn.hidden = NO;
        }
        
    }else{/*优惠券*/
       
        self.couponsNameLabel.text = _voucher.disexplanation;//优惠说明
        self.disexplanationLabel.text = _voucher.couponsname;//卡券名称
        
         if (_voucher.tickettype == 2) {//折扣券
             
             NSString *cheapamout = [NSString stringWithFormat:@"%ld折",(unsigned long)_voucher.discount];
             
             NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:cheapamout];
             [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(cheapamout.length-1, 1)];
             
             self.cheapamountLabel.attributedText = attrStr;
             
            self.couponsNMLabel.text = @"";
             
        }else if (_voucher.tickettype == 1){//代金券
            
            NSString *cheapamout = [NSString stringWithFormat:@"￥%.0f",_voucher.cheapamount];
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:cheapamout];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 1)];
    
            self.cheapamountLabel.attributedText = attrStr;
            
            self.couponsNMLabel.text = @"";
            
        }else if (_voucher.tickettype == 3){//体验券
            self.couponsNMLabel.text = @"体验券";
            self.cheapamountLabel.text = @"";
        }else if (_voucher.tickettype == 4){//礼品券
            self.couponsNMLabel.text = @"礼品券";
            self.cheapamountLabel.text = @"";
        }
        
        self.validateLabel.text = [NSString stringWithFormat:@"有效期:%@",_voucher.validate];
        
        if (_voucher.state == 1) {
            self.statusLabel.text = @"可用";
            self.voucherBGimageView.image = [UIImage imageNamed:@"wdkq_bg_ky_n"];
        }else if (_voucher.state == 2){
            self.statusLabel.text = @"已使用";
            self.voucherBGimageView.image = [UIImage imageNamed:@"wdkq_bg_ysy_n"];
        }else if (_voucher.state == 3){
            self.statusLabel.text = @"已失效";
            self.voucherBGimageView.image = [UIImage imageNamed:@"wdkq_bg_ysx_n"];
        }else{
            self.voucherBGimageView.image = [UIImage imageNamed:@"wdkq_bg_ky_n"];
        }
        
        //优惠券
        self.statusLabel.hidden = NO;
        self.cheapamountLabel.hidden = NO;
        self.detailLabel.hidden = NO;
        self.sperateLine.hidden = NO;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

/**
 未领取红包界面-立即领取红包方法

 @param sender sender
 */
- (IBAction)justGetRedBag:(id)sender {
    
    if (_cellEventBlock) {
        _cellEventBlock(_voucher,nil,nil);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
