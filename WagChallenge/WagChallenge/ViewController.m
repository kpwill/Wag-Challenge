//
//  ViewController.m
//  WagChallenge
//
//  Created by Yash Shankar1 on 6/6/18.
//  Copyright © 2018 Kelly Williams. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSDictionary *userInfoDict;
}
@property (weak, nonatomic) IBOutlet UITableView *userTable;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"CustomCell" bundle:[NSBundle mainBundle]];
    [self.userTable registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    [self tableSetUp];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//method to gather and save all the data for the users
- (void) tableSetUp {
    NSString *URLString = @"https://api.stackexchange.com/2.2/users?site=stackoverflow";
    //NSString *URLString = @"https://api.stackexchange.com/2.2/users?page=1&order=desc&sort=reputation&site=stackoverflow";
    
    //configure the session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //complete the session
    [[session dataTaskWithURL:[NSURL URLWithString:URLString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                //NSLog(@"RESPONSE: %@",response);
                //NSLog(@"DATA: %@",data);
                
                if (!error) {
                    // Success
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSError *jsonError;
                        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                        
                        if (jsonError) {
                            // Error Retreveing dictionary from JSON
                            
                        } else {
                            // Success retreveing dictionary from JSON
    
                            //NSLog(@"JSON Response: %@",jsonResponse);
                            
                            //save the dictionary in UserDefaults
                            [[NSUserDefaults standardUserDefaults] setObject:jsonResponse forKey:@"userDict"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
               
                        }
                    }  else {
                        //Web server error
                    }
                } else {
                    // Failure
                    NSLog(@"error : %@", error.description);
                }
            }] resume];
    
    NSDictionary *retrievedDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userDict"];
    userInfoDict = [NSDictionary dictionaryWithDictionary:retrievedDictionary];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //"items" count equivalent to num users on that page
    NSInteger numRows = [[userInfoDict objectForKey:@"items"] count];
    return numRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [self.view addSubview:spinner];
//    spinner.hidesWhenStopped = true;
//    [spinner startAnimating];

    //initialized custom cell
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //get user name
    cell.displayNameLabel.text = [[[userInfoDict objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"display_name"];
    
    //set background color for cell
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = (indexPath.row%2==0) ? [UIColor colorWithRed:0.88 green:0.97 blue:0.98 alpha:1.0] : [UIColor whiteColor];
    cell.backgroundView = backgroundView;
    
    //get badge stats
    int numGolds = [[[[[userInfoDict objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"badge_counts"] objectForKey:@"gold"] intValue];
    int numSilvers = [[[[[userInfoDict objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"badge_counts"] objectForKey:@"silver"] intValue];
    int numBronzes = [[[[[userInfoDict objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"badge_counts"] objectForKey:@"bronze"] intValue];
    
    //set label with # of badges
    cell.goldLabel.text = [NSString stringWithFormat:@"%d gold",numGolds];
    cell.silverLabel.text = [NSString stringWithFormat:@"%d silver", numSilvers];
    cell.bronzeLabel.text = [NSString stringWithFormat:@"%d bronze", numBronzes];
    
    //adjust badge backgrounds depending on amount
    cell.goldRect.frame = CGRectMake(cell.goldRect.frame.origin.x, cell.goldRect.frame.origin.y, .025*numGolds, cell.goldRect.frame.size.height);
    cell.silverRect.frame = CGRectMake(cell.silverRect.frame.origin.x, cell.silverRect.frame.origin.y, .025*numSilvers, cell.silverRect.frame.size.height);
    cell.bronzeRect.frame = CGRectMake(cell.bronzeRect.frame.origin.x, cell.bronzeRect.frame.origin.y, .025*numBronzes, cell.bronzeRect.frame.size.height);
    
    
    //get profile image
    NSURL *imageURL = [NSURL URLWithString:[[[userInfoDict objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"profile_image"]];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    cell.profileImgView.image = [UIImage imageWithData:imageData];
    
    return cell;
}


@end
