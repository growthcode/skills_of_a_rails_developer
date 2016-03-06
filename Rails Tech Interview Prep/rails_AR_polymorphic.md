# Polymorphic Association Rails Setup

1. Identify a model that could belong to multiple other models, referred to as Picture Model for now on.
1. In the migration of Picture Model, the normal "foreign key" shall be replaced by two fields, based on a name referencing the Picture Model
    1. Need to create a polymorphic name for the polymorphic association. It should relate to the model.
        - ` :imageable `, for a Picture model you might call it ` :imageable `.
    1. Create Foreign key using the polymorphic name with '_id' after it. This will be an integer.
        - ` :imageable_id ` - This will be used as the foreign key to the association.
    1. Create a Source TYPE using polymorphic name with '_type' after it. This will be a string. It is used to identify which model the instance belongs to.
        ` :imageable_type ` - (string) This will show us which model this instance comes from.
1. In the Polymorphic model, add
    - ` belongs_to :polymorphic_name, polymorphic: true `
    - example for pictures
        - ` belongs_to :imageable, polymorphic: true `
1. On each of the models that ` has_many ` this polymorphic model, add the ` has_many ` using the normal models name and then adding ` as: :polymorphic_name `, example:
    - ` has_many :model, as: :polymorphic_name `
    - example for pictures:
        - ` has_many :pictures, as: :imageable `
1. If there is a ` has_many :through ` relationship, you'll need to do them like the following... here we have a professor who has many TAs but also wants to know which TAs belong to Which Class.
    - Polymorphic migration:
    ```
        class CreateTeachingAssistants < ActiveRecord::Migration
          def change
            create_table :teaching_assistants do |t|
              t.string :name
              t.integer :ta_duty_id, index: true // reference foreign key of instance
              t.string :ta_duty_type, index: true // reference class of instance
              #=> or // t.references :ta_duty, polymorphic: true, index: true // does both _type and _id

              t.timestamps
            end
          end
        end
    ```
    - Polymorphic model:
    ```
        class TeachingAssistant < ActiveRecord::Base
          belongs_to :professors
          belongs_to :ta_duty, polymorphic: true
        end
    ```
    - has_many model 1:
    ```
        class Course < ActiveRecord::Base
            has_many :teaching_assistants, as: :ta_duty
        end
    ```
    - has_many model 2:
    ```
        class Lab < ActiveRecord::Base
            has_many :teaching_assistants, as: :ta_duty
        end
    ```
    - has_many :through:
    ```
       class Professor < ActiveRecord::Base
          has_many :teaching_assistants
          has_many :course_tas, through: :teaching_assistants, source: :ta_duty, source_type: 'Course'
          has_many :lab_tas, through: :teaching_assistants, source: :ta_duty, source_type: 'Lab'
        end
    ```
    - Notice how on the has_many :through...
        - creating model name to reference on the spot: ` :course_tas ` and ` :lab_tas `
        - has_many :NEW_MODEL_REFERENCE_NAME, through: :POLYMORIPHIC_MODEL, source: :POLYMORPHIC_NAME, source_type: 'ASSOCIATED_MODEL_THAT_IT_GOES_THROUGH'
- inverse_of does not work on polymorphic associations
- ` t.references `
    - can write migration in two ways:
        - ` _id ` and ` _type `
            ```
                t.integer :ta_duty_id, index: true
                t.string :ta_duty_type, index: true
            ```
        - or ` t.references `
            ```
                t.references :ta_duty, polymorphic: true, index: true
            ```
