//
//  WIOSSoundManagerTableViewController.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WIOSSoundManagerTableViewController.h"

@interface WIOSSoundManagerTableViewController (){
    UIBarButtonItem *_addButton;
}

@property (nonatomic,readonly)  WTMCollectionOfMember *sounds;
@end

@implementation WIOSSoundManagerTableViewController

@synthesize library = _library;
@synthesize sounds = _sounds;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    _addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_createSound:)];
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, _addButton];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setLibrary:(WTMLibrary *)library{
    _library=library;
    _sounds=[library.members filteredCollectionUsingBlock:^BOOL(WTMMember *obj) {
        if([obj isKindOfClass:[WTMSound class]]){
            return YES;
        }else{
            return NO;
        }
    } withRegistry:nil];
}


-(WTMLibrary*)library{
    return _library;
}


- (void) _createSound:(id)sender{
    WTMSound*sound=[wtmAPI createSoundMemberInLibrary:self.library];
    sound.name=NSLocalizedString(@"New sound", @"");
    [_sounds addObject:sound];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_sounds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"soundCell";
    WIOSSoundListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    WTMSound *sound=(WTMSound*)[_sounds objectAtIndex:indexPath.row];
    cell.soundNameLabel.text=sound.name;
    return cell;
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WIOSSoundRecorderViewController *vc=[segue destinationViewController];
    WTMSound *sound=(WTMSound*)[_sounds objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    vc.sound=sound;
    self.selectedSound=sound;
}



@end
