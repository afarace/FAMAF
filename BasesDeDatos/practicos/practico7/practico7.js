use("mflix");

// Parte I

// Ejercicio 1
db.users.insertMany([
  { name: "Juan", age: 23, email: "juan@@gameofthron.es" },
  { name: "Ana", age: 24, email: "ana@@gameofthron.es" },
  { name: "Pedro", age: 22, email: "pedro@@gameofthron.es" },
  { name: "Lucia", age: 21, email: "lucia@@gameofthron.es" },
  { name: "Miguel", age: 25, email: "miguel@@gameofthron.es" },
]);

db.comments.insertMany([
  {
    name: "Juan",
    email: "juan@@gameofthron.es",
    movie_id: ObjectId("573a1390f29313caabcd4135"),
    text: "Great movie!",
    date: ISODate("2020-01-01T00:00:00Z"),
  },
  {
    name: "Ana",
    email: "ana@@gameofthron.es",
    movie_id: ObjectId("573a1390f29313caabcd4135"),
    text: "I loved it!",
    date: ISODate("2020-01-02T00:00:00Z"),
  },
  {
    name: "Pedro",
    email: "pedro@@gameofthron.es",
    movie_id: ObjectId("573a1390f29313caabcd4135"),
    text: "Not my type of movie.",
    date: ISODate("2020-01-03T00:00:00Z"),
  },
  {
    name: "Lucia",
    email: "lucia@@gameofthron.es",
    movie_id: ObjectId("573a1390f29313caabcd4135"),
    text: "Amazing cinematography!",
    date: ISODate("2020-01-04T00:00:00Z"),
  },
  {
    name: "Miguel",
    email: "miguel@@gameofthron.es",
    movie_id: ObjectId("573a1390f29313caabcd4135"),
    text: "A bit too long for my taste.",
    date: ISODate("2020-01-05T00:00:00Z"),
  },
]);

// Ejercicio 2
db.movies
  .find(
    { year: { $gte: 1990, $lte: 1999 }, "imdb.rating": { $type: "double" } },
    { _id: 0, title: 1, year: 1, cast: 1, directors: 1, "imdb.rating": 1 }
  )
  .sort({ "imdb.rating": -1 })
  .limit(10);

// Ejercicio 3
db.comments
  .find(
    {
      movie_id: { $eq: ObjectId("573a1399f29313caabcee886") },
      date: {
        $gte: ISODate("2014-01-01T00:00:00Z"),
        $lte: ISODate("2016-12-31T23:59:59Z"),
      },
    },
    { _id: 0, name: 1, email: 1, date: 1 }
  )
  .sort({ date: 1 });

// Cuantos comentarios recibio?

db.comments.countDocuments({
  movie_id: { $eq: ObjectId("573a1399f29313caabcee886") },
  date: {
    $gte: ISODate("2014-01-01T00:00:00Z"),
    $lte: ISODate("2016-12-31T23:59:59Z"),
  },
});

// Ejercicio 4
db.comments
  .find(
    { email: { $eq: "patricia_good@fakegmail.com" } },
    { _id: 0, name: 1, movie_id: 1, text: 1, date: 1 }
  )
  .sort({ date: -1 })
  .limit(3);

// Ejercicio 5
db.movies
  .find(
    {
      genres: { $all: ["Drama", "Action"] },
      languages: { $size: 1 },
      $or: [{ "imdb.rating": { $gt: 9 } }, { runtime: { $gte: 180 } }],
    },
    {
      _id: 0,
      languages: 1,
      genres: 1,
      released: 1,
      "imdb.votes": 1,
    }
  )
  .sort({ released: -1 }, { "imdb.votes": 1 });

// Ejercicio 6
db.theaters
  .find(
    {
      $and: [
        { "location.address.state": { $in: ["CA", "NY", "TX"] } },
        { "location.address.city": /^F/ },
      ],
    },
    {
      _id: 0,
      "location.address.state": 1,
      "location.address.city": 1,
      "location.geo.coordinates": 1,
    }
  )
  .sort({ "location.address.state": 1 }, { "location.address.city": 1 });

// Ejercicio 7
db.comments.updateOne(
  { _id: ObjectId("5b72236520a3277c015b3b73") },
  { $set: { text: "mi mejor comentario", date: new Date() } }
);

// Ejercicio 8
db.users.updateOne(
  { email: "joel.macdonel@fakegmail.com" },
  { $set: { password: "some password" } },
  { upsert: true }
);

/* Al ejecutarla realiza las operaciones:

{
  acknowledged: true,
  insertedId: ObjectId('6919e227000595de0f09e5a1'),
  matchedCount: 0,
  modifiedCount: 0,
  upsertedCount: 1
}

Al ejecutarla por segunda vez:

{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 0,
  upsertedCount: 0
}

*/

// Ejercicio 9
db.comments.deleteMany({
  email: "victor_patel@fakegmail.com",
  date: {
    $gte: ISODate("1980-01-01T00:00:00Z"),
    $lte: ISODate("1989-12-31T23:59:59Z"),
  },
});

// Parte II

use("restaurantdb");

// Ejercicio 10
db.restaurants.find(
  {
    grades: {
      $elemMatch: {
        date: {
          $gte: ISODate("2014-01-01T00:00:00Z"),
          $lte: ISODate("2015-12-31T23:59:59Z"),
        },
        score: { $gt: 70, $lte: 90 },
      },
    },
  },
  { _id: 0, restaurant_id: 1, grades: 1 }
);

// Ejercicio 11
db.restaurants.updateOne(
  { restaurant_id: "50018608" },
  {
    $push: {
      grades: {
        $each: [
          {
            date: ISODate("2019-10-10T00:00:00Z"),
            grade: "A",
            score: 18,
          },
          {
            date: ISODate("2020-02-25T00:00:00Z"),
            grade: "A",
            score: 21,
          },
        ],
      },
    },
  }
);
