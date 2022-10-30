// To parse this JSON data, do
//
//     final nyTimes = nyTimesFromJson(jsonString);

import 'dart:convert';

NyTimes nyTimesFromJson(String str) => NyTimes.fromJson(json.decode(str));

String nyTimesToJson(NyTimes data) => json.encode(data.toJson());

class NyTimes {
  NyTimes({
    this.status,
    this.copyright,
    this.numResults,
    this.lastModified,
    this.results,
  });

  String? status;
  String? copyright;
  int? numResults;
  DateTime? lastModified;
  List<Result>? results;

  factory NyTimes.fromJson(Map<String, dynamic> json) => NyTimes(
        status: json["status"],
        copyright: json["copyright"],
        numResults: json["num_results"],
        lastModified: DateTime.parse(json["last_modified"]),
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "copyright": copyright,
        "num_results": numResults,
        "last_modified": lastModified!.toIso8601String(),
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.listName,
    this.displayName,
    this.bestsellersDate,
    this.publishedDate,
    this.rank,
    this.rankLastWeek,
    this.weeksOnList,
    this.isbns,
    this.bookDetails,
    this.reviews,
  });

  String? listName;
  String? displayName;
  DateTime? bestsellersDate;
  DateTime? publishedDate;
  int? rank;
  int? rankLastWeek;
  int? weeksOnList;

  List<Isbn>? isbns;
  List<BookDetail>? bookDetails;
  List<ReviewsLink>? reviews;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        listName: json["list_name"],
        displayName: json["display_name"],
        bestsellersDate: DateTime.parse(json["bestsellers_date"]),
        publishedDate: DateTime.parse(json["published_date"]),
        rank: json["rank"],
        rankLastWeek: json["rank_last_week"],
        weeksOnList: json["weeks_on_list"],
        isbns: List<Isbn>.from(json["isbns"].map((x) => Isbn.fromJson(x))),
        bookDetails: List<BookDetail>.from(
            json["book_details"].map((x) => BookDetail.fromJson(x))),
        reviews:
            List<ReviewsLink>.from(json["reviews"].map((x) => ReviewsLink.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list_name": listName,
        "display_name": displayName,
        "bestsellers_date":
            "${bestsellersDate!.year.toString().padLeft(4, '0')}-${bestsellersDate!.month.toString().padLeft(2, '0')}-${bestsellersDate!.day.toString().padLeft(2, '0')}",
        "published_date":
            "${publishedDate!.year.toString().padLeft(4, '0')}-${publishedDate!.month.toString().padLeft(2, '0')}-${publishedDate!.day.toString().padLeft(2, '0')}",
        "rank": rank,
        "rank_last_week": rankLastWeek,
        "weeks_on_list": weeksOnList,
        "isbns": List<dynamic>.from(isbns!.map((x) => x.toJson())),
        "book_details": List<dynamic>.from(bookDetails!.map((x) => x.toJson())),
        "reviews": List<dynamic>.from(reviews!.map((x) => x.toJson())),
      };
}

class BookDetail {
  BookDetail({
    this.title,
    // this.description,

    this.author,
    this.primaryIsbn13,
    this.primaryIsbn10,
  });

  String? title;
  //String? description;

  String? author;

  String? primaryIsbn13;
  int? primaryIsbn10;

  factory BookDetail.fromJson(Map<String, dynamic> json) => BookDetail(
        title: json["title"],
        //description: json["description"],

        author: json["author"],

        primaryIsbn13: json["primary_isbn13"],
        primaryIsbn10: json["primary_isbn10"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        //"description": description,

        "author": author,

        "primary_isbn13": primaryIsbn13,
        "primary_isbn10": primaryIsbn10,
      };
}

class Isbn {
  Isbn({
    this.isbn10,
    this.isbn13,
  });

  int? isbn10;
  String? isbn13;

  factory Isbn.fromJson(Map<String, dynamic> json) => Isbn(
        isbn10: json["isbn10"],
        isbn13: json["isbn13"],
      );

  Map<String, dynamic> toJson() => {
        "isbn10": isbn10,
        "isbn13": isbn13,
      };
}

class ReviewsLink {
  ReviewsLink({
    this.bookReviewLink,
    this.sundayReviewLink,
  });

  String? bookReviewLink;

  String? sundayReviewLink;

  factory ReviewsLink.fromJson(Map<String, dynamic> json) => ReviewsLink(
        bookReviewLink: json["book_review_link"],
        sundayReviewLink: json["sunday_review_link"],
      );

  Map<String, dynamic> toJson() => {
        "book_review_link": bookReviewLink,
        "sunday_review_link": sundayReviewLink,
      };
}
