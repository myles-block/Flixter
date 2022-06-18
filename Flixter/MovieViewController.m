//
//  MovieViewController.m
//  Flixter
//
//  Created by Myles Block on 6/16/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageview+AFNetworking.h"
#import "InfoPageViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (nonatomic, strong) NSArray *movies;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Start the activity indicator
    [self.ActivityIndicator startAnimating];//doesn't animate

    self.TableView.dataSource = self;
    self.TableView.delegate = self;
    
    // Stop the activity indicator
    // Hides automatically if "Hides When Stopped" is enabled
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=66fe3a93e9f4d8ebf87b88234f2739df"];
    //API Key changed to v3
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               [self.ActivityIndicator stopAnimating];//doesn't work
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
//               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               // TODO: Get the array of movies
               self.movies = dataDictionary[@"results"];
               for (NSDictionary *movies in self.movies)
               {
                   NSLog(@"%@", movies[@"title"]);
               }
//               NSLog(@"%@", dataDictionary);
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               [self.TableView reloadData];
               
           }
       }];
    [task resume];
    // Do any additional setup after loading the view.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.h
    NSIndexPath *index = self.TableView.indexPathForSelectedRow;
    
    NSDictionary *dataToPass = self.movies[index.row];
    InfoPageViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.movies[indexPath.row];
    //accessing
    cell.MovieTitle.text = movie[@"title"];
    cell.MovieDescription.text = movie[@"overview"];
    
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *completePosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:completePosterURLString];
    [cell.MovieImage setImageWithURL:posterURL];
    
    
    
    return cell;
}


@end
