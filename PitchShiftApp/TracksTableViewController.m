//
//  TracksTableViewController.m
//  PitchShiftApp
//
//  Created by Marcelo Henrique Salloum dos Santos on 10/1/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "TracksTableViewController.h"
#import "TracksTableViewCell.h"

@implementation TracksTableViewController

@synthesize tracksTableView, tracksArray, isPlaying;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Tracks";
        isPlaying = NO;
        // Custom initialization
    }
    return self;
}

- (id)initDefaultXib{
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    if(screenHeight == 480){
        // retina 3.5:
        self = [super initWithNibName:@"TracksTableViewController" bundle:nil];
    }else if(screenHeight == 568){
        // retina 4.0:
        self = [super initWithNibName:@"TracksTableViewController_i5" bundle:nil];
    }
    if (self) {
        self.navigationItem.title = @"Tracks";
        isPlaying = NO;
        // Custom initialization
    }
    return self;
}
//    TracksTableViewController *trackTableViewController = [[TracksTableViewController alloc] initWithNibName:@"TracksTableViewController" bundle:nil];
//[[UIDevice currentDevice] platformType]

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshCellsList];
    [self.tracksTableView setDataSource:self];
    
    //Changes background image:
    
    UIColor *background;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    if(screenHeight == 480){
        // retina 3.5:
        background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"PSA_0.2_Background.png"]];
    }else if(screenHeight == 568){
        // retina 4.0:
        background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"PSA_0.2_Background_i5.png"]];
    }

    self.tracksTableView.backgroundColor = background;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Unselect the selected row if any
    NSIndexPath* selection = [self.tracksTableView indexPathForSelectedRow];
    if (selection) {
        [self.tracksTableView deselectRowAtIndexPath:selection animated:YES];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// ---------- START DATASOURCE METHODS
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"[tracksArray count]");
    return [self.tracksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TracksTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"TracksTableViewCell"];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"TracksTableViewCell" owner:self options:nil];
        
        // Load the top-level objects from the custom cell XIB.
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; // avoids selection highlight
    [cell refreshWithUrlSuffix:[self.tracksArray objectAtIndex:indexPath.row]];
    cell.tracksController = self;
    return cell;
}

// ---------- END DATASOURCE METHODS


-(void) refreshCellsList{
    // ----------- START DOCUMENTS FOLDER CRAWLING
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError * error;
    // get all files within the given path, alfabetically sorted
    NSArray *bufferArray = [[[NSFileManager defaultManager]
      contentsOfDirectoryAtPath:documentsDirectory error:&error] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    if(!self.tracksArray){
        self.tracksArray = [[NSMutableArray alloc] init];
    }else{
        [self.tracksArray removeAllObjects];
    }
    
    // Filters files started with @"_buffer". Also inverts the order of the array:
    for (int i = [bufferArray count] - 1; i>=0; i--) {
        if ([(NSString*)bufferArray[i] hasPrefix:@"_buffer"]) {
            NSLog(@" ==== Did not add the file: %@",bufferArray[i]);
        }else{
            NSLog(@" ==== Added the file: %@",bufferArray[i]);
            [self.tracksArray addObject:bufferArray[i]];
        }
    }
}

@end
