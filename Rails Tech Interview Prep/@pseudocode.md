# Algorithm Challenges & Pseudocode
### How to work through a problem

## Problem Solving Phase
- Analysis & Specification: Understanding the problem
    - Create a high level algorithm.
        - Includes the major parts of a solution but leaves the details until later.
    - By hand, write down a test case and solve that case by hand.
    - Note each step and specifically "how" it worked.
    - Note each step carefully.
    - Explain in words what the task is to someone or Rubberduck it.
    - Problem can be interpreted in many ways
        - Especially in a job interview.
- Design: Describe "how" to solve the problem.
    - Top-Down Design Approach (Modularization)
        - breaking a problem into a set of sub-problems
        - breaking each sub-problem into a set of tasks
        - breaking each task into a set of actions
    - Pseudocode / Flowchart
        - Refine the high level you did in analysis
            - How much detail depends on who is implementing the design and their skill level.
            - When you are learning or in doubt, it is better to have too much detail than not enough.
            - For larger, more complex problems it is common to go through this process several times. Developing intermeidate algorthims as we go.
        - Be Very Specific
        - Zero room for confusion of what these steps mean.
        - Verify each step manually/mentally for some simple input.
            - Do not confuse what "should" happen with what is "actually" happening
            - Pretend you have no idea what the pseudocode is doing when you run through it.
    - Identify familiar tasks, patterns, and repetitions.
        - Familiarity: What is known / unknown? What is this like?
        - Patterns: What is having to be done multiple times?
        - Repetitions / Loops: Specify how the loop iterates.
- Implement the design:
    - Translate each step into a line of code.
    - Check boundary conditions: empty list; dividing by zero.
    - The code should be written incrementally as a series of builds.
        - Each build adds to the previous.
        - Writing tests during each build.
        - Each build adds to the previous one.
        - Adding small pieces one at a time.
        - Rechecking the work so far.
- Test the code
    - Data that should work
    - Data that tests the boundaries
    - Data that would cause the program to crash or return the wrong answer
        - Unless the program is robust enough to take special action
- Review the plan - Refinement. Test the algorithm for correctness.
    - Can this be simplified?
    - Can you make the solution more general?
    - Can you use the solution or method for another problem?
- Review and document.
    - Goal is to be able to solve similar algorithms in the future.
    - What did you learn?
    - What did you use for data structure and why?

## Pseudocode
#### An algorithm can be written in 6 basic computer operations.
#### Start each statement in the sequence with an action word.
#### Capitalize the action word.

- Receive information
- Output information
- Perform arithmetic operation
- Assign a value
- Make decisions - Select a course of action based on comparing information.
- Repeat a group of actions


## Notes:

- There are only 3 basic control structures to any algorithm
  1. Sequence - We go from top down in that order.
  1. Selection - Conditionals: If; Else if; else; Switch-Case statements.
  1. Repetitions - Loops; Iterations;
