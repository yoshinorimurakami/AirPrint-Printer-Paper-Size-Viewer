//
//  AirPrintPaperViwerAppDelegate.h
//  AirPrintPaperViwer
//
//  Created by Yoshinori Murakami on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirPrintPaperViwerAppDelegate : NSObject <UIApplicationDelegate> {
@private

    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
