import 'package:flutter/material.dart';
import 'package:mobile_app_project/data/models/google_books/google_book.dart';
import 'widgets/overview_header.dart';
import 'widgets/overview_paragraph.dart';
import 'widgets/rates_row.dart';
import 'widgets/screen_bar.dart';

class GoogleBookDetailsScreen extends StatelessWidget {
  GoogleBook? googleBook;
  Map<String, dynamic>? allBook;
  GoogleBookDetailsScreen({Key? key, this.googleBook,  this.allBook})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // googleBook = allBook['GoogleBooks'];
    final String? bookName = googleBook?.volumeInfo!.title;
    final String authors = (googleBook?.volumeInfo!.authors).toString();
    final String? imageUrl = googleBook?.volumeInfo?.imageLinks?.thumbnail;
    final num? rating = googleBook?.volumeInfo!.averageRating;
    final num? ratingsCount = googleBook?.volumeInfo!.ratingsCount;
    final num? pagecount = googleBook?.volumeInfo!.pageCount;
    final String? bookDescription = googleBook?.volumeInfo!.description;
    // print(googleBook!.volumeInfo?.imageLinks?.small);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        slivers: [
          ScreenBar(
            bookName: bookName,
            imageUrl: imageUrl,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                RatesRow(
                    rating: rating,
                    ratingsCount: ratingsCount,
                    pagecount: pagecount),
                OverViewHeader(authors: authors),
                OverViewParagraph(bookDescription: bookDescription),
                BlocBuilder<ReviewsCubit,ReviewsState>(
                  builder: (context,state) {
                    if(state.status == ReviewsStatus.submittingReview){
                      return SizedBox(
                          height: MediaQuery.of(context).size.width / 100 * 4,
                          width: MediaQuery.of(context).size.width / 100 * 4,
                          child: Center(child: CircularProgressIndicator()));
                    }
                    else if(state.status == ReviewsStatus.reviewSaved){
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height / 100 * 5,vertical: MediaQuery.of(context).size.height / 100 * 2),
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height / 100 * 5,vertical: MediaQuery.of(context).size.height / 100 * 2),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: HeaderText(text: AppLocalizations.of(context)!.review_submitted,color: Colors.white),
                      );
                    }
                    return ReviewSwitcher();
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
