use('sample_mflix');

const action_movie = db.movies.findOne({ genres: "Action" });
console.log("First Action Movie:", action_movie);

const movies_after_2000 = db.movies.find({ year: { $gt: 2000 } }).limit(5).toArray();
console.log("Movies Released After 2000:", movies_after_2000);

const high_rated_movies = db.movies.find({ "imdb.rating": { $gt: 8.5 } }).limit(5).toArray();
console.log("Movies with IMDb Rating > 8.5:", high_rated_movies);

const action_adventure_movies = db.movies.find({ genres: { $all: ["Action", "Adventure"] } }).limit(5).toArray();
console.log("Action and Adventure Movies:", action_adventure_movies);

const sorted_comedy_movies = db.movies.find({ genres: "Comedy" }).sort({ "imdb.rating": -1 }).limit(5).toArray();
console.log("Sorted Comedy Movies:", sorted_comedy_movies);

const sorted_drama_movies = db.movies.find({ genres: "Drama" }).sort({ year: 1 }).limit(5).toArray();
console.log("Sorted Drama Movies:", sorted_drama_movies);

const avg_rating_by_genre = db.movies.aggregate([
  { $unwind: "$genres" },
  { $group: { _id: "$genres", avg_rating: { $avg: "$imdb.rating" } } },
  { $sort: { avg_rating: -1 } },
  { $limit: 5 }
]).toArray();
console.log("Average Rating by Genre:", avg_rating_by_genre);

const top_directors = db.movies.aggregate([
  { $group: { _id: "$directors", avg_rating: { $avg: "$imdb.rating" } } },
  { $sort: { avg_rating: -1 } },
  { $limit: 5 }
]).toArray();
console.log("Top Directors by IMDb Rating:", top_directors);

const movies_per_year = db.movies.aggregate([
  { $group: { _id: "$year", total_movies: { $sum: 1 } } },
  { $sort: { _id: 1 } }
]).toArray();
console.log("Movies Released Per Year:", movies_per_year);

const update_godfather = db.movies.updateOne({ title: "The Godfather" }, { $set: { "imdb.rating": 9.5 } });
console.log("Updated IMDb Rating for 'The Godfather':", update_godfather);

const update_horror = db.movies.updateMany({ genres: "Horror", "imdb.rating": { $exists: false } }, { $set: { "imdb.rating": 6.0 } });
console.log("Updated IMDb Rating for Horror Movies:", update_horror);

const delete_old_movies = db.movies.deleteMany({ year: { $lt: 1950 } });
console.log("Deleted Movies Released Before 1950:", delete_old_movies);

db.movies.createIndex({ title: "text" }); 
const love_movies = db.movies.find({ $text: { $search: "love" } }).toArray();
console.log("Movies with 'Love' in the Title:", love_movies);

db.movies.createIndex({ title: "text", plot: "text" });
const war_movies = db.movies.find({ $text: { $search: "war" } }).sort({ "imdb.rating": -1 }).limit(5).toArray();
console.log("Movies with 'War' in Title or Plot:", war_movies);

const action_high_rated_movies = db.movies.find({ genres: "Action", "imdb.rating": { $gt: 8 } }).sort({ year: -1 }).toArray();
console.log("High Rated Action Movies Sorted by Year:", action_high_rated_movies);

const nolan_movies = db.movies.find({ directors: "Christopher Nolan", "imdb.rating": { $gt: 8 } }).sort({ "imdb.rating": -1 }).limit(3).toArray();
console.log("Christopher Nolan Movies with IMDb > 8:", nolan_movies);
