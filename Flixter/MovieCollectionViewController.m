//
//  MovieCollectionViewController.m
//  Flixter
//
//  Created by Myles Block on 6/17/22.
//

#import "MovieCollectionViewController.h"
#import "CollectionViewMovieCell.h"
#import "MovieViewController.m"

@interface MovieCollectionViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *movies;

@end

@implementation MovieCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=66fe3a93e9f4d8ebf87b88234f2739df"];
    //API Key changed to v3
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
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
               [self.collectionView reloadData];
               
           }
       }];
    [task resume];
    // Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view.
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *index = self.collectionView.indexPathsForSelectedItems[0];
    
    NSDictionary *dataToPass = self.movies[index.row];
    InfoPageViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //need Dictionary to pull API request from or something...idk
    //struggle pulling images into collection
    CollectionViewMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:(@"CollectionViewMovieCell") forIndexPath:(indexPath)];
    
    NSDictionary *movie = self.movies[indexPath.row];
    //accessing
//    cell.MovieTitle.text = movie[@"title"];
//    cell.MovieDescription.text = movie[@"overview"];
    
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *completePosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:completePosterURLString];
    [cell.movieImage setImageWithURL:posterURL];
    
    
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;//struggle pulling images into collection

}


@end
