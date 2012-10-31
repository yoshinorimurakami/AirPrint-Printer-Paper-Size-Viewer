//
//  PaperNameAndSize.m
//  AirPrintPaperViwer
//
//  Created by Yoshinori Murakami on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaperNameAndSize.h"

@interface PaperNameAndSize (Private)

+ (NSArray *)paperAllNameArray;
+ (NSDictionary *)paperWHDictionaryFromPaperName:(NSString *)paperName;
+ (NSDictionary *)paperWHDictionaryDictionary;
+ (BOOL)isThisSize:(CGFloat)inspectSize closeEnoughWithThisSize:(CGFloat)sizeBase;

@end

@implementation PaperNameAndSize

+ (NSString *)whatIsThePaperNameForPaperSize:(CGSize)paperSize {
    
    NSString *paperStr = @"";
    NSArray *allPaperName = [self paperAllNameArray];
    for (NSString *aPaperName in allPaperName) {
        NSDictionary *dict = [self paperWHDictionaryFromPaperName:aPaperName];
        float paperWidth = [[dict objectForKey:@"W_Media"] floatValue];
        float paperHeight = [[dict objectForKey:@"H_Media"] floatValue];
        if ([self isThisSize:paperSize.width closeEnoughWithThisSize:paperWidth]) {
            if ([self isThisSize:paperSize.height closeEnoughWithThisSize:paperHeight]) {
                paperStr = [paperStr stringByAppendingFormat:@"%@", aPaperName];
            }
        }
    }    
    return paperStr;
}
+ (BOOL)isThisSize:(CGFloat)inspectSize closeEnoughWithThisSize:(CGFloat)sizeBase {
    
    if(inspectSize == sizeBase) return true;
    if((inspectSize >= sizeBase - 5.0) && (inspectSize <= sizeBase + 5.0)) return true;
    
    return false;
}

+ (NSArray *)paperAllNameArray {
	return [[self paperWHDictionaryDictionary] allKeys];
}
+ (NSDictionary *)paperWHDictionaryFromPaperName:(NSString *)paperName {
	NSDictionary *dict = [[self paperWHDictionaryDictionary] objectForKey:paperName];
	if (dict == nil) { dict = nil; } // default?
	return dict;
}
+ (NSDictionary *)paperWHDictionaryDictionary {
#define mm_pt 1/25.4*72
#define in_pt 1*72
	NSDictionary *dict = 
	[NSDictionary dictionaryWithObjectsAndKeys:
	 [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInt:4*in_pt], @"W_Media", [NSNumber numberWithInt:6*in_pt], @"H_Media", nil], @"4x6/KG",
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:5*in_pt], @"W_Media",	[NSNumber numberWithInt:7*in_pt], @"H_Media", nil], @"5x7/2L判", 
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:3.5*in_pt], @"W_Media",	[NSNumber numberWithInt:5*in_pt], @"H_Media", nil], @"3.5x5/L判",  
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:100*mm_pt], @"W_Media",	[NSNumber numberWithInt:148*mm_pt], @"H_Media", nil], @"Hagaki/はがき", 
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:200*mm_pt], @"W_Media", [NSNumber numberWithInt:148*mm_pt], @"H_Media", nil], @"往復はがき(横長)", 
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:148*mm_pt], @"W_Media", [NSNumber numberWithInt:200*mm_pt], @"H_Media", nil], @"往復はがき(縦長)", 
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:8.5*in_pt], @"W_Media",	[NSNumber numberWithInt:11*in_pt], @"H_Media", nil], @"Letter", 
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:5.5*in_pt], @"W_Media", [NSNumber numberWithInt:8.5*in_pt], @"H_Media", nil], @"Half Letter",
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:210*mm_pt], @"W_Media",	[NSNumber numberWithInt:297*mm_pt], @"H_Media", nil], @"A4", 
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:8.5*in_pt], @"W_Media",	[NSNumber numberWithInt:14*in_pt], @"H_Media", nil], @"Legal", 
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:148*mm_pt], @"W_Media", [NSNumber numberWithInt:210*mm_pt], @"H_Media", nil], @"A5", 
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:105*mm_pt], @"W_Media",	[NSNumber numberWithInt:148*mm_pt], @"H_Media", nil], @"A6",
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:182*mm_pt], @"W_Media",	[NSNumber numberWithInt:257*mm_pt], @"H_Media", nil], @"B5",
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:297*mm_pt], @"W_Media",	[NSNumber numberWithInt:420*mm_pt], @"H_Media", nil], @"A3",
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:11*in_pt], @"W_Media",	[NSNumber numberWithInt:17*in_pt], @"H_Media", nil], @"US B 11x17",
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:8*in_pt], @"W_Media",	[NSNumber numberWithInt:10*in_pt], @"H_Media", nil], @"8x10",
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:7.25*in_pt], @"W_Media",	[NSNumber numberWithInt:10.5*in_pt], @"H_Media", nil], @"Executive", 
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:3.875*in_pt], @"W_Media",	[NSNumber numberWithInt:8.875*in_pt], @"H_Media", nil], @"Envelop #9",
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:4.125*in_pt], @"W_Media",	[NSNumber numberWithInt:9.5*in_pt], @"H_Media", nil], @"Envelop #10",
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:114*mm_pt], @"W_Media",	[NSNumber numberWithInt:162*mm_pt], @"H_Media", nil], @"Envelop iso-C6",
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:110*mm_pt], @"W_Media",	[NSNumber numberWithInt:220*mm_pt], @"H_Media", nil], @"Envelop DL",
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:3*in_pt], @"W_Media", [NSNumber numberWithInt:5*in_pt], @"H_Media", nil], @"Index 3x5", 
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:90*mm_pt], @"W_Media",	[NSNumber numberWithInt:205*mm_pt], @"H_Media", nil], @"長形 4号封筒",
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:120*mm_pt], @"W_Media",	[NSNumber numberWithInt:235*mm_pt], @"H_Media", nil], @"長形 3号封筒", 
	 [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInt:111.1*mm_pt], @"W_Media", [NSNumber numberWithInt:146*mm_pt], @"H_Media", nil], @"長形 2号封筒",	
	 [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInt:5*in_pt], @"W_Media", [NSNumber numberWithInt:8*in_pt], @"H_Media", nil], @"5x8",
	 [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInt:6.5*in_pt], @"W_Media", [NSNumber numberWithInt:9.5*in_pt], @"H_Media", nil], @"Envelop C5",
	 [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInt:3.875*in_pt], @"W_Media", [NSNumber numberWithInt:7.5*in_pt], @"H_Media", nil], @"Monarch Envelope",
	 [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInt:176*mm_pt], @"W_Media", [NSNumber numberWithInt:250*mm_pt], @"H_Media", nil], @"iso-B5 Envelope",
	 [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInt:97*mm_pt], @"W_Media", [NSNumber numberWithInt:151*mm_pt], @"H_Media", nil], @"PRC 32k",
	 nil];
	
	return dict;
}

@end
