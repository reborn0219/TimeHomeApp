//
//  PAVoucherCodeTableViewCell.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAVoucherCodeTableViewCell.h"
#import "UIImage+QRCode.h"

@interface PAVoucherCodeTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;//二维码图片
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;//券码
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//卡券状态

@end

@implementation PAVoucherCodeTableViewCell

- (void)setVoucher:(PARedBagDetailModel *)voucher{
    
    if (voucher) {
        _voucher = voucher;
    }
    
    //二维码图片生成
    UIImage *qrCodeImage = [UIImage creatNonInterpolatedUIImageFormCIImage:[self generateQRCodeWithCode:voucher.userticketid] withSize:self.qrCodeImageView.bounds.size.width];
    [self.qrCodeImageView setImage:qrCodeImage];
    
    //券码
    self.codeLabel.text = [NSString stringWithFormat:@"券码:%@",_voucher.code];
    
    //状态
    switch (_voucher.state) {
        case 0://已领取
            self.statusLabel.text = @"未领取";
            break;
        case 1://未使用
            self.statusLabel.text = @"消费时请向商家出示二维码";
            break;
        case 2://已核销
            self.statusLabel.text = @"已核销";
            break;
        case 3://已失效
            self.statusLabel.text = @"已失效";
            break;
        default:
            self.statusLabel.text = @"未知状态";
            break;
    }
}

//TODO:抽离为公共方法
- (CIImage *)generateQRCodeWithCode:(NSString *)code {
    
    if (!code) {
        return nil;
    }
    
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3. 给过滤器添加数据
    NSData *data = [code dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 生成二维码
    return [filter outputImage];
}

@end
