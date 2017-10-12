# Command Line Notes

## Parameters
- Example: `$ varname=vardata`
- Parameters store data that can be retrieved through a symbol or a name.
- NOT allowed to have any spaces before or after that equals sign!
- __put double quotes around every parameter expansion!__
    - Subsitiution happens THEN word splitting
    - Without double quites,
        - this: `$ song="My song.mp3"; rm $song`
            - expands to: `$ rm My song.mp3`
        - so do this: `$ song="My song.mp3"; rm "$song"`
    - [substitution examples](https://github.com/growthcode/skills_of_a_rails_developer/blob/master/command_line/substitution%20(variables)%20examples.sh)

## Patterns
- Pattern matching serves two roles in the shell:
    1. selecting filenames within a directory
    1. determining whether a string conforms to a desired format.
- Bash offers three different kinds of pattern matching.
    1. globs
        - simple form of patterns that can easily be used to match
        - `*`, `?`, `[...]`
    2. extended globs
        - allow more complicated expressions than regular globs
            - off by default, to turn on:
                - `shopt -s extglob`
        - `Syntax` matches _____ given patterns
            - `?(list)` 0-1, `*(list)` 0 or more, `+(list)` 1 or more, `@(list)` 1, `!(list)` anything but

                  $ shopt -s extglob
                  $ ls
                  names.txt  tokyo.jpg  california.bmp
                  $ echo !(*jpg|*bmp)
                  names.txt
                  #=> extended glob expands to anything that does not match the *jpg or the *bmp pattern.

    3. regular expressions
        - Since version 3.0
        - You can't use a regular expression to select filenames
            - only globs and extended globs can do that
        - Good Practice:
            - Always use globs instead of ls (or similar) to enumerate files.
                - `for file in *.jpeg; do rm "$file"; done`
                - Globs will always expand safely and minimize the risk for bugs.
                - ls does not and so spacing becomes a concern
        - Extended Regular Expression (ERE) - is the dialect used by Bash
        - Regular Expression patterns that use capturing groups (parentheses) will have their captured strings assigned to the BASH_REMATCH variable for later retrieval.

              $ langRegex='(..)_(..)'
              $ if [[ $LANG =~ $langRegex ]]
              > then
              >     echo "Your country code (ISO 3166-1-alpha-2) is   ${BASH_REMATCH[2]}."
              >     echo "Your language code (ISO 639-1) is   ${BASH_REMATCH[1]}."
              > else
              >     echo "Your locale was not recognised"
              > fi

        - Good Practice:
            - Never quote your regex
            - Keep special characters properly escaped
            - Use variable to store regular expression
                - `re='^\*( >| *Applying |.*\.diff|.*\.patch)'; [[ $var =~ $re ]]`
                - This is much easier to maintain since you only write ERE syntax and avoid the need for shell-escaping, as well as being compatible with all 3.x BASH versions
- Brace Expansion (B.E.)
    - The What: will expand to any possible permutation of their contents
        - i.e. replaced by a list of words
        - Globs only expand to actual filenames
    - Combine with Globs!
        - B.E. happens before File name expansion (globs)
        - After the B.E., the globs are expanded, and we get the filenames as the final result
            - Brace expansions can only be used to generate lists of words
            - They cannon be used for pattern matching, that's what globs and regex are for
    - The How:

          $ echo th{e,a}n
          then than

          # B.E. combined with globs:
          $ echo {/home/*,/root}/.*profile
          /home/axxo/.bash_profile /home/lhunath/.profile /root/.bash_profile   /root/.profile

          $ echo {1..9}
          1 2 3 4 5 6 7 8 9

          $ echo {0,1}{0..9}
          00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19

## Tests and Conditionals
- Tests:
    - determine whether something is true or false.
- Conditionals
    - used to make decisions which determine the execution flow of a script.

1. Exit Status
    - Every command results in an exit code whenever it terminates.
    - Used by whatever application started it to evaluate whether everything went OK.
    - Is like a return value from functions
    - It's an integer between 0 and 255 (inclusive).
    - Status Conventions
        - `0` - success
        - any other number is failure
            - specific number is application specific
    - __Good Practice__
        - Always make sure that your scripts return a non-zero exit code if something unexpected happened in their execution.
            - You can do this with the exit builtin:
                  -  `rm file || { echo 'Could not delete file!' >&2; exit 1; }`
1. Control Operators ( `&&` and `||` )
    - a.k.a. conditional execution
    - These operators are used to link commands together.
        - A way of performing a certain action depending on the success of a previous command.
    - Example:
        - `mkdir d && cd d`
        - `rm /etc/some_file.conf || echo "I couldn't remove the file"`
    - __Good Practice__
        - It's best not to get overzealous when dealing with conditional operators.
        - They can make your script hard to understand, especially for a person that's assigned to maintain it and didn't write it themselves.
1. Grouping Statements
    -  When we have a sequence of commands separated by Conditional Operators, Bash looks at every one of them, in order from left to right.
    - The exit status is carried through from whichever command was most recently executed, and skipping a command doesn't change it.
    - Grouping is done using curly braces
        - `grep -q goodword "$file" && ! grep -q badword "$file" && { rm "$file" || echo "Couldn't delete: $file" >&2; }`
            - (Note: don't forget that you need a semicolon or newline before the closing curly brace!)
    - Without curly braces... "Gotcha":
        - So... `grep -q goodword "$file" && ! grep -q badword "$file" && rm "$file" || echo "Couldn't delete: $file" >&2`
            - So, imagine the first grep fails (sets the exit status to 1).
            - Bash sees a && next, so it skips the second grep altogether.
            - Then it sees another &&, so it also skips the rm which follows that one.
            - Finally, it sees a || operator. Aha!
            - The exit status is "failure", and we have a ||, so Bash executes the echo command, and *tells us that it couldn't delete a file -- even though it never actually tried to!* That's not what we want.
1. 4. Conditional Blocks ( `if`, `test` and `[[` )
    - `test` a.k.a. `[`
    - `[[` is a more advanced version of `test`
        - can do pattern matchging
            - `$ [[ $filename = *.png ]] && echo "$filename looks like a PNG file"`
            - __Gotcha__
                - Regex in quotes becomes value comparision

                      $ name=lhunath foo=[a-z]*
                      $ [[ $name = $foo   ]] && echo "Name $name matches pattern $foo"
                      Name lhunath matches pattern [a-z]*

                      $ [[ $name = "$foo" ]] || echo "Name $name is not equal to the string $foo"
                      Name lhunath is not equal to the string [a-z]*
    - Note that the comparison operators =, !=, >, and < treat their arguments as strings.
        - In order for the operands to be treated as numbers, you need to use one of a different set of operators:
            - `-eq`
            - `-ne` (not equal)
            - `-lt` (less than)
            - `-gt`
            - `-le` (less than or equal to)
            - `-ge`
    - __Good Practice__
        - Whenever you're making a Bash script, you should always use `[[` rather than `[`.
        - Whenever you're making a Shell script, which may end up being used in an environment where Bash is not available, you should use [, because it is far more portable.
            - While being built in to Bash and some other shells, `[` should be available as an external application as well; meaning it will work as argument to, for example, find's -exec and xargs.
1. Conditional Loops (while, until and for)
    - Each loop form is followed by the key word `do`, then one or more commands in the body, then the key word `done`
    - The do and done are similar to the then and `fi` (and possible `elif` and/or `else`) from the `if` statement
    - Types:
        - `while` command
            - Repeat so long as command is executed successfully (exit code is 0).
            - appropriate when
                - we don't know exactly how many times we need to repeat something
                - we simply want it to keep going until we find what we're looking for
        - `until` command
            - Repeat so long as command is executed unsuccessfully (exit code is not 0).
        - `for` loop;
            - Repeat the loop for each word, setting variable to each word in turn.
            - appropriate when
                - we have a list of things, and we want to run through that list sequentially
          - 2 syntaxes
            - for VARIABLE in WORDS
                - Bash takes the characters between in and the end of the line, and splits them up into words
                    - This splitting is done on spaces and tabs, just like argument splitting
                    - However, if there are any unquoted substitutions in there, they will be word-split as well; or use globs for file names
                    - All these split-up words become the iteration elements
                - Brace Expanstion (`{...}`) can be used as well any array or list

                      $ for i in {10..1}
                      > do echo "$i empty cans of beer."
                      > done

            - for (( expression; expression; expression ))
                - Starts by evaluating the first arithmetic expression;
                - repeats the loop so long as the second arithmetic expression is successful;
                - and at the end of each loop evaluates the third arithmetic expression.

                      $ for (( i=10; i > 0; i-- ))
                      > do echo "$i empty cans of beer."
                      > done

1. Choices (`case` and `select`)
    - `case` statement
        - A `case` statement basically enumerates several possible checks the content of your parameter

                case $LANG in
                    en*) echo 'Hello!' ;;
                    fr*) echo 'Salut!' ;;
                    de*) echo 'Guten Tag!' ;;
                    nl*) echo 'Hallo!' ;;
                    it*) echo 'Ciao!' ;;
                    es*) echo 'Hola!' ;;
                    C|POSIX) echo 'hello world' ;;
                    *)   echo 'I do not speak your language.' ;;
                esac

        - `case` stops matching patterns as soon as one is successful.
        - we can use the * pattern in the end to match any case that has not been caught by the other choices... like an "else"
        - Syntax:
            - Each choice
                - consists of a pattern (or a list of patterns with | between them)
                - a right parenthesis
                    - A left parenthesis is optional, adding it to the left of the pattern.
                - a block of code that is to be executed if the string matches one of those patterns
                - two semi-colons to denote the end of the block of code
                    - since you might need to write it on several lines
                - Using ;& instead of ;; will grant you the ability to fall-through the case matching in bash, zsh and ksh

    - `select` statement
        - This statement smells like a loop and is a convenience statement for generating a menu of choices that the user can choose from.

              $ echo "Which of these does not belong in the group?"; \
              > select choice in Apples Pears Crisps Lemons Kiwis; do
              > if [[ $choice = Crisps ]]
              > then echo "Correct!  Crisps are not fruit."; break; fi
              > echo "Errr... no.  Try again."
              > done

    - __Good Practice__
        - A select statement makes a simple menu simple, but it doesn't offer much flexibility.
            - If you want something more elaborate, you might prefer to write your own menu using a while loop, some echo or printf commands, and a read command.

## Arrays
- For the best results and the least headaches, remember that if you have a list of things, you should always put it in an array.
-  Bash does not offer lists, tuples, etc. Just arrays, and associative arrays (which are new in Bash 4).

- Arrays Assumptions
    - Don't assume that your indices are sequential.
        - If the index values matter,
            - always iterate over the indices instead of making assumptions about them.
        - If you loop over the values instead,
            - don't assume anything about which index you might be on currently.
        - Don't assume that just because you're currently in the first iteration of your loop,
            - that you must be on index 0!

- Creating Arrays:
    - `=()` syntax... `$ names=("Bob" "Peter" "$USER" "Big Bad John")`
        - great for creating arrays with
            - static data
            - known set of string parameters
        - downside is it gives us very little flexibility for adding lots of array elements.
    - REMEMBER:
        - Always use globs to generate file names from folder
            - using `ls` will run into errors quite frequently because of white spacing delimiters on file names

                  $ files=($(ls))  # STILL BAD!
                  $ files=(*)      # Good!
    - Creating arrays from data stream
        - [input field separator - IFS](http://mywiki.wooledge.org/IFS)
            - Essentially, it is a string of special characters which are to be treated as delimiters between words/fields when splitting a line of input.
            - Side note:
                - New Line characters are not good because file names could have it (by accident or maliciously)
                - Streams are like strings with three big differences:
                    - they are read sequentially (you usually can't jump around);
                    - they're unidirectional (you can read or write to them, but typically not both);
                    - and they can contain `NUL` bytes.
                - File names cannot contain `NUL` bytes
                    - and neither can the vast majority of human-readable things we would want to store in a script
            - You can combine IFS with "${arrayname[*]}" to indicate the character to use to delimit your array elements as you merge them into a single string.

                      $ names=("Bob" "Peter" "$USER" "Big Bad John")
                      $ ( IFS=,; echo "Today's contestants are: ${names[*]}" )
                      Today's contestants are: Bob,Peter,lhunath,Big Bad John

                - Notice how in this example we put the IFS=,; echo ... statement in a Subshell by wrapping ( and ) around it.
                    - We do this because we don't want to change the default value of IFS in the main shell.
                    - When the subshell exits, IFS still has its default value and no longer just a comma.
                    - This is important because IFS is used for a lot of things, and changing its value to something non-default will result in very odd behavior if you don't expect it!
                - The "${array[*]}" expansion only uses the first character of IFS to join the elements together.
                    - If we wanted to separate the names in the previous example with a comma and a space, we would have to use some other technique (for example, a for loop).)

        - `NUL` a great candidate for separating elements in a stream.
            - Quite often, the command whose output you want to read will have an option that makes it output its data separated by `NUL` bytes rather than newlines or something else. find (on GNU and BSD, anyway) has the option -print0, which we'll use in this example:
                - rather than newlines or something else.
                - `find` (on GNU and BSD, anyway) has the option `-print0`, which we'll use in this example:

                      files=()
                      while read -r -d ''; do
                          files+=("$REPLY")
                      done < <(find /foo -print0)

                - This is a safe way of parsing a command's output into strings.
                    1. The first line `files=()` creates an empty array named files.
                    1. We're using a `while` loop that runs a read command each time.
                        - The read command uses the `-d ''` option to specify the delimiter and it interprets the empty string as a `NUL` byte (`\0`) (as Bash arguments can not contain NULs).
                        - This means that instead of reading a line at a time (up to a newline), we're reading up to a `NUL` byte.
                        It also uses `-r` to prevent it from treating backslashes specially.
                    1. Once `read` has read some data and encountered a `NUL` byte, the `while` loop's body is executed.
                        - We put what we read (which is in the parameter `REPLY`) into our array.
                    1. To do this, we use the `+=()` syntax.
                        - This syntax adds one or more element(s) to the end of our array.
                    1. Finally, the `< <(..)` syntax is a combination of *File Redirection (<)* and *Process Substitution (`<(..)`)*.
                        - Omitting the technical details for now, we'll simply say that this is how we send the output of the find command into our while loop.
                        - The `find` command itself uses the `-print0` option as mentioned before to tell it to separate the filenames it finds with a `NUL` byte.
    - __Good Practice__
        - Arrays are a safe list of strings. They are perfect for storing multiple filenames.
        - If you have to parse a stream of data into component elements, there must be a way to tell where each element starts and ends.
            - The `NUL` byte is very often the best choice for this job.
        - If you have a list of things, keep it in list form as long as possible.
            - Don't smash it into a string or a file until you absolutely have to.
            - If you do have to write it out to a file and read it back in later, keep in mind the delimiter problem we mentioned above.

- Using Arrays
    - Expanding Elements
        - Syntax `"${myfiles[@]}"`
            - is extremely important. It works just like "$@" does for the positional parameters:
            - it expands to a list of words, with each array element as one word, no matter what it contains.

                $ names=("Bob" "Peter" "$USER" "Big Bad John")
                $ for name in "${names[@]}"; do echo "$name"; done
                $
                $ myfiles=(db.sql home.tbz2 etc.tbz2)
                $ cp "${myfiles[@]}" /backups/
                $
                $ names=("Bob" "Peter" "$USER" "Big Bad John")
                $ ( IFS=,; echo "Today's contestants are: ${names[*]}" )
                Today's contestants are: Bob,Peter,lhunath,Big Bad John

      - Get count of Array

            $ array=(a b c)
            $ echo ${#array[@]}
            3

    - Expanding Indices
        - Syntax `"${!arrayname[@]}"`
            - Expands to a list of the indices of an array, in sequential order.

                  $ for i in "${!first[@]}"; do
                  > echo "${first[i]} ${last[i]}"
                  > done
                  Jessica Jones
                  Sue Storm
                  Peter Parker

                  $ a=(a b c q w x y z)
                  $ for ((i=0; i<${#a[@]}; i+=2)); do
                  > echo "${a[i]} and ${a[i+1]}"
                  > done

- Sparse Arrays
    - An array with holes
    - i.e. you can also specify explicit indexes:
        - syntax

              $ names=([0]="Bob" [1]="Peter" [20]="$USER" [21]="Big Bad John")
              $ names[70]="Hethe"
              $ unset 'names[1]'
              $ declare -p names
              declare -a names='([0]="Bob" [20]="hetheberg" [21]="Big Bad John" [70]="Hethe")'
              $ names2=("${names[@]}")
              $ declare -p names2
              declare -a names2='([0]="Bob" [1]="hetheberg" [2]="Big Bad John" [3]="Hethe")'

        - Note that we quoted 'nums[3]' in the unset command.
            - This is because an unquoted nums[3] could be interpreted by Bash as a filename glob.
        - reset a sparse array to seqential array
            - `$ array=("${array[@]}")      # This re-creates the indices.`

    - __Good Practice__
        - Always quote your array expansions properly, just like you would your normal parameter expansions.
        - Use "${myarray[@]}" to expand all your array elements and ONLY use "${myarray[*]}" when you want to merge all your array elements into a single string.

- Associative Arrays (hashes in ruby)
    - Since Bash 4 was released, you can now use full-featured associative arrays.
    - To guarantee backward compatibility with the standard indexed arrays
        - you need to declare it as such (using declare -A).
    - Syntax:

          $ declare -A fullNames
          $ fullNames=( ["lhunath"]="Maarten Billemont" ["greycat"]="Greg Wooledge" )
          $ echo "Current user is: $USER.  Full name: ${fullNames[$USER]}."
          Current user is: lhunath.  Full name: Maarten Billemont.

          $ declare -A dict
          $ dict[astro]="Foo Bar"
          $ declare -p dict
          declare -A dict='([astro]="Foo Bar")'

          $ for user in "${!fullNames[@]}"
          > do echo "User: $user, full name: ${fullNames[$user]}."; done
          User: lhunath, full name: Maarten Billemont.
          User: greycat, full name: Greg Wooledge.

    - Two things to remember
        1. the order of the keys you get back from an associative array using the "${!array[@]}" syntax is unpredictable
            - Associative arrays are not well suited to storing lists that need to be processed in a specific order.
        2. You are required to put the `$` when you are using a parameter as the key of an associative array
            - indexed arrays (normal arrays, not hashes)
                - assumes non integer values surrounded by `[...]` are a parameter since only numbers can be an index
