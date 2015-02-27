//
//  ViewController.m
//  ImageInTextView
//
//  Created by koogawa on 2013/12/22.
//  Copyright (c) 2013年 Kosuke Ogawa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *image = [UIImage imageNamed:@"Star"];

    // 非表示領域を設定（長方形）
    CGRect exclusionRect = CGRectMake(40, 30, image.size.width, image.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:exclusionRect];

    // 非表示領域を設定（星形）
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(160.0, 30.0)];
//    [path addLineToPoint:CGPointMake(210.0, 100.0)];
//    [path addLineToPoint:CGPointMake(280.0, 120.0)];
//    [path addLineToPoint:CGPointMake(230.0, 180.0)];
//    [path addLineToPoint:CGPointMake(240.0, 265.0)];
//    [path addLineToPoint:CGPointMake(160.0, 230.0)];
//    [path addLineToPoint:CGPointMake(95.0 , 270.0)];
//    [path addLineToPoint:CGPointMake(100.0, 180.0)];
//    [path addLineToPoint:CGPointMake(40.0 , 120.0)];
//    [path addLineToPoint:CGPointMake(125.0, 105.0)];
//    [path closePath];

    // テキストビューに設定
    self.textView.textContainer.exclusionPaths = @[path];

    // 画像配置
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = exclusionRect;
    [self.textView addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
