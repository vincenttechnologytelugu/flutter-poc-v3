// MongoDB Playground
// Use Ctrl+Space inside a snippet or a string literal to trigger completions.

// The current database to use.
use('olx-poc');

// Create a new document in the collection.
db.getCollection('categories').insertOne({
    
      
        "category": "Pets",
        "icon": "https://statics.olx.in/olxin/category_icons/v4/category_103_2x.png",
        "cat_id": "pets"
      
});
