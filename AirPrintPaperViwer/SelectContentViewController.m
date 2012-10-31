//
//  RootViewController.m
//  NavigationBasedApp
//
//  Created by Yoshinori Murakami on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectContentViewController.h"
#import "PrintContent.h"

@interface SelectContentViewController (private)
-(UIImage *)makeThumbnailImageFrom:(UIImage *)bigImage thubnailSize:(CGSize)thumbSize;
@end

@implementation SelectContentViewController

- (id)init {
    self = [super init];
    
    // Setup printContentsArray in Entry# order
    printContentsArray = [NSMutableArray array];
    [printContentsArray retain];
    
    NSDictionary *allContentsdic = [self ContentsDictionary];
    NSArray *allKeyArray = [allContentsdic allKeys];
    NSArray *sortedAllKetArray = [allKeyArray sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSString *aKey in sortedAllKetArray) {
        NSDictionary *contentDic = [allContentsdic objectForKey:aKey];
        PrintContent *aPC = [[PrintContent alloc] init];
        aPC.resourceName = [contentDic objectForKey:@"resourceName"];
        aPC.ofType = [contentDic objectForKey:@"ofType"];
        aPC.outputType = [[contentDic objectForKey:@"OutputType"] integerValue];
        aPC.description = [contentDic objectForKey:@"Description"];
        aPC.buttonLabel = [contentDic objectForKey:@"ButtonLabel"];
        aPC.thumbnail = nil;
        [printContentsArray addObject:aPC];
        [aPC release];
    }    

    return self;
}

- (void)viewDidLoad
    {
        [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    // こいつ結構重要。Selectの青をずっと保ってくれる。
    
}
/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self ContentsDictionary] allKeys] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectContentCell";
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
	cell.textLabel.adjustsFontSizeToFitWidth = YES;

    
    PrintContent *currentPC = [printContentsArray objectAtIndex:indexPath.row];
    // Thumbnail
    if([[currentPC ofType] isEqualToString:@"jpg"] || [[currentPC ofType] isEqualToString:@"JPG"] || [[currentPC ofType] isEqualToString:@"png"]) {
        if (!([currentPC thumbnail] == nil)) {
            cell.imageView.image = [currentPC thumbnail];
            
        } else {
            cell.imageView.contentMode = UIViewContentModeCenter;
            // Create a thumbnail
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[currentPC resourceName] 
                                                                                              ofType:[currentPC ofType]]];
            UIImage *thumbimg =[self makeThumbnailImageFrom:image thubnailSize:CGSizeMake(36, 36)];
            cell.imageView.image = thumbimg;
            [currentPC setThumbnail:thumbimg]; // save for later use　(毎回作ってると動きがぎくしゃくするので)
        }
    }
    // Descrition Text
    cell.textLabel.text = [currentPC description];
    
    return cell;
}
// サムネイル作成
- (UIImage *)makeThumbnailImageFrom:(UIImage *)bigImage thubnailSize:(CGSize)thumbSize {
    
    CGFloat ratio = (bigImage.size.width > bigImage.size.height)? thumbSize.width/bigImage.size.width : thumbSize.height/bigImage.size.height;
    CGRect rect = CGRectMake(0.0, 0.0, ratio * bigImage.size.width, ratio * bigImage.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    [bigImage drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)setDelegate:(id)delegate {
	theDelegate = delegate;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Tell delegate selected 印刷物
    
    PrintContent *currentPC = [printContentsArray objectAtIndex:indexPath.row];
    [theDelegate SelectContentViewController:self didSelectedContent:currentPC];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (NSDictionary *)ContentsDictionary {
	NSDictionary *dict;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"2_3_Landscape", @"resourceName", @"jpg", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputPhoto], @"OutputType",	
             @"2:3_Landscape.jpg in Photo mode", @"Description", @"2:3L.jpg:Photo", @"ButtonLabel",	
             nil], @"Entry01",

            [NSDictionary dictionaryWithObjectsAndKeys:
             @"2_3_Landscape", @"resourceName",	@"png", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputPhoto], @"OutputType",	
             @"2:3_Landscape.png in Photo mode", @"Description", @"2:3L.png:Photo", @"ButtonLabel",	
             nil], @"Entry02",
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"2_3_Landscape", @"resourceName",	@"png", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputGeneral], @"OutputType",	
             @"2:3_Landscape.png in General mode", @"Description", @"2:3L.png:General", @"ButtonLabel",	
             nil], @"Entry03",
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"2_3_Portrait", @"resourceName",	@"png", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputPhoto], @"OutputType",	
             @"2:3_Portrait.png in Photo mode", @"Description", @"2:3P.png:Photo", @"ButtonLabel",	
             nil], @"Entry04",
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"2_3_Portrait", @"resourceName",	@"png", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputGeneral], @"OutputType",	
             @"2:3_Portrait.png in General mode", @"Description", @"2:3P.png:General", @"ButtonLabel",	
             nil], @"Entry05",
            
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"3_4_Landscape", @"resourceName",	@"png", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputPhoto], @"OutputType",	
             @"3:4_Landscape.png in Photo mode", @"Description", @"3:4L.png:Photo", @"ButtonLabel",	
             nil], @"Entry10",
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"3_4_Landscape", @"resourceName",	@"png", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputGeneral], @"OutputType",	
             @"3:4_Landscape.png in General mode", @"Description", @"3:4L.png:General", @"ButtonLabel",	
             nil], @"Entry11",
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"3_4_Portrait", @"resourceName",	@"png", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputPhoto], @"OutputType",	
             @"3:4_Portrait.png in Photo mode", @"Description", @"3:4P.png:Photo", @"ButtonLabel",	
             nil], @"Entry12",
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"3_4_Portrait", @"resourceName",	@"png", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputGeneral], @"OutputType",	
             @"3:4_Portrait.png in General mode", @"Description", @"3:4P.png:General", @"ButtonLabel",	
             nil], @"Entry13",

            [NSDictionary dictionaryWithObjectsAndKeys:
             @"16_9_Landscape", @"resourceName", @"png", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputPhoto], @"OutputType",	
             @"16:9_Landscape.png in Photo mode", @"Description", @"16:9L.png:Photo", @"ButtonLabel",	
             nil], @"Entry20",
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"16_9_Landscape", @"resourceName", @"png", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputGeneral], @"OutputType",	
             @"16:9_Landscape.png in General mode", @"Description", @"16:9L.png:General", @"ButtonLabel",	
             nil], @"Entry21",
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"16_9_Portrait", @"resourceName",	@"png", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputPhoto], @"OutputType",	
             @"16:9_Portrait.png in Photo mode", @"Description", @"16:9P.png:Photo", @"ButtonLabel",	
             nil], @"Entry22",
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"16_9_Portrait", @"resourceName",	@"png", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputGeneral], @"OutputType",	
             @"16:9_Portrait.png in General mode", @"Description", @"16:9P.png:General", @"ButtonLabel",	
             nil], @"Entry23",
          
                       
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"IMG_0426", @"resourceName",@"JPG", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputPhoto], @"OutputType",	
             @"HousePicture.jpg in Photo mode", @"Description",	@"House.jpg:Photo", @"ButtonLabel",	
             nil], @"Entry40",
            
            
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"HowPrintingWorksiniOS", @"resourceName",@"pdf", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputGeneral], @"OutputType",	
             @"PDF in General mode", @"Description", @"PDF:general", @"ButtonLabel",	
             nil], @"Entry50",
            
            
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"someTextFile", @"resourceName",@"txt", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputGeneral], @"OutputType",	
             @"Text in General mode", @"Description", @"Text:general", @"ButtonLabel",	
             nil], @"Entry91",
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"someTextFile", @"resourceName",@"txt", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputGrayscale], @"OutputType",	
             @"Text in Grayscale mode", @"Description",	@"Text:grayscale", @"ButtonLabel",	
             nil], @"Entry92",
            
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"PaperListTEXT", @"resourceName",@"txt", @"ofType", [NSNumber numberWithInt:UIPrintInfoOutputGeneral], @"OutputType",	
             @"Paper List @ last used printer", @"Description",	@"Paper List", @"ButtonLabel",	
             nil], @"Entry99",
            nil];
	
	return dict;
}
// Start時に呼ばれて、Tableのリストの一番上を選んだことにしておく
- (void)selectTopOfTheList {
    // topを選んだように
    PrintContent *currentPC = [printContentsArray objectAtIndex:0];
    [theDelegate SelectContentViewController:self didSelectedContent:currentPC];
    // 実際に青くしておく
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}

- (void)dealloc
{
    [printContentsArray release];
    [super dealloc];
}

@end
