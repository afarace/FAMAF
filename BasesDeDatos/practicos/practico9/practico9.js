use("mflix");

// Ejercicio 1
db.runCommand({
  collMod: "users",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "email", "password"],
      properties: {
        name: {
          bsonType: "string",
          maxLength: 30,
        },
        email: {
          bsonType: "string",
          pattern: "^(.*)@(.*)\\.(.{2,4})$",
        },
        password: {
          bsonType: "string",
          minLength: 50,
        },
      },
    },
  },
});

// Insertar 5 documentos validos y 5 invalidos en la coleccion users
db.users.insertMany([
  // Documentos válidos
  {
    name: "Alice",
    email: "alice@example.com",
    password: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234",
  },
  {
    name: "Bob",
    email: "bob@example.com",
    password: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234",
  },
  {
    name: "Charlie",
    email: "charlie@example.com",
    password: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234",
  },
  {
    name: "David",
    email: "david@example.com",
    password: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234",
  },
  {
    name: "Eve",
    email: "eve@example.com",
    password: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234",
  },
  // Documentos inválidos
  {
    name: "Frank",
    email: "frankexample.com", // Email inválido
    password: "short", // Password demasiado corto
  },
  {
    name: "Grace",
    email: "graceexample.com", // Email inválido
    password: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234",
  },
  {
    name: "Heidi",
    email: "heidiexample.com", // Email inválido
    password: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234",
  },
  {
    name: "Ivan",
    email: "ivanexample.com", // Email inválido
    password: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234",
  },
  {
    name: "Judy",
    email: "judyexample.com", // Email inválido
    password: "short", // Password demasiado corto
  },
]);

// Ejercicio 2
db.getCollectionInfos({ name: "users" });

// Ejercicio 3
db.runCommand({
  collMod: "theaters",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["theaterId", "location"],
      properties: {
        theaterId: {
          bsonType: "int",
          description: "must be an integer and is required",
        },
        location: {
          bsonType: "object",
          required: ["address"],
          properties: {
            address: {
              bsonType: "object",
              required: ["street1", "city", "state", "zipcode"],
              properties: {
                street1: {
                  bsonType: "string",
                  description: "must be a string and is required",
                },
                city: {
                  bsonType: "string",
                  description: "must be a string and is required",
                },
                state: {
                  bsonType: "string",
                  description: "must be a string and is required",
                },
                zipcode: {
                  bsonType: "string",
                  description: "must be a string and is required",
                },
              },
            },
            geo: {
              bsonType: "object",
              properties: {
                type: {
                  enum: ["Point", null],
                  description: "can only be one of the enum values",
                },
                coordinates: {
                  bsonType: "array",
                  description: "must be a array",
                  maxItems: 2,
                  minItems: 2,
                  items: {
                    bsonType: "double",
                  },
                },
              },
            },
          },
        },
      },
    },
  },
  validationAction: "warn",
  validationLevel: "moderate",
});

// Ejercicio 4
db.runCommand({
  collMod: "movies",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["title", "year", "cast", "directors", "countries", "genres"],
      properties: {
        title: {
          bsonType: "string",
          description: "must be a string and is required",
        },
        year: {
          bsonType: "int",
          minimum: NumberInt(1900),
          maximum: NumberInt(3000),
          description: "must be an integer in [1900, 3000] and is required",
        },
        cast: {
          bsonType: "array",
          items: {
            bsonType: "string",
          },
          uniqueItems: true,
          description:
            "must be an array of strings with no duplicates and is required",
        },
        directors: {
          bsonType: "array",
          items: {
            bsonType: "string",
          },
          uniqueItems: true,
          description:
            "must be an array of strings with no duplicates and is required",
        },
        countries: {
          bsonType: "array",
          items: {
            bsonType: "string",
          },
          uniqueItems: true,
          description:
            "must be an array of strings with no duplicates and is required",
        },
        genres: {
          bsonType: "array",
          items: {
            bsonType: "string",
          },
          uniqueItems: true,
          description:
            "must be an array of strings with no duplicates and is required",
        },
      },
    },
  },
});

// Ejercicio 5
db.createCollection("userProfiles", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["user_id", "language"],
      properties: {
        user_id: {
          bsonType: "objectId",
          description: "must be an objectId and is required",
        },
        language: {
          enum: ["English", "Spanish", "Portuguese"],
          description: "can only be one of the enum values and is required",
        },
        favorite_genres: {
          bsonType: "array",
          items: {
            bsonType: "string",
          },
          uniqueItems: true,
          description: "must be an array of strings with no duplicates",
        },
      },
    },
  },
});

// Ejercicio 6
db.createCollection("categories", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["category_id", "category_name"],
      properties: {
        category_id: {
          bsonType: "int",
        },
        category_name: {
          bsonType: "string",
          maxLength: 70,
        },
        books: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["book_id", "title", "author", "price"],
            properties: {
              book_id: {
                bsonType: "int",
              },
              title: {
                bsonType: "string",
                maxLength: 70,
              },
              author: {
                bsonType: "string",
                maxLength: 70,
              },
              price: {
                bsonType: "double",
              },
            },
          },
        },
      },
    },
  },
});

// Ejercicio 7
db.categories.insertMany([
  {
    category_id: NumberInt(2),
    category_name: "Science Fiction",
    books: [
      {
        book_id: NumberInt(3),
        title: "The Complete Robot",
        author: "Isaac Asimov",
        price: 12.13,
      },
      {
        book_id: NumberInt(4),
        title: "Foundation and Earth",
        author: "Isaac Asimov",
        price: 11.07,
      },
    ],
  },
  {
    category_id: NumberInt(3),
    category_name: "Historical Mysteries",
    books: [
      {
        book_id: NumberInt(5),
        title: "The Da Vinci Code",
        author: "Dan Brown",
        price: 7.99,
      },
      {
        book_id: NumberInt(6),
        title: "A Column of Fire",
        author: "Ken Follett",
        price: 6.99,
      },
    ],
  },
]);

db.orders.insertMany([
  {
    order_id: NumberInt(1),
    delivery_name: "Pepe",
    delivery_address: "Calle Falsa 123",
    cc_name: "Juan",
    cc_number: "123456789",
    cc_expiry: "12/12",
    order_details: [
      {
        id: NumberInt(1),
        book_id: NumberInt(3),
        title: "Hola",
        author: "Juansito",
        quantity: NumberInt(1),
        price: 12.13,
        order_id: NumberInt(1),
      },
      {
        id: NumberInt(2),
        book_id: NumberInt(4),
        title: "Hola",
        author: "Juansito",
        quantity: NumberInt(1),
        price: 11.07,
        order_id: NumberInt(1),
      },
    ],
  },
]);

// Ejercicio 8
db.articles.insertOne({
  _id: "1",
  user_id: "1",
  title: "some title",
  date: ISODate("..."),
  text: "description",
  url: "some url",
  categories: ["some category"],
  tags: ["some tag name"],
  comments: [
    {
      _id: "1",
      user_id: "1",
      date: ISODate("..."),
      text: "some comment",
    },
  ],
});

db.users.insertOne({
  _id: "1",
  name: "Some name",
  email: "some@example.org",
});

// Query 1:
db.articles.find(
  { user_id: 1 },
  { title: 1, url: 1, tags: 1, categories: 1, _id: 0 }
);

// Query 2:
db.articles.find(
  {
    comments: {
      $elemMatch: { date: { $gte: ISODate("..."), $lte: ISODate("...") } },
    },
  },
  {
    title: 1,
    url: 1,
    comments: {
      $elemMatch: { date: { $gte: ISODate("..."), $lte: ISODate("...") } },
    },
    _id: 0,
  }
);

// Query 3:
db.users.find({ user_id: 1 }, { name: 1, email: 1, _id: 0 });
