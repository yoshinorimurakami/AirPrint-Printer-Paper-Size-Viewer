//
//  RootViewController.h
//  NavigationBasedApp
//
//  Created by Yoshinori Murakami on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrintContent.h"

/// for delegate
@class SelectContentViewController; 
@protocol SelectContentViewControllerDelegate <NSObject>
@required
-(void)SelectContentViewController:(SelectContentViewController* )sCVC didSelectedContent:(PrintContent *)printContent;
@end
/// for delegate


@interface SelectContentViewController : UITableViewController {
	id <SelectContentViewControllerDelegate> theDelegate;
    NSMutableArray *printContentsArray;

}
- (NSDictionary *)ContentsDictionary;
- (void)setDelegate:(id)delegate;
- (void)selectTopOfTheList;

@end
