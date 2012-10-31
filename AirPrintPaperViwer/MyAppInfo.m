//
//  MyAppInfo.m
//  AirPrintPaperViwer
//
//  Created by Yoshinori Murakami on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAppInfo.h"

@implementation MyAppInfo

+ (NSString *)myAppDisplayName {
    NSDictionary*	myInfoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *myAppName = [myInfoDic objectForKey:@"CFBundleDisplayName"];
    return myAppName;
}

+ (NSString *)myBundleName {
    NSDictionary*	myInfoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *myBundleName = [myInfoDic objectForKey:@"CFBundleName"];
    return myBundleName;
}

+ (NSString *)myBuildDateAndTime {
    NSString *myBuildDateAndTime = @"?";
    NSDictionary*	myInfoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appPath = [[NSBundle mainBundle] pathForResource:[myInfoDic objectForKey:@"CFBundleExecutable"] ofType:@""];
    if (appPath != nil){
        NSError **err;
        NSDictionary *attrDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:appPath error: err];
        myBuildDateAndTime = [[attrDictionary objectForKey:NSFileModificationDate] description];
    }
    return myBuildDateAndTime;
}

+ (NSString *)myBundleVersion {
    NSDictionary*	myInfoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *v = [myInfoDic objectForKey:@"CFBundleVersion"];
    return v;
}




@end
