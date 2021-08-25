import Foundation

// MARK: - MovieDetailInfo
struct MovieDetailInfo: Codable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: BelongsToCollectionInfo?
    let budget: Int
    let genres: [GenreInfo]
    var genresStr:String {
        guard self.genres.count > 0 else {
            return "N/A"
        }
        return self.genres.map { genresInfo in genresInfo.name }.joined(separator: "/")
    }
    let homepage: String
    let id: Int
    var bookMovieUrl:String {
        "\(Constants.BOOK_MOVIE_URL_PREFIX)\(self.id)"
    }
    let imdbID:String?
    let originalLanguage:String
    let originalTitle:String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompanyInfo]
    let productionCountries: [ProductionCountryInfo]
    let releaseDate: String
    let revenue, runtime: Int
    let spokenLanguages: [SpokenLanguageInfo]
    var spokenLanguagesStr:String {
        guard self.spokenLanguages.count > 0 else {
            return "N/A"
        }
        return self.spokenLanguages.map { spokenLanguageInfo in spokenLanguageInfo.name }.joined(separator: "/")
    }
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - BelongsToCollectionInfo
struct BelongsToCollectionInfo: Codable {
    let id: Int
    let name:String
    let posterPath:String
    let backdropPath:String

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

// MARK: - GenreInfo
struct GenreInfo: Codable {
    let id: Int
    let name: String
}

// MARK: - ProductionCompanyInfo
struct ProductionCompanyInfo: Codable {
    let id: Int
    let logoPath:String?
    let name:String
    let originCountry: String

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountryInfo
struct ProductionCountryInfo: Codable {
    let iso3166_1:String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguageInfo
struct SpokenLanguageInfo: Codable {
    let englishName:String
    let iso639_1:String
    let name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}
