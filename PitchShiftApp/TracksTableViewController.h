//
//  TracksTableViewController.h
//  PitchShiftApp
//
//  Created by Marcelo Henrique Salloum dos Santos on 10/1/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

@interface TracksTableViewController : UIViewController <UITableViewDataSource>{
}

@property (nonatomic, readwrite) BOOL isPlaying;
@property (nonatomic,retain) NSArray *tracksArray;
@property (nonatomic,retain) IBOutlet UITableView *tracksTableView;

-(void) refreshCellsList;

@end
