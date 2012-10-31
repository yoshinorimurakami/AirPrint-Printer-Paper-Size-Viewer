//
//  PrintContent.h
//  AirPrintPaperViwer
//
//  Created by Yoshinori Murakami on 10/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrintContent : NSObject {
    
    NSString *resourceName;
    NSString *ofType;
    UIPrintInfoOutputType outputType;
    NSString *description;
    NSString *buttonLabel;
    UIImage *thumbnail;
    
}
@property (nonatomic, retain) NSString *resourceName;
@property (nonatomic, retain) NSString *ofType;
@property (nonatomic) UIPrintInfoOutputType outputType;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *buttonLabel;
@property (nonatomic, retain) UIImage *thumbnail;


@end
