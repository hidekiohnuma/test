//
//  ViewController.h
//  sampleWebView
//
//  Created by 大沼英喜 on 2015/01/28.
//  Copyright (c) 2015年 大沼英喜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

