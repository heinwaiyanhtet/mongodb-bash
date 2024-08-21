#!/bin/bash

MONGODB_URL="mongodb://127.0.0.1:27017/public?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.2"

# Check if the MongoDB connection is successful
mongosh "$MONGODB_URL" --eval "db.runCommand({ping: 1})" > /dev/null 2>&1

if [ $? -eq 0 ]; then  # Fixed syntax for if condition
    echo "MongoDB is successful. Proceeding with collection creation..."

    # Generate and insert 1000 documents into Users collection
    users=()
    for i in {1..1000}
    do
        users+=("{\"username\": \"user$i\", \"email\": \"user$i@example.com\", \"password\": \"hashedpassword\", \"created_at\": new Date()}")
    done
    users_joined=$(IFS=,; echo "${users[*]}")
    mongosh "$MONGODB_URL" --eval "
    db.Users.insertMany([
    $users_joined
    ]);
    "
    echo "Inserted 1000 users."

    # Generate and insert 1000 documents into Blogs collection
    blogs=()
    for i in {1..500}
    do
        blogs+=("{\"user_id\": ObjectId(), \"title\": \"Blog Post $i\", \"content\": \"This is the content of blog post $i.\", \"created_at\": new Date(), \"updated_at\": new Date()}")
    done
    blogs_joined=$(IFS=,; echo "${blogs[*]}")
    mongosh "$MONGODB_URL" --eval "
    db.Blogs.insertMany([
    $blogs_joined
    ]);
    "
    echo "Inserted 1000 blogs."

    # Generate and insert 1000 documents into Comments collection
    comments=()
    for i in {1..1000}
    do
        comments+=("{\"blog_id\": ObjectId(), \"user_id\": ObjectId(), \"comment\": \"This is comment $i.\", \"created_at\": new Date()}")
    done
    comments_joined=$(IFS=,; echo "${comments[*]}")
    mongosh "$MONGODB_URL" --eval "
    db.Comments.insertMany([
    $comments_joined
    ]);
    "
    echo "Inserted 1000 comments."

else
    echo "Failed to connect to MongoDB. Exiting script."
    exit 1
fi
