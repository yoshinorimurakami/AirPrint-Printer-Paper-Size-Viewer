//
//  RootViewController.h
//  AirPrintPaperViwer
//
//  Created by Yoshinori Murakami on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectContentViewController.h"
@class PaperNameAndSize;


@interface RootViewController : UITableViewController <UIPrintInteractionControllerDelegate, SelectContentViewControllerDelegate>{
@private

    NSArray *currentPaperList;
	UIPrintPaper *selectedPaper;
    
	UIBarButtonItem *outputTypeButton;
    
    SelectContentViewController *selectContentViewController;
    PrintContent *currentPrintContent;
    
    
    NSInteger lastSelectedRow;
    
}
@property (nonatomic, retain) NSArray *currentPaperList;
@property (nonatomic, retain) UIPrintPaper *selectedPaper;
@property (nonatomic, retain) UIBarButtonItem *outputTypeButton;
@property (nonatomic, retain) PrintContent *currentPrintContent;

-(NSString *)aPaperDescriptionStringFromPaper:(UIPrintPaper *)aPaper;

@end
