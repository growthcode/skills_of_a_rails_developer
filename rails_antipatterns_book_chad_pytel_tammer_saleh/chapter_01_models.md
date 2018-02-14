# Review some basic RoR concepts
  - Class defines characteristis of an object like:
    - what it is __attributes__
    - what it can do __methods__
  - Method exists on a class and defines what the class can do.
  - Encapsulation provieds class moularity and structure of an OOP program.
    - Ideally, the code for a class whould be relatively self contained through encapsulation.
      - Which is the concealment of functional details of a class from other objets that call its methods.
      - Ruby does this with public, protected, and private methods.
  - Models are classes that
    - make up a program.
    - persisted to the pograms database layer.

## Law of Demeter - Principal of Least Knowledge
  - Definition
    - Each unit should have only limited knowledge about other units: only units "closely" related to the current unit.
    - Each unit should only talk to its friends; don't talk to strangers.
    - Only talk to your immediate friends.
  - Rails guideline:
    - Use only 1 dot
      - BAD: @invoice.customer.name
      - OK: @invoice.customer_name
  - Rails `delegate` Method
    - provides a shortcut for indicating that one or more methods that will be created on your object are actually proveded by a related object

## Push `find()` Calls into Finders on the Model
  - Why:
    - Any place where you directly call finders on a model, other than inside the model itself, is a place that decreases readability and maintainability
  - Remove common or complicated quires from the controllers and put them on the model
    - help simplify the controller actions
  - Get logic out of the view

## Keep Finders on Their Own Model
  - A common mistake is to move find calls in to the closest model at hand ignoring proper delegation of responsibilities
    - Implement the queries in the class which holds the instances
    - Uses those named queries in the which starts the search
    - MVC has boundaries.  Delegate domain model responsibilities cleanly.
  - Associations: Goes to the next / previous model instances
  - Scopes (class query) Searches own instances
  - Sometimes you have to choose between different patterns
    - Like using more scopes will violate Law of Demeter but honor MVC.
    - No easy answer, depends greatly on use case and your tastes.

## Delegate Responsibility to New Classes - Single Responsibility Principle (SRP)
  - When code doesn't belong in the class that contains it you should refactor the code into a class of its own.
    - Each class should have it's own distinct responsibilities to decrease coupling and increase maintainability.
  - Why:
    - Having classes take on more than a  single axis of responsibility leads to code that is brittle in the face of changing requirements.
  - Allows for __composition__ in OOP.
    - give functionality of some classes to other classes by calling on those other classes in methods
  - `composed_of` RoR shortcut method for composition

## Make Use of Modules
  - Why:
    - Allows you to extract behavior into separate fields.
      - Namespaces Management of behavior
        - Improve readability by leaving other classes alone and include this module
      - Multiple inheritance through mixins
  - `extend` VS `include`
    - `i`nclude: makes methods `i`nstance methods (both start with I)
    - extend makes them into class methods

## Learn and love Scope Methods
  - Define class methods on your model that can be chained together into one SQL query.
  - Scope is a hash of operations that should be merged into the find call or by a lambda that can take arguments and return a hash
  - Scopes are lazily evaluated!
    - not triggered until you actually try to access the records in the array.
    - So you can chain on more scopes to further refine your eventual result set.

## DRY code -- what it really means
  - Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.
    - About
      - reducing both the opportunity for developer error
      - the effort required to make business logic changes in the applications
    - NOT about:
      - reducing lines of code
  - inheritance (superclasses) VS mixins (modules)
    - Modules are more flexible that superclasses because a class can include as many different modules as it needs to incorporate different sets of behavior.
      - Like multiple inheritance without the complexity.
    - Modules better to use than superclasses, in general
    - Modules methods can modify behavior based on class name, database columns and other associations where inheritence cannot.
      - Modules are evaluated when the classes inherit them.
      - Superclass methods are evaluated on the superclass
  - Modules can be added to a class after the class is defined.

#### Template Pattern
  - What it is: A superclass that implements shared behavior and allows modifications of behavior through overriding of helper methods.
  - Avoid Using because:
    - More natural to use modules than to use a common superclass to implement the template pattern in ruby
    - Have to make a lot of needless design decisions
      - Methods VS Constants
      - Guess at which methods are going to change in the inheritance
        - Which cause you to "Future Proof" the application (which is bad)
      - Methods defined in superclasses which use an ` abstract ` method __must__ will be defined in the Superclass.
        - This will cause a bug if the abstraction should be done in the inherited class.
        - Modules mixin methods are defined where they are included, so abstraction will work.

## Write a Plugin
  - WHen to do:
    - Only when you need to share the code across applications or when you feel the code is valuable to others, should you proceed down the plugin path
