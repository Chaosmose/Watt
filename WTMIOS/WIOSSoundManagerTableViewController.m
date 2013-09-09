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
    BOOL _hasPushed;
}
@property (assign,nonatomic)    id<WIOSSoundRecorderDelegate>delegate;
@property (nonatomic,strong)    WTMLibrary *library;
@property (nonatomic,strong)    WTMSound *selectedSound;
@property (nonatomic,readonly)  WTMCollectionOfMember *sounds;
@property (nonatomic,copy)      NSString *categoryName;

@end

@implementation WIOSSoundManagerTableViewController

@synthesize library = _library;
@synthesize sounds = _sounds;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setUpWithSound:(WTMSound*)sound
           fromLibrary:(WTMLibrary*)library
       useCategoryName:(NSString*)category
            anDelegate:(id<WIOSSoundRecorderDelegate>)delegate{
    [self setLibrary:library];
    [self setSelectedSound:sound];
    [self setCategoryName:category];
    self.delegate=delegate;
}


- (void)viewDidLoad{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    _addButton=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add new sound", @"Add new sound")
                                                style:UIBarButtonItemStyleBordered
                                               target:self
                                               action:@selector(_createSound:)];
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItems = @[_addButton,self.editButtonItem];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(_hasPushed){
        [self.tableView reloadData];
    }
    _hasPushed=NO;
}



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setLibrary:(WTMLibrary *)library{
    _library=library;
    WIOSSoundManagerTableViewController *__weak weakSelf=self;
    _sounds=[library.members filteredCollectionUsingBlock:^BOOL(WTMMember *obj) {
        if([obj isKindOfClass:[WTMSound class]] && (!weakSelf.categoryName||[obj.category isEqualToString:weakSelf.categoryName])){
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
    sound.category=self.categoryName;
    sound.name=NSLocalizedString(@"New sound", @"");
    [_sounds addObject:sound];
    [self.tableView reloadData];
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
    cell.editSoundButton.indexPath=indexPath;
    cell.soundNameLabel.text=sound.name;
    if([(WTMSound*)[_sounds objectAtIndex:indexPath.row] isEqual:self.selectedSound]){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}


- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    WTMSound *sound=(WTMSound*)[_sounds objectAtIndex:indexPath.row];
    self.selectedSound=sound;
    [self.delegate selectedSoundIs:sound];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WTMSound *sound=(WTMSound*)[_sounds objectAtIndex:indexPath.row];
        [self.delegate willDeleteSound:sound];
        [wtmAPI removeMember:sound];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



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
    vc.sound=self.selectedSound;
}



- (IBAction)editSound:(id)sender {
    WTMSound *sound=(WTMSound*)[_sounds objectAtIndex:[(WIOSButton*)sender indexPath].row];
    self.selectedSound=sound;
    [self performSegueWithIdentifier:@"editSound" sender:sender];
    _hasPushed=YES;
}
@end
