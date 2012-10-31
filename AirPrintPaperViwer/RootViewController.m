//
//  RootViewController.m
//  AirPrintPaperViwer
//
//  Created by Yoshinori Murakami on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "PaperNameAndSize.h"
#import "PrintContent.h"
#import "MyAppInfo.h"

@interface RootViewController (private)
- (BOOL)isThisPaperList:(NSArray *)paperList1 exactlySameAsThisPaperList:(NSArray *)paperList2;
@end

@implementation RootViewController
@synthesize currentPaperList, selectedPaper;
@synthesize outputTypeButton;
@synthesize currentPrintContent;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//
	self.title = @"AirPrint Tester";
	
    // Print Button
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                         target:self action:@selector(actionButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:btn animated:NO];
    [btn release];
	
	
	UIBarButtonItem *btn2 = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
											   target:self action:@selector(outputType:)];
	self.outputTypeButton = btn2;
	[self.navigationItem setRightBarButtonItem:btn2 animated:NO];
    [btn2 release];

    
    //
    self.currentPaperList = nil;
	self.selectedPaper = nil;
    
    //
     if(selectContentViewController == nil) {
		selectContentViewController = [[SelectContentViewController alloc] init];
        [selectContentViewController setDelegate:self];
	}
    // 初期値として Contentsデータベースのエントリー1を選んでおきましょう。
    [selectContentViewController selectTopOfTheList];   // will call Delegate SelectContentViewController:didSelectedContent:
    // これでDelegateが呼ばれて、ボタンラベルもcontentDicも設定される
    lastSelectedRow = 0;
    
    // Let's clean up 前回の PaperListTEXT.txt
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* aFileName = @"PaperListTEXT.txt"; 
    NSString *myOutPath = [documentsDir stringByAppendingFormat:@"/%@", aFileName];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:myOutPath error:nil];
    // end of clean up old files
	
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.clearsSelectionOnViewWillAppear = NO;
    // こいつ結構重要。Selectの青をずっと保ってくれる。
    // ほかのViewに行って戻ってきても選んだ青を保ってくれる。
        
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
// OutputType button
-(void)outputType:(id)sender {
    
    // setting view を呼ぶ
	if(selectContentViewController == nil) {
		selectContentViewController = [[SelectContentViewController alloc] init];
        [selectContentViewController setDelegate:self];

	}
    
	//[self presentModalViewController:selectContentViewController animated:YES];
    [self.navigationController pushViewController:selectContentViewController animated:YES];
	selectContentViewController.title = @"Print Contents";

    
}
// Delegate call when user select print content from list
-(void)SelectContentViewController:(SelectContentViewController* )sCVC didSelectedContent:(PrintContent *)printContent {
	
    self.currentPrintContent = printContent;
    self.outputTypeButton.title = [self.currentPrintContent buttonLabel];
}



// Print Button
-(IBAction)actionButtonPressed:(id)sender {
    // Obtain the shared UIPrintInteractionController
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    if(!controller){
        NSLog(@"Couldn't get shared UIPrintInteractionController!");
        return;
    }
    // We need a completion handler Block for printing.
    UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error)
            NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
    };
    
    // Obtain a printInfo so that we can set our printing defaults.
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.jobName = @"AirPrint API checker";
    controller.printInfo = printInfo;
    
	// Setup print content
	if(!self.currentPaperList) {
        
        // Print dummy page to get available paper list
        // 私自身のビルド時間の入ったダミーページ用の文字列を作って、それを印刷する
        //NSString *myAppName = [MyAppInfo myAppDisplayName];   // PaperViewer じゃあ、AirPrintがない
        NSString *myAppName = @"AirPrint Paper Viewer";
        // Application Build date
        NSString *dummyPageString = [NSString stringWithFormat:@"%@ : Build ", myAppName];
        dummyPageString = [dummyPageString stringByAppendingString:[MyAppInfo myBuildDateAndTime]];
        
        dummyPageString = [dummyPageString stringByAppendingString:@"\n\rThis is a dummy print page to get available paper list."];
        UISimpleTextPrintFormatter *stf = [[UISimpleTextPrintFormatter alloc] initWithText:dummyPageString];
        controller.printFormatter = stf;
        [stf release];
        printInfo.outputType = UIPrintInfoOutputGeneral;        
    }else {
        
        // Print User selected
        // txtとimageを一緒に出来ないものか？
        if([[self.currentPrintContent ofType] isEqualToString:@"txt"]) {
            if ([[self.currentPrintContent resourceName] isEqualToString:@"PaperListTEXT"]) {
                
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
                NSString* documentsDir = [paths objectAtIndex:0];
                NSString* aFileName = @"PaperListTEXT.txt"; 
                NSString *filePath = [documentsDir stringByAppendingFormat:@"/%@", aFileName];
                NSString *myText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];  
                UISimpleTextPrintFormatter *stf = [[UISimpleTextPrintFormatter alloc] initWithText:myText];
                controller.printFormatter = stf;
                [stf release];

            } else {
                NSString *filePath = [[NSBundle mainBundle] pathForResource:[self.currentPrintContent resourceName]
                                                                     ofType:[self.currentPrintContent ofType]];   
                NSString *myText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];  
                UISimpleTextPrintFormatter *stf = [[UISimpleTextPrintFormatter alloc] initWithText:myText];
                controller.printFormatter = stf;
                [stf release];
            }
        } else {
            NSString *path = [[NSBundle mainBundle] pathForResource:[self.currentPrintContent resourceName] 
                                                             ofType:[self.currentPrintContent ofType]];
            controller.printingItem = [NSURL fileURLWithPath:path isDirectory:NO];
        }
        printInfo.outputType = [self.currentPrintContent outputType];      
    }
	
    controller.delegate = self;
    // presenting the printing UI
    [controller presentAnimated:YES completionHandler:completionHandler];  // iPhone

}

#pragma mark <UIPrintInteractionControllerDelegate>
// callback after [Print]
- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)pIC choosePaper:(NSArray *)paperList {
	
    NSLog(@"%s", __func__);	
	
    if (![self isThisPaperList:paperList exactlySameAsThisPaperList:self.currentPaperList]) {    
        // case user switch printer, need to refresh the list to new
        NSMutableString *paperListText = [[NSMutableString alloc]init];
        NSError *error;
        [paperListText appendString:[NSString stringWithFormat:@"Available Paper Set %@\n\r\n\r", [[pIC printInfo] printerID]]];
        // printerID で mDNS service name が取れる 例えば、"EPSON Artisan 730.ipp_.tcp.local."

        for (UIPrintPaper *aPaper in paperList) {
            NSString *paperString;
            paperString = [NSString stringWithFormat:@"Available size (%.1f, %.1f)(%.1fin, %.1fin), printable ((%.1f, %.1f), (%.1f, %.1f))(%.1fin, %.1fin)", 
                  aPaper.paperSize.width, aPaper.paperSize.height, 
                  aPaper.paperSize.width/72, aPaper.paperSize.height/72,
                  aPaper.printableRect.origin.x, aPaper.printableRect.origin.y,
                  aPaper.printableRect.size.width, aPaper.printableRect.size.height,
                  aPaper.printableRect.size.width/72, aPaper.printableRect.size.height/72];
            
            NSLog(@"%@", paperString);
            
            [paperListText appendString:[NSString stringWithFormat:@"%@\n\r", [self aPaperDescriptionStringFromPaper:aPaper]]];
            // \r, \r\n ではiOS v4.3だと改行してくれない。 iOS v5 はオッケー -> Forumでも問題になってるバグ
            // \n\rだと　iOS v4.3だと改行してくれる。　iOS　v5では 二回改行 -> 回避策かな
        }
        self.currentPaperList = paperList;
        [self.tableView reloadData];
        
        // /Documents/. に書き出し
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
		NSString* documentsDir = [paths objectAtIndex:0];
        NSString* aFileName = @"PaperListTEXT.txt"; 
        NSString *myOutPath = [documentsDir stringByAppendingFormat:@"/%@", aFileName];
        [paperListText writeToFile:myOutPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        [paperListText release];
        
    }
    

	// return paper if there is the previously selected paper in new list, if not nil
	UIPrintPaper *chosenPaper = nil;
	if (self.selectedPaper != nil) {
        int c = 0;
		for (UIPrintPaper *aPaper in paperList) {
			if ( 
				(aPaper.paperSize.width == self.selectedPaper.paperSize.width) &&
				(aPaper.paperSize.height == self.selectedPaper.paperSize.height) &&
				(aPaper.printableRect.origin.x == self.selectedPaper.printableRect.origin.x) &&
				(aPaper.printableRect.origin.y == self.selectedPaper.printableRect.origin.y) &&
				(aPaper.printableRect.size.width == self.selectedPaper.printableRect.size.width) &&
				(aPaper.printableRect.size.height == self.selectedPaper.printableRect.size.height)
				) {
				chosenPaper = aPaper;
                // プリンターが切り替わってtableViewがreloadされた時も、同じ紙があったのなら選ばれていてほしい
                // のでこの行を入れる。これはtableViewがreloadされない場合既に選ばれているので実行する必要はないが、実行しても害はないはず
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:c+1 inSection:0] 
                                            animated:NO scrollPosition:UITableViewScrollPositionNone];
				break;
			}
            c++;
		}
        if(!chosenPaper) {
            // case selectPaperで選択してあるのに リストにない -> たぶん ユーザーが新しいプリンターに切り替えた
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Selected Paper was not in (new) Available Paper List."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];	
            [alert release];
            self.selectedPaper = nil;
            // selectedPaperが空になったので defau;tが選ばれているように明示しよう
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
                                        animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
	} else { // case self.selectedPaper == nil
        // Paper sizeが選ばれていないとき、それはdefaoultが選ばれるのですよと言うことを明示したい
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
	return chosenPaper; 
	//If you return nil, a UIPrintPaper encapsulating the default paper size and printable rectangle is used.
}
- (BOOL)isThisPaperList:(NSArray *)paperList1 exactlySameAsThisPaperList:(NSArray *)paperList2 {
    BOOL are2same = YES;
    if (!paperList1) return NO;
    if (!paperList2) return NO;
    if ([paperList1 count] != [paperList2 count]) return NO;
    
    for (UIPrintPaper *aPaper1 in paperList1) {
        BOOL found = NO; 
        for (UIPrintPaper *aPaper2 in paperList2) {
            
            if ( 
                (aPaper1.paperSize.width == aPaper2.paperSize.width) &&
                (aPaper1.paperSize.height == aPaper2.paperSize.height) &&
                (aPaper1.printableRect.origin.x == aPaper2.printableRect.origin.x) &&
                (aPaper1.printableRect.origin.y == aPaper2.printableRect.origin.y) &&
                (aPaper1.printableRect.size.width == aPaper2.printableRect.size.width) &&
                (aPaper1.printableRect.size.height == aPaper2.printableRect.size.height)
                ) {
                found = YES;
                break;
            }
        }
        if (found == NO) {
            are2same = NO;
            break;
        }
    }
    // need to check other way
    if (are2same == YES) {
        for (UIPrintPaper *aPaper2 in paperList2) {
            BOOL found = NO; 
            for (UIPrintPaper *aPaper1 in paperList1) {
                
                if ( 
                    (aPaper2.paperSize.width == aPaper1.paperSize.width) &&
                    (aPaper2.paperSize.height == aPaper1.paperSize.height) &&
                    (aPaper2.printableRect.origin.x == aPaper1.printableRect.origin.x) &&
                    (aPaper2.printableRect.origin.y == aPaper1.printableRect.origin.y) &&
                    (aPaper2.printableRect.size.width == aPaper1.printableRect.size.width) &&
                    (aPaper2.printableRect.size.height == aPaper1.printableRect.size.height)
                    ) {
                    found = YES;
                    break;
                }
            }
            if (found == NO) {
                are2same = NO;
                break;
            }
        }

    }
    
    return are2same;
}

// これが最終的に使われる紙サイズ
- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)pIC {
    NSLog(@"%s", __func__);
	NSLog(@"Current size (%.1f, %.1f)(%.1fin, %.1fin), printable ((%.1f, %.1f), (%.1f, %.1f))(%.1fin, %.1fin)", 
		  pIC.printPaper.paperSize.width, pIC.printPaper.paperSize.height, 
		  pIC.printPaper.paperSize.width/72, pIC.printPaper.paperSize.height/72, 
		  pIC.printPaper.printableRect.origin.x, pIC.printPaper.printableRect.origin.y,
		  pIC.printPaper.printableRect.size.width, pIC.printPaper.printableRect.size.height,
		  pIC.printPaper.printableRect.size.width/72, pIC.printPaper.printableRect.size.height/72);	
	
	NSString *msg = [NSString stringWithFormat:@"Paper(%.1f, %.1f)=(%.1fin, %.1fin), Printable (%.1f, %.1f), (%.1f, %.1f)=(%.1fin, %.1fin)", 
					 pIC.printPaper.paperSize.width, pIC.printPaper.paperSize.height, 
					 pIC.printPaper.paperSize.width/72, pIC.printPaper.paperSize.height/72, 
					 pIC.printPaper.printableRect.origin.x, pIC.printPaper.printableRect.origin.y,
					 pIC.printPaper.printableRect.size.width, pIC.printPaper.printableRect.size.height,
					 pIC.printPaper.printableRect.size.width/72, pIC.printPaper.printableRect.size.height/72];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"A Paper used is ..."
													message:msg
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
	
}



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
    NSInteger lines;
    if (!self.currentPaperList) {
        lines = 2;  // for instructions, あとのROW の高さを戻すためにあとひとつ
    } else {
        lines = ([self.currentPaperList count] + 1);
    }
    return lines;
}

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    if ((!self.currentPaperList)&&(indexPath.row==0)) {
        height = 140.0; // この値 適当 ま、4 行くらいカバーすりゃいいし、その上下に余白は欲しいし
   } else {
        height = 40.0;
    }
    return height;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RootCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Configure the cell.
    
    if (!self.currentPaperList) {
        if (indexPath.row  == 0) {
            cell.textLabel.text = @"INSTRUCTION:\nStep1: Upper left button to get Paper List\nStep2: Print with selected paper from the list\nStep3: Repeat step2 \nUpper right button to change print content";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.numberOfLines = ceilf([cell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap].height/20.0);    // 20 ぐらいでいいかな？

        } else if (indexPath.row  == 1) {
            // Build: 2011-10-14 18:24:53
            cell.textLabel.text = [[NSString stringWithString:@"Build: "] stringByAppendingString:[MyAppInfo myBuildDateAndTime]];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textAlignment = UITextAlignmentRight;
        }
    } else {
        cell.textLabel.numberOfLines = 1;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
        if (indexPath.row  == 0) {
            cell.textLabel.text = @"Printer's default Paper size";	
        } else {
            UIPrintPaper *aPaper = [self.currentPaperList objectAtIndex:(indexPath.row - 1)];
            cell.textLabel.text = [self aPaperDescriptionStringFromPaper:aPaper];            
        }
    }
    
    return cell;
}

-(NSString *)aPaperDescriptionStringFromPaper:(UIPrintPaper *)aPaper {

    NSString *paperStr = [PaperNameAndSize whatIsThePaperNameForPaperSize:aPaper.paperSize];
    if(![paperStr isEqualToString:@""]) paperStr = [paperStr stringByAppendingString:@" "];
    paperStr = [paperStr stringByAppendingFormat:@"(%.1fin, %.1fin)", aPaper.paperSize.width/72, aPaper.paperSize.height/72];
    NSString *printableStr;
    if ((aPaper.paperSize.width == aPaper.printableRect.size.width)&&(aPaper.paperSize.height==aPaper.printableRect.size.height)) {
        printableStr = @"Zero Margin Full Paper Size";
    } else {
        printableStr = [NSString stringWithFormat:@"((%.1fin, %.1fin)-(%.1fin, %.1fin))", 
              aPaper.printableRect.origin.x/72, aPaper.printableRect.origin.y/72,
              aPaper.printableRect.size.width/72, aPaper.printableRect.size.height/72];
    }
    return [NSString stringWithFormat:@"%@, %@", paperStr, printableStr];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    //<#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/
	lastSelectedRow = indexPath.row;
    

	if (indexPath.row  == 0) {
		self.selectedPaper = nil;		
	} else {
		self.selectedPaper = [self.currentPaperList objectAtIndex:(indexPath.row - 1)];
	}
	
	
	
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

- (void)dealloc {
    self.currentPaperList = nil;

    [selectContentViewController release];
    [super dealloc];
}

@end
