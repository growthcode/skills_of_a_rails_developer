# Quering the database

- ` User.all.each ` #=> what is happening?
    1. Fetch the ENTIRE table in a single pass
    1. Build a model object per row
    1. Put all the model objects into an AR-array.
    1. Hold this entire array in memory.

- ` User.find_each ` #=> what is happening?
    1. Retrieves BATCH of records (at a time).
    1. Yield each record to the block individually.
    1. Repeat process until all records have been processed.
    - To add conditions to a find_each operation you can chain AR methods before the ` find_each `.
    - find_each has a ` :batch_size ` option

- Pure String conditions in a where clause is bad, why?
    - Leaves you vulnerable to SQL injection.
    - Example:
        - ` Client.where("first_name LIKE '%#{params[:first_Name]}'") `

- Search ` LIKE ` stings
    - Search with stings similar
    - putting ` % ` is a wild card and can be put at the begging or end
      - ` User.where("email LIKE ?", '%@gmail.com') `
        - Finds all emails ending with "@gmail.com" (case sensitive)
    - If you want case insensitive search use ` ILIKE `
      - ` User.where("email ILIKE ?", email) `
        - Finds all emails ending with "@gmail.com" (case insensitive)

- Using Array Conditions for SQL
    - AR will go through the first element in the conditions value and any additional elements will replace the question marks ` ? ` in the first element
    - NEVER put your arguments directly into the string conditions... puts whole database at risk.
    - Examples:
        - ` Client.where("orders_count = ?", params[:orders]) `
            - the question mark will be replaced by params[:orders] value
        - ` Client.where("orders_count = ? AND locked = ?", params[:orders], false) `
            - first question mark will be replaced by ` params[:orders] `, second question mark will be replaced by SQL value of ` false `

- Placeholder Conditions
    - Like Using Array conditions but more readable if you have large number of variable conditions.
    - Synatx:
    ```
      Client.where(
        "column_name_01 CONDITIONAL :symbol_name_01 AND
        column_name_02 CONDITIONAL :symbol_name_02 AND
        column_name_03 CONDITIONAL :symbol_name_03 AND
        column_name_04 CONDITIONAL :symbol_name_04 AND
        column_name_05 CONDITIONAL :symbol_name_05 AND
        column_name_06 CONDITIONAL :symbol_name_06",
        {
          symbol_name_01: params[:value_name_01],
          symbol_name_02: params[:value_name_02],
          symbol_name_03: params[:value_name_03],
          symbol_name_04: params[:value_name_04],
          symbol_name_05: params[:value_name_05],
          symbol_name_06: params[:value_name_06],
        }
    )
    ```

- NOT conditions
      ` Article.where.not(author: author) `

- Ordering
    - ` Client.order(:created_at) `
    - ` Client.order("created_at") `
    - ` Client.order(created_at: :desc) `
    - ` Client.order("created_at DESC") `
    - ` Client.order(order_count: :asc, cretated_at: asc) `
    - ` Client.order("orders_count ASC", "created_at ASC") `

- Return select fields, only subset of fields from resulting search rather than whole object.
    - ` Client.select(:name) ` // only clients with names, and only bring back their NAME field
    - ` Client.select(:name).distinct ` // only clients with names, and only bring back their NAME field and only if it is not already found
    - ` Client.select(name: "Hethe") ` // Return all the names that are "Hethe"

- Others modifiers:
    - ` Model.limit(5) ` // return up to 5
    - ` Model.limit(5).offset(10) ` // return up to 5 starting with 11th
    - ` Model.all.count ` // count how many objects

- Grouping Objects, GROUP BY clause:
    - Reorganizes table to do further calculations and manipulations, example: ` HAVING ` requires a ` GROUP BY ` before it will work.
    - Returns single row for each unique combination of what is grouped.
    ```
      Product.
      select("date( created_at) as ordered_date, sum( price) as total_price").
      group("date(created_at)")
    ```

- HAVING clause to specify conditions on the GROUP BY fields
    - Give single product object for every place there is a create_at date.
    ```
      Product.
      select("date( created_at) as ordered_date, sum( price) as total_price").
      group(" date(created_at)").
      having("sum(price) > ?", 100)
    ```

- NULL Relation, ` .none `
    - The ` .none ` method returns a chainable relation with no records.
    - Any subsequent conditions chained to the returned relation will continue generating empty relations.
    - This is useful in scenarious where you need a chainable response to a method or a scope that could return zero results.
    - Example, using a switch statement method on a model where you'll chain additional methods:
        ```
          class Article < ActiveRecord::Base

            def visible_articles
              case role
              when 'Country Manager'
                  Article.where( country: country)
              when 'Reviewer'
                  Article.published
              when 'Bad User'
                  Article.none # = > returning [] or nil breaks the caller code in this case
              end
            end

          end
        ```
        Using the visible_articles method below is expected to return a Relation.
        ```
        @articles = current_user.visible_articles.where( name: params[: name])
        ```
        Without ` Article.none ` it would break when the value returns null

- Dynamic Finders:
    - ` find_by_**atribute** `
    - They won't error if they don't find

- find_by_sql
    ` Client.find_by_sql("asdfasdfasdfasf") `
- select_all
    - Returns array of hashes, with the values of the records
    - Like ` find_by_sql `, but doesn't instantiate objects.
- pluck
    ` Client.where(active:true).pluck(:id) `
    - returns array of values of the column argument
- ids
    - Pluck the ids of a model
    ` Person.ids `
