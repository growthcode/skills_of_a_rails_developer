# Scoping in Rails

Scopes (formally “named scopes”) allow you to define and chain query criteria in a declarative and reusable manner.

- To declare a scope, use the scope class method, passing it a name as a symbol and a callable object that includes a query criteria within.
- You can simply use Arel criteria methods such as where, order, and limit to construct the definition
- The queries defined in a scope are only evaluated whenever the scope is invoked.

## Syntax

- Common approach... also known as procedural: ` scope :name, -> { scope_options } `
    - the commonly used and accepted way of writing scoped methods (with a lambda)
    - uses lambda
    - if using a lambda, method is evaluated each time it is used
        - Using ` Time.now ` would be ok because it would be re-defined every time it is used.
    - Example: ` scope :red, -> { where(:color => 'red') } `
    - You can accept arguments with scopes:
        - BUT... Preferred way for arguments is to use class methods.
        - Example with variable: ` scope :colored, ->(color) { where(color: color) } `
    - Note that this scope syntax is simply ‘syntactic sugar’ for defining an actual class method:
    ```
        class Shirt < ActiveRecord::Base
          def self.colored(color)
            where(color: color)
          end
        end
    ```

- Notes:
    - Every real world code samples I have seen use a lambda.
        - Pry for the evaluation of method at time of running.
    - Need to use a Lambda for parameters/arguments
    - One of the benefits of scopes is that you can chain them together to create complex queries from simple ones.


- Other syntax you might see, simplified: ` scope(:name, scope_options = {}) `
    - less desirable way of writing scopes
    - when using ` scope ` method, the method is evaluated when it is defined
        - Using ` Time.now ` would be bad because it would be defined when it is evaluated. Therefore always the same result of the method.
    - can't use parameters/arguments
    - Example: ` scope :red, where(:color => 'red') `
    - Note that this is simply ‘syntactic sugar’ for defining an actual class method:
    ```
        class Shirt < ActiveRecord::Base
          def self.red
            where(color: 'red')
          end
        end
    ```
