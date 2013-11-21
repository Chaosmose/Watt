//
//  WIOSSoundManagerTableViewController.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WIOSSoundManagerTableViewController.h"

@interface WIOSSoundManagerTableViewController () <WIOSSOundSelectionProtocol>{
    UIBarButtonItem *_addButton;
    BOOL _hasPushed;
    NSBundle *_wiosBundle;
    
}
@property (assign,nonatomic)    id<WIOSSoundRecorderDelegate>delegate;
@property (nonatomic,strong)    WTMLibrary *library;
@property (nonatomic,strong)    WTMSound *selectedSound;
@property (nonatomic,strong)    WTMSound *tappedSound;
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
    [self setSelectedSound:sound];
    [self setCategoryName:category];
    [self setLibrary:library];
    self.delegate=delegate;
    [self.tableView reloadData];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    _addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                             target:self
                                                             action:@selector(_createSound:)];
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItems = @[_addButton,self.editButtonItem];
}


- (void)setBundleName:(NSString *)bundleName{
    NSString*bundlePath=[[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    if(!bundlePath){
        [NSException raise:@"Missing bundle" format:@"%@",bundleName];
    }
    _wiosBundle=[NSBundle bundleWithPath:bundlePath];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!_wiosBundle)
        [self setBundleName:@"WTMIOS"];
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
    WTMLibrary*library=self.library;
    WTMSound*sound=[wtmAPI createSoundMemberInLibrary:library];
    sound.refererCounter=NSIntegerMax; // We do consider that any sound must be persistent and explicitly deleted.
    sound.category=self.categoryName;
    sound.name=NSLocalizedString(@"New sound name", @"The default sound name to be used on sound creation");
    sound.relativePath=[NSString stringWithFormat:@"%i/%i/%i.caf",sound.library.package.uinstID,sound.library.uinstID,sound.uinstID];
    [_sounds addObject:sound];
    [self.library.registry save];
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
    [cell.editSoundButton setImage:[UIImage imageWithContentsOfFile:[_wiosBundle pathForResource:@"microphone" ofType:@"png"]]forState:UIControlStateNormal];
    cell.delegate=self;
    if(self.selectedSound && [_sounds objectAtIndex:indexPath.row].uinstID ==self.selectedSound.uinstID){
        [[cell selectedSwitch] setOn:YES];
    }else{
        [[cell selectedSwitch] setOn:NO];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
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
        [self.library.registry save];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}





#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WIOSSoundRecorderViewController *vc=[segue destinationViewController];
    vc.sound=self.tappedSound;
}



- (IBAction)editSound:(id)sender {
    WTMSound *sound=(WTMSound*)[_sounds objectAtIndex:[(WIOSButton*)sender indexPath].row];
    self.tappedSound=sound;
    [self performSegueWithIdentifier:@"editSound" sender:sender];
    _hasPushed=YES;
}



#pragma mark - WIOSSOundSelectionProtocol

- (void)selectedIndexPathHasChanged:(NSIndexPath*)indexPath{
    if(indexPath){
        self.selectedSound=(WTMSound*)[_sounds objectAtIndex:indexPath.row];
    }else{
        self.selectedSound=nil;
    }
    if(self.selectedSound){
        [self.delegate selectedSoundIs:self.selectedSound];
    }else{
        [self.delegate noSound];
    }
    [self.tableView reloadData];
}


@end
