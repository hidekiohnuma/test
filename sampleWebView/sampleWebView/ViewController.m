//
//  ViewController.m
//  sampleWebView
//
//  Created by 大沼英喜 on 2015/01/28.
//  Copyright (c) 2015年 大沼英喜. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* urlString = @"http://google.com";
    // これを使って、URLオブジェクトをつくります
    NSURL* googleURL = [NSURL URLWithString: urlString];
    // さらにこれを使って、Requestオブジェクトをつくります
    NSURLRequest* myRequest = [NSURLRequest requestWithURL: googleURL];
    // これを、myFirstWebViewのloadRequestメソッドに渡します
    [self.webView loadRequest:myRequest];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"hideki");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 追加適用するCSSを取得します。
    NSString *css = @"body{background-color:red;} *{font-style:italic;}";
    
    // 追加適用するCSSを適用する為の
    // JavaScriptを作成します。
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"var style = document.createElement('style');"];
    [javascript appendString:@"style.type = 'text/css';"];
    [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
    [javascript appendString:@"style.appendChild(cssContent);"];
    [javascript appendString:@"document.body.appendChild(style);"];
    
    
    // JavaScriptを実行します。
    [webView stringByEvaluatingJavaScriptFromString:javascript];
}

@end
