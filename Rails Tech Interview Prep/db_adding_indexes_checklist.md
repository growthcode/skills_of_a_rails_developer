DB indexing checklist:

1. Foreign Keys - Always
1. Polymorphic Conditional Joins - `[plan_id, plan_type]`
1. Unique constraings - `validates :email, :unique => true`
1. Columns used for STI - `where(role: 'Admin')`
1. Columns used by `to_param`, example bing pretty URLs. `/:first_name`
1. State Columns - states of: ['Draft', 'Submitted', 'Published', 'Unpublished']
  - Consider Composite indexes if you have an interface list of all 'Draft' articles with a particular user_id
1. Boolean Columns (sometimes) - Where the boolean is used to filter results
  - Consider indexing IF the boolean is queried and the values are heavily skewed in favor of either true or false and you are selecting the value that has the smaller number.
    - I.E., if the majority of the results are not what you are querying for, add an index
1. DateTime Columns - `ORDER BY created_at` or home page of articles website gets articles `WHERE created_at >= "2010-10-27"`
1. GEM TO HELP
  - https://github.com/plentz/lol_dba
  - https://github.com/bipsandbytes/performance_promise
