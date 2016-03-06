# ActiveRecord ` joins `, ` includes `, ` merge `, and ` references `
## ` includes ` uses eager loading whereas ` joins ` uses lazy loading.
### Both of which are powerful but can easily be abused to reduce or overkill performance.
### Each has their OPTIMAL USE CASE, listed at the end.

- Joining Tables
    1. Using a string SQL Fragment
        ```
        Client.joins('
            LEFT OUTER JOIN addresses ON addresses.client_id = clients.id
        ')
        ```
    1. Using Array/Hash of Named Associations
        - only for INNER JOIN
        - Examples with models based on:
          ```
          class Category < ActiveRecord::Base
            has_many :articles
          end

          class Article < ActiveRecord::Base
            belongs_to :category
            has_many :comments
            has_many :tags
          end

          class Comment < ActiveRecord::Base
            belongs_to :article
            has_one :guest
          end

          class Guest < ActiveRecord::Base
            belongs_to :comment
          end

          class Tag < ActiveRecord::Base
            belongs_to :article
          end
          ```
          1. Joining a single association
              ` Category.joins(:articles) `
              - Simple English: "return a Category object for all categories with articles"
              - Note that you will see duplicate categories if more than one article has the same category.
                  -. unique this... ` .uniq ` alias ` .distinct `
                      ` Category.joins(:articles).uniq `
                      ` Category.joins(:articles).distinct `
                      - Simple English: "return a Category object for all categories with articles, no duplicates categories"
          1. Joining Multiple Associations
              ` Article.joins(:category, :comments) `
              - Simple English: "return all articles that have a category and at least one comment"
              - Note that you will see duplicate Articles will show up if they have multiple comments.
                  - unique this...
                      ` Article.joins(:category, :comments).uniq `
                      - Simple English: "return all articles that have a category and at least one comment, no duplicate articles"
          1. Joining NESTED Associations (Single Level)
              ` Article.joins(comments: :guest) `
              - Simple English: "retrun all articles that have a comment made by a guest"
              - unique this... ` .uniq ` alias ` .distinct `
                  ` Article.joins(comments: :guest).uniq `
                  ` Article.joins(comments: :guest).distinct `
          1. Joining NESTED Associations (multiple levels)
              ` Category.joins(articles: [{comments: :guests}, :tag]) `
              - Articles ` has_many :comments ` and ` has_many :tags `
              - Comments ` has_many :guests `
                  - If comments had other ` has_many ` than they would be in an array listed with :guests
    1. Refactor...
        - To clean up code, you can put the includes into a scoped method on the model.
        ```
        class Article < ActiveRecord::Base
            scope :published, -> { where( published: true) }
        end
        ```

- Eager Loading INCLUDES
    - AR lets you specify in advance all the associations that are going to be loaded.
    - This is possible by specifying the includes method of the Model.find call.
    - With INCLUDES AR ensures that all of the specified associations are loaded using the minimum possible queries
    - When to use includes?
        1. Choose the model you will query.
        1. Will you be using any associated models based off this query's results?
            1. YES, then use INCLUDES
            1. NO, then you don't need includes.
    - How to use Includes
        1. Determine all the models and associated models
            - You might also need to know which fields of each model you will be needing.
            - If you have a large return of objects than you may not be able to hold them all in memory. Reducing the number of objects returned (.find_each) or the amount of data in the objects (.select, or sql just feels you need) can help with this.
        1. Nest the associations in the same way you nested the multi level 'joins' searches
            ` Category.includes(articles: [{comments: :guests}, :tag]) `
            - Articles ` has_many :comments ` and ` has_many :tags `
            - Comments ` has_many :guests `
                - If comments had other ` has_many ` than they would be in an array listed with :guests
        1. If you want to modify they Main model search, do so after the INCLUDES ends:
            ` Category.includes(articles: [{comments: :guest }, :tags]).find(1) `
                - find category with id of 1, and load all associated tags and comments made by guests
            - Loads all articles and associated categories and comments for each article
                ` Article.includes(:category, :comments) `
    - Specify conditions on Includes ` where `
        ` Article.includes(:comments).where(comments: {visible: true}) `
        - you can add a ` .where ` clause after the includes is done and add a hash of attributes
        - the *HASH* is very important.  Without that hash you'll get an error.
            - because the query is on the CLASS attached to the ` .includes() `
        - You can use SQL-fragments if you use the ` references ` method to force joined tables.
            - ` Article.includes(:comments).where("comments.visible = true").references(:comments) `
                - The ` references ` shows the ` where ` clause which table to use.

#### Optimal Use Cases

- ` includes `, Eager Loading
    ```
    Company.includes(:persons).where(:persons => { active: true } ).all

    @companies.each do |company|
         company.person.name
    end
    ```
    - Use Case:
        - You know you will be using multiple tables and their columns from your database which are associated to each other.
    - ` .includes ` will eager load the included associations and add them in memory. ` .includes ` loads all the included tables attributes. If you call associations on include query result, it will not fire any queries because they are stored in memory.
    - Set the AR object to a variable. Only this variable will have access to the eager loaded tables.
        - Set variables to reference associated objects FROM this ` include ` object.
        - Doing so will prevent additional queries.
        - Not doing so will make new queries.
    - With ` includes `, Active Record ensures that all of the specified associations are **loaded using the minimum possible number of queries**. This is called eager loading.
    - In other words, when querying a table for data with an associated table, both tables are loaded into memory which in turn reduce the amount of database queries required to retrieve any associated data.

- ` joins `, Lazy Loading
    ```
    Company.joins(:persons).where(:persons => { active: true } ).all

    @companies.each do |company|
         company.name
    end
    ```
    - Use Case:
        - If you want to retrieve all records from 1 table but use another table as a qualifying filter of which records to retrieve.
        - This filtering table will also do NOT want to use any data after the search.
    - If you want to retrieve all companies with an active associated Person record, but I don’t want to display any data from the Person table, than ` joins ` is the correct choice.
    - ` .joins ` will just join the tables and brings selected fields in return. It will not bring the associated table with it... only use information as a filter for the original tables results.
        - If you call associations on joins query result, it will fire database queries again at the moment they are read.
    - The joins method lazy loads the database query by utilizing the associated table, but only loading the Company table into memory as the associated Person table is not required.

#### Reference Websites

- (Includes vs Joins in Rails: When and where?)[http://tomdallimore.com/blog/includes-vs-joins-in-rails-when-and-where/]


## ` #merge(other) `

### Needed on ` joins/includes/scope ` because chaining methods work on the original object

- Merges in the conditions from ` other `, if other is an ActiveRecord::Relation.
    - Returns an array representing the intersection of the resulting records with other, if other is an array.
- Changes the query that #merge is chained to by adding the conditions inside merge (seen here as ` other `) to the query it is touching...
- Note that the syntax is unchanged in how you would apply it...

- Models for example:
    ```
        class Author < ActiveRecord::Base
          has_many :books
        end
    ```

    ```
        class Book < ActiveRecord::Base
          belongs_to :author

          scope :available, ->{ where(available: true) }
        end
    ```

- A way of using a named scope on a joined model
    - ` Author.joins(:books).merge(Book.available) `
    - Without ` merge(Book.available) `, this would have to be written as:
        - ` Author.joins(:books).where("books.available = ?", true) `

## ` #references(:) `

### Use to indicate that the given table_names are referenced by an SQL string, and should therefore be JOINed in any query rather than loaded separately. This method only works in conjunction with includes.

- You can use SQL-fragments if you use the ` references ` method to force joined tables.
    - ` Article.includes(:comments).where("comments.visible = true").references(:comments) `
        - The ` references ` shows the ` where ` clause which table to use.

- Error Example, without ` references ` on ` includes `
    - ` Author.includes(:books).where("books.available = 'foo'") `
    - # => Doesn't JOIN the posts table, resulting in an error.

- Working Example, with ` references ` on ` includes `
    - ` Author.includes(:books).where("books.available = 'foo'").references(:posts) `
    - # => Query now knows the string references posts, so adds a JOIN
