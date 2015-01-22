//
//  RootViewController.h
//  ShrinkHeaderSample
//
//  Created by Shuji OCHI <ponpoko1968@gmail.com> on 10/10/03.
//  Copyright http://life.ponpoko.tv 2010. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ShrinkHeaderTableViewController : UITableViewController {
  NSArray* headerShrinkStates_;
}
@property (nonatomic,retain)NSArray* headerShrinkStates;
-(void) shrinkRowsInSection:(NSInteger)section;

@end
