CSS3 Man
========
http://www.css3man.com

**An experiment in CSS3.**

The idea behind CSS3 Man is to show users the fun and cool things that can be done entirely in CSS3, and provide some good boilerplate for them to build on top of.

Technology
----------

- [AngularJS](http://angularjs.org) on the frontend.  The power of AngularJS data-binds gives CSS3 Man a real-time feel, so the user has instant feedback.
- [Node.js](http://nodejs.org) on the backend.  I built a wonderful [API module](https://github.com/josephwegner/simple-api) for Node.js, so it's just quickest for me to put everything on Node.
- [MongoDB](http://www.mongodb.org/)/[Mongoose.js](http://mongoosejs.com/) for storage.  I like working in JSON-based document storage, and [Heroku](http://www.heroku.com) has some nice Mongo Addons.

Development
-----------

You'll need three things installd for development:

- Node.js
- Foreman (not required, but it makes things easier)
- MongoDB

To run your development version, go to the root directory and run:

`foreman start -f Procfile.local`

It should now be running on http://localhost:3333

Who
---

[Joe Wegner](http://www.twitter.com/Joe_Wegner) from [WegnerDesign](http://www.wegnerdesign.com)