use("mflix");

// Ejercicio 1
db.theaters.aggregate([
  {
    $group: {
      _id: "$location.address.state",
      totalTheaters: { $sum: 1 },
    },
  },
  {
    $project: { _id: 1, totalTheaters: 1 },
  },
]);

// Ejercicio 2
db.theaters.aggregate([
  {
    $group: {
      _id: "$location.address.state",
      totalTheaters: { $sum: 1 },
    },
  },
  {
    $match: { totalTheaters: { $gte: 2 } },
  },
  {
    $project: { _id: 1, totalTheaters: 1 },
  },
]);

// Ejercicio 3
// Sin pipeline de agregación
db.movies.countDocuments({ directors: { $in: ["Louis Lumière"] } });

// Con pipeline de agregación
db.movies.aggregate([
  { $match: { directors: { $in: ["Louis Lumière"] } } },
  { $group: { _id: null, count: { $sum: 1 } } },
  { $project: { _id: 0, count: 1 } },
]);

// Otra forma de hacerlo
db.movies.aggregate([
  {
    $match: { directors: "Louis Lumière" },
  },
  {
    $count: "totalMovies",
  },
]);

// Ejercicio 4
// Sin pipeline de agregación
db.movies.countDocuments({
  released: {
    $gte: ISODate("1950-01-01T00:00:00Z"),
    $lte: ISODate("1959-12-31T23:59:59Z"),
  },
});

// Con pipeline de agregación
db.movies.aggregate([
  {
    $match: {
      released: {
        $gte: ISODate("1950-01-01T00:00:00Z"),
        $lte: ISODate("1959-12-31T23:59:59Z"),
      },
    },
  },
  {
    $count: "totalMovies50s",
  },
]);

// Ejercicio 5
db.movies.aggregate([
  { $unwind: "$genres" },
  { $group: { _id: "$genres", totalMovies: { $sum: 1 } } },
  { $sort: { totalMovies: -1 } },
  { $limit: 10 },
]);

// Ejercicio 6
db.comments.aggregate([
  {
    $group: {
      _id: { name: "$name", email: "$email" },
      totalComments: { $sum: 1 },
    },
  },
  { $sort: { totalComments: -1 } },
  { $limit: 10 },
  {
    $project: {
      _id: 0,
      name: "$_id.name",
      email: "$_id.email",
      totalComments: 1,
    },
  },
]);

// Ejercicio 7
db.movies.aggregate([
  {
    $match: {
      released: {
        $gte: ISODate("1980-01-01T00:00:00Z"),
        $lte: ISODate("1989-12-31T23:59:59Z"),
      },
      "imdb.rating": { $exists: true, $ne: null, $type: "number" },
    },
  },
  {
    $group: {
      _id: { $year: "$released" },
      avg: { $avg: "$imdb.rating" },
      max: { $max: "$imdb.rating" },
      min: { $min: "$imdb.rating" },
    },
  },
  { $sort: { avg: -1 } },
]);

// Ejercicio 8
db.movies.aggregate([
  {
    $lookup: {
      from: "comments",
      localField: "_id",
      foreignField: "movie_id",
      as: "movie_comments",
    },
  },
  {
    $project: {
      _id: 0,
      title: 1,
      year: { $year: "$released" },
      num_comments: { $size: "$movie_comments" },
    },
  },
  { $sort: { num_comments: -1 } },
  { $limit: 10 },
]);

db.movies.aggregate([
  {
    $sort: { num_mflix_comments: -1 },
  },
  { $limit: 10 },
  {
    $project: {
      _id: 0,
      title: 1,
      year: { $year: "$released" },
      num_comments: "$num_mflix_comments",
    },
  },
]);

// Ejercicio 9
db.createView("top5GenresByComments", "movies", [
  {
    $lookup: {
      from: "comments",
      localField: "_id",
      foreignField: "movie_id",
      as: "movie_comments",
    },
  },
  { $unwind: "$genres" },
  {
    $group: {
      _id: "$genres",
      totalComments: { $sum: { $size: "$movie_comments" } },
    },
  },
  { $sort: { totalComments: -1 } },
  { $limit: 5 },
]);

// Ejercicio 10
db.movies.aggregate([
  {
    $match: { directors: "Jules Bass" },
  },
  {
    $unwind: "$cast",
  },
  {
    $group: {
      _id: "$cast",
      movies: {
        $push: {
          title: "$title",
          year: { $year: "$released" },
        },
      },
      movieCount: { $sum: 1 },
    },
  },
  {
    $match: { movieCount: { $gte: 2 } },
  },
  {
    $project: {
      _id: 0,
      actor: "$_id",
      movies: 1,
    },
  },
]);

// Ejercicio 11
db.comments.aggregate([
  {
    $lookup: {
      from: "movies",
      let: { movieId: "$movie_id", commentDate: "$date" },
      pipeline: [
        {
          $match: {
            $expr: {
              $and: [
                { $eq: ["$_id", "$$movieId"] },
                {
                  $eq: [{ $month: "$released" }, { $month: "$$commentDate" }],
                },
                {
                  $eq: [{ $year: "$released" }, { $year: "$$commentDate" }],
                },
              ],
            },
          },
        },
      ],
      as: "matched_movies",
    },
  },
  {
    $unwind: "$matched_movies",
  },
  {
    $project: {
      _id: 0,
      name: 1,
      email: 1,
      comment_date: "$date",
      movie_title: "$matched_movies.title",
      movie_released: "$matched_movies.released",
    },
  },
]);

// Ejercicio 12

use("restaurantdb");

// Listar el id y nombre de los restaurantes junto con su puntuación máxima, mínima y la
// suma total. Se puede asumir que el restaurant_id es único.
// a.​ Resolver con $group y accumulators.
// b.​ Resolver con expresiones sobre arreglos (por ejemplo, $sum) pero sin $group.c.​ Resolver como en el punto b) pero usar $reduce para calcular la puntuación
// total.
// d.​ Resolver con find.

// a. Con $group y accumulators
db.restaurants.aggregate([
  {
    $unwind: "$grades",
  },
  {
    $group: {
      _id: { id: "$restaurant_id", name: "$name" },
      maxScore: { $max: "$grades.score" },
      minScore: { $min: "$grades.score" },
      totalScore: { $sum: "$grades.score" },
    },
  },
  {
    $project: {
      _id: 0,
      restaurant_id: "$_id.id",
      name: "$_id.name",
      maxScore: 1,
      minScore: 1,
      totalScore: 1,
    },
  },
]);

// b. Con expresiones sobre arreglos pero sin $group
db.restaurants.aggregate([
  {
    $project: {
      _id: 0,
      restaurant_id: 1,
      name: 1,
      maxScore: { $max: "$grades.score" },
      minScore: { $min: "$grades.score" },
      totalScore: { $sum: "$grades.score" },
    },
  },
]);

// c. Con $reduce para calcular la puntuación total
db.restaurants.aggregate([
  {
    $project: {
      _id: 0,
      restaurant_id: 1,
      name: 1,
      maxScore: { $max: "$grades.score" },
      minScore: { $min: "$grades.score" },
      totalScore: {
        $reduce: {
          input: "$grades.score",
          initialValue: 0,
          in: { $add: ["$$value", "$$this"] },
        },
      },
    },
  },
]);

// d. Con find
db.restaurants.find(
  {},
  {
    _id: 0,
    restaurant_id: 1,
    name: 1,
    maxScore: { $max: "$grades.score" },
    minScore: { $min: "$grades.score" },
    totalScore: { $sum: "$grades.score" },
  }
);

// Ejercicio 13
db.restaurants.updateMany({}, [
  {
    $set: {
      average_score: { $avg: "$grades.score" },
    },
  },
  {
    $set: {
      grade: {
        $switch: {
          branches: [
            {
              case: { $lte: ["$average_score", 13] },
              then: "A",
            },
            {
              case: {
                $and: [
                  { $gte: ["$average_score", 14] },
                  { $lte: ["$average_score", 27] },
                ],
              },
              then: "B",
            },
            {
              case: { $gte: ["$average_score", 28] },
              then: "C",
            },
          ],
          default: "N/A",
        },
      },
    },
  },
]);
