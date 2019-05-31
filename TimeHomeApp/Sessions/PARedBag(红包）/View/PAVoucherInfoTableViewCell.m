//
//  PAVoucherInfoTableViewCell.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAVoucherInfoTableViewCell.h"

@interface PAVoucherInfoTableViewCell()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PAVoucherInfoTableViewCell

-(void)setExplanationUrl:(NSString *)explanationUrl{
    if (explanationUrl) {
        
        if (![explanationUrl isEqualToString:_explanationUrl]) {
            _explanationUrl = explanationUrl;
            
            NSURL* url = [NSURL URLWithString:explanationUrl];
            NSURLRequest* request = [NSURLRequest requestWithURL:url];
            
            [self.webView loadRequest:request];
        }
    }
}

-(void)setHtmlString:(NSString *)htmlString{
    if (htmlString) {
        [self.webView loadHTMLString:htmlString baseURL:nil];
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.scrollView.scrollEnabled = NO;
}

-(void)dealloc{
    [_webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //webview 高度获取参考资料：https://bingozb.github.io/41.html
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat webViewHeight = self.webView.scrollView.contentSize.height;
        //TODO: 通知上层height改变
        //47+contentHeight;
        
        if (self.heightCallBack) {
            self.heightCallBack(@(47+webViewHeight), self, nil);
        }
    }
}

#pragma mark - UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

@end
