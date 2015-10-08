# Self Referencing Models

Model that should have a relations to itself.

Example, store has employees.  Every employee has a relationship between a subordinate and manager.

1. Identify a model that should reference itself, employees and subordinates.
1. Migration
    - create a integer/belongs_to/references field to be used for self reference
    - name it in a way that makes sense for the the table and the self referencing relationship
    - this name which will serve as the foreign key to the self-reference relationship
    ```
        class Create Employees < ActiveRecord::Migration
            def change
                create_table :employees do |t|
                    t.belongs_to :manager, index: true

                    t.timestamps null: false
                end
            end
        end
    ```
1. Model
    - has_many :CREATE_NAME_FOR_RELATIONSHIP, class_name: "MODEL_SELF_REFERNCING", foreign_key: "MODEL_SELF_REFERENCE_KEY_FROM_MIGRATION_id"
        - be sure to notice the ` _id ` at the end of ` :MODEL_SELF_REFERENCE_KEY_FROM_MIGRATION_id `
    - ` belongs_to :MODEL_SELF_REFERENCE_KEY_FROM_MIGRATION_id, class_name: MODEL_SELF_REFERNCING `
    ```
        class Employees < ActiveRecord::Base
            has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"
            belongs_to :manager, class_name: "Employee"
        end
    ```
