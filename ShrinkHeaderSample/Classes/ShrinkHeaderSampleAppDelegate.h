//
//  ShrinkHeaderSampleAppDelegate.h
//  ShrinkHeaderSample
//
//  Created by Shuji OCHI <ponpoko1968@gmail.com> on 10/10/03.
//  Copyright http://life.ponpoko.tv 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShrinkHeaderSampleAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

