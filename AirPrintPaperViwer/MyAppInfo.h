//
//  MyAppInfo.h
//  AirPrintPaperViwer
//
//  Created by Yoshinori Murakami on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAppInfo : NSObject

+ (NSString *)myAppDisplayName;
+ (NSString *)myBundleName;
+ (NSString *)myBuildDateAndTime;
+ (NSString *)myBundleVersion;

@end
