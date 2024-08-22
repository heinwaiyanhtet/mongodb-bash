#!/bin/bash

MONGODB_URL="mongodb://127.0.0.1:27017/public?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.2"

# Check if the MongoDB connection is successful
mongosh "$MONGODB_URL" --eval "db.runCommand({ping: 1})" > /dev/null 2>&1

if [ $? -eq 0 ]; then  
    echo "MongoDB is successful. Proceeding with collection creation..."

    # Generate and insert 1000 documents into Users collection
    user=()
    for i in {1..1000}
    do
        user+=("{\"username\": \"user$i\", \"email\": \"user$i@example.com\", \"password\": \"hashedpassword\", \"created_at\": new Date()}")
    done
    user_joined=$(IFS=,; echo "${user[*]}")
    mongosh "$MONGODB_URL" --eval "
    db.User.insertMany([
    $user_joined
    ]);
    "
    echo "Inserted 1000 users."

    # Generate and insert 1000 documents into Blogs collection
    blog=()
    for i in {1..500}
    do
        blog+=("{\"user_id\": ObjectId(), \"title\": \"Blog Post $i\", \"content\": \"This is the content of blog post $i.\", \"created_at\": new Date(), \"updated_at\": new Date()}")
    done
    blog_joined=$(IFS=,; echo "${blog[*]}")
    mongosh "$MONGODB_URL" --eval "
    db.Blog.insertMany([
    $blog_joined
    ]);
    "
    echo "Inserted 500 blogs."

    # Generate and insert 1000 documents into Comments collection
    comment=()
    for i in {1..1000}
    do
        comment+=("{\"blog_id\": ObjectId(), \"user_id\": ObjectId(), \"comment\": \"This is comment $i.\", \"created_at\": new Date()}")
    done
    comment_joined=$(IFS=,; echo "${comment[*]}")
    mongosh "$MONGODB_URL" --eval "
    db.Comment.insertMany([
    $comment_joined
    ]);
    "
    echo "Inserted 1000 comments."

else
    echo "Failed to connect to MongoDB. Exiting script."
    exit 1
fi
