// Recuperatorio 2 - Farace, Agustín

use("mflix");

// Ejercicio 1

db.comments.aggregate([
  {
    $lookup: {
      from: "movies",
      localField: "movie_id",
      foreignField: "_id",
      as: "movie_details",
    },
  },
  {
    $unwind: "$movie_details",
  },
  {
    $match: {
      "movie_details.title": "Madagascar",
    },
  },
  {
    $project: {
      _id: 0,
      tituloPelicula: "$movie_details.title",
      textoComentario: "$text",
    },
  },
]);

// Ejercicio 2

db.movies.updateMany(
  {
    year: { $lt: 1975 },
    "imdb.rating": { $type: "number" },
  },
  [
    {
      $set: {
        genres: {
          $cond: {
            if: { $in: ["Classic", { $ifNull: ["$genres", []] }] },
            then: "$genres",
            else: {
              $concatArrays: [{ $ifNull: ["$genres", []] }, ["Classic"]],
            },
          },
        },
        "imdb.rating": {
          $round: [{ $multiply: ["$imdb.rating", 1.1] }, 1],
        },
      },
    },
  ]
);

// Ejercicio 3

db.createView("vista_directores_prolificos", "movies", [
  {
    $unwind: "$directors",
  },
  {
    $group: {
      _id: "$directors",
      cantidad_peliculas: { $sum: 1 },
      rating_promedio: { $avg: "$imdb.rating" },
    },
  },
  {
    $sort: { cantidad_peliculas: -1 },
  },
  {
    $limit: 10,
  },
  {
    $project: {
      _id: 0,
      director: "$_id",
      cantidad_peliculas: 1,
      rating_promedio: 1,
    },
  },
]);

// Ejercicio 4

db.runCommand({
  collMod: "movies",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: [
        "title",
        "year",
        "runtime",
        "type",
        "cast",
        "directors",
        "countries",
        "genres",
      ],
      properties: {
        runtime: {
          bsonType: "int",
          minimum: 1,
          description: "must be an integer greater than 0 and is required",
        },
        type: {
          enum: ["movie", "series"],
          description: "can only be one of the enum values and is required",
        },
        released: {
          bsonType: "date",
          description: "must be a date if the field exists",
        },
        lastUpdated: {
          bsonType: "date",
          description: "must be a date if the field exists",
        },
      },
    },
  },
});

// Elegí validar que released y lastUpdated sean fechas para asegurarme de que
// esas fechas estén en el formato correcto y evitar errores al manipularlas.
// También validé que fullplot sea un string para asegurarme de que el resumen
// completo de la película esté en el formato adecuado.
