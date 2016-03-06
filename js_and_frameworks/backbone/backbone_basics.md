Backbone.js Hethe Notes
===========================

## Philosophy
- Backbone is an attempt to discover the minimal set of data-structuring (models and collections) and user interface (views and URLs) primitives that are generally useful when building web applications with JavaScript.
  - In a frameworks (like RoR) which very opinionated on how your site to be organized as their default behavior — _Backbone_ should continue to be a tool that gives you the freedom to design the full experience of your web application
- Keep your business logic separate from your user interface _(ajax calls in jQuery)_
  - When the two are entangled, change is hard; when logic doesn't depend on UI, your interface becomes easier to work with.
- Stop tying your data to the DOM
  - For rich client-side applications, a more structured approach is often helpful.
- Represent your data as Models
  - which can be created, validated, destroyed, and saved to the server
  - UI action causes an attribute of a model to change, the model triggers a "change" event
    - all the Views that display the model's state can be notified of the change, so that they are able to respond accordingly
    - when the model changes, the views simply update themselves.


## Model and View
- __Model__
  - Orchestrates data and business logic.
    - Manages an internal table of data attributes, and triggers "change" events when any of its data is modified.
  - Loads and saves from the server.
  - Emits events when data changes.
  - Models should be able to be passed around throughout your app, and used anywhere that bit of data is needed
  - Models should be generally unaware of views.
- __View__
  - Listens for changes and renders UI.
  - Handles user input and interactivity.
  - Sends captured input to the model.
  - Views listen to the model "change" events, and react or re-render themselves appropriately

## Collections
  - Deals with a group of related models
  - Handling the loading and saving of new models to the server
  - Providing helper functions for performing aggregations
  - Computations against a list of models

## API Integration
  - Backbone is pre-configured to sync with a RESTful API
  - Use `url` of your resource endpoint

    ```js
    var Books = Backbone.Collection.extend({
      url: '/books'
    });
    ```

    ```js
    [{"id": 1}] ..... populates a Collection with one model.
    {"id": 1} ....... populates a Model with one attribute.
    ```

    ```js
    GET  /books/ .... collection.fetch();
    POST /books/ .... collection.create();
    GET  /books/1 ... model.fetch();
    PUT  /books/1 ... model.save();
    DEL  /books/1 ... model.destroy();
    ```

    ```js
    // when unexpected object is returned, you'll need to create a `parse` method in your model.
    // Example of bad object returned by an API:
    {
      "page": 1,
      "limit": 10,
      "total": 2,
      "books": [
        {"id": 1, "title": "Pride and Prejudice"},
        {"id": 4, "title": "The Great Gatsby"}
      ]
    }

    // URL `parse` method for the collection of that model
    var Books = Backbone.Collection.extend({
      url: '/books',
      parse: function(data) {
        return data.books;
      }
    });
    ```

## View Rendering
- Each View manages the rendering and user interaction within its own DOM element.
- If you're strict about not allowing views to reach outside of themselves, it helps keep your interface flexible.
  - _Allowing views to be rendered in isolation in any place where they might be needed!_

## Routing with URLs
- Router to update the browser URL whenever the user reaches a new "place" in your app that they might want to bookmark or share.
- Router detects changes to the URL — say, pressing the "Back" button... and can tell your application exactly where you are now.


## Backbone.Events
- Events is a module that can be mixed in to any object.


## Code school questions
