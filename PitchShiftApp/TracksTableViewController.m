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

@synthesize tracksTableView, tracksArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Tracks";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshCellsList];
    [self.tracksTableView setDataSource:self];
    
    //Changes background image:
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"PSA_0.2_Background.png"]];
    self.tracksTableView.backgroundColor = background;
    self.view.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Unselect the selected row if any
    NSIndexPath* selection = [self.tracksTableView indexPathForSelectedRow];
    if (selection) {
        [self.tracksTableView deselectRowAtIndexPath:selection animated:YES];
    }
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
    if(!self.tracksArray){
        self.tracksArray = [[NSArray alloc] init];
    }
    self.tracksArray =  [[NSFileManager defaultManager]
                         contentsOfDirectoryAtPath:documentsDirectory error:&error];
    NSLog(@"tracks array ==== %@",self.tracksArray);
    // ----------- FINISH DOCUMENTS FOLDER CRAWLING
}

@end
