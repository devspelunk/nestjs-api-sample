db.documents.insertMany([
  // MongoDB adds the _id field with an ObjectId if _id is not present
  {
    name: 'Sample Document', tags: ['nestjs', 'api', 'javascript']
  }
]);